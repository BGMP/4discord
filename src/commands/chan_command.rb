# frozen_string_literal: true

# Node bot command

class ChanCommand
  require 'nokogiri'
  require 'time-hash'

  DEFAULT_BOARD      = 'b'
  POST_EMBED_COLOUR  = '#9b1f1f'
  REPLY_EMBED_COLOUR = '#dd2929'
  EXPIRE_LATEST_PULL = 900               # 15 minutes
  EXPIRE_LATEST_BOARD = 900              # 15 minutes
  WINNERS_FILE_PATH = '../config/winners.txt'

  def register(bot, db, config)
    @latest_pulls = TimeHash.new         # Latest posts randomly pulled by /chan. { :channel_id => post } map
    @latest_board = TimeHash.new         # Latest boards /chan pulled a post from. { :channel_id => board } map

    bot.command(:chan,
                :description => 'Main command for fetching random 4chan posts and replies',
                :usage => '/chan <board | replies>',
                :min_args => 0,
                :max_args => 1,
                :rescue => 'An internal exception has occurred.') do |event, board|
      return if event.message.channel.type != 0

      row = db.execute('SELECT * FROM channels WHERE server_id = ?', [event.server.id])
      if row.empty?
        return "<@#{bot.profile.id}> is not hooked to any channel on this discord server!\n" \
        ' » Use `/4channel <channel>` to hook it up!'
      else
        hooked_channel = row[0][1]

        return unless event.channel.id.eql?(hooked_channel)
      end

      unless event.channel.nsfw
        return "Channel `##{event.channel.name}` must be NSFW!\n" \
        ' » https://support.discord.com/hc/en-us/articles/115000084051-NSFW-channels-and-content'
      end

      channel_id = event.channel.id.to_s
      latest = @latest_pulls[channel_id]

      if board.nil?
        board = DEFAULT_BOARD
      elsif board.eql?('replies')
        if latest.nil?
          return "You either haven't pulled a post using /chan yet, or replies cannot be fetched at this time (only available for 15 minutes after pulling)."
        else

          replies = latest['last_replies']

          if replies.nil? || replies.empty?
            bot.channel(channel_id).send_embed do |embed|
              embed.description = 'This post has no replies.'
            end
          else
            replies[0..5].each do |reply|
              file_url = ChanAPI.get_media_url(@latest_board[channel_id], reply['tim'], reply['ext'])

              bot.channel(channel_id).send_embed do |embed|
                embed.title = "#{reply['name']} No. #{reply['no']}"
                embed.colour = REPLY_EMBED_COLOUR
                embed.description = Nokogiri::HTML(reply['com']).text
                embed.image = Discordrb::Webhooks::EmbedImage.new(
                  :url => file_url
                )
              end

              return file_url.to_s if !reply['ext'].nil? && reply['ext'].eql?('.webm')
            end
          end

          return
        end
      end

      board = ChanBoards.name_to_board_slug(board.downcase)
      return 'Invalid board!' if board.nil?

      page = rand(0..9)
      thread_number = page.zero? ? rand(1..10) : rand(0..9)

      post = ChanAPI.get_post(board, page, thread_number)

      @latest_pulls.put(channel_id, post, EXPIRE_LATEST_PULL)
      @latest_board.put(channel_id, board, EXPIRE_LATEST_BOARD)

      file_url = ChanAPI.get_media_url(board.to_s, post['tim'], post['ext'])
      comment = post['com'].nil? ? '' : post['com'].gsub('<br>', "\n")

      bot.channel(channel_id).send_embed do |embed|
        embed.title = "#{post['name']} No. #{post['no']}"
        embed.colour = POST_EMBED_COLOUR
        embed.description = Nokogiri::HTML(comment).text
        embed.add_field(:name => 'Link',
                        :value => ChanAPI.get_thread_url(board, post['no']))
        embed.image = Discordrb::Webhooks::EmbedImage.new(
          :url => file_url
        )
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(
          :text => "API » Page #{page} » Thread #{thread_number}"
        )
      end

      if success(config[:gift_chance_percent]) && !config[:gift_codes].empty?
        codes = config[:gift_codes]
        code = codes.first
        config[:gift_codes] = codes.drop(1)

        File.open('../config/config.yml', 'w') do |f|
          f.write config.to_yaml
        end

        txt = nil
        if File.file?(WINNERS_FILE_PATH)
          File.open(WINNERS_FILE_PATH, 'r') do |f|
            txt = f.read
          end
        end

        File.open(WINNERS_FILE_PATH, 'w') do |f|
          f.puts(txt) unless txt.nil?

          f.puts "#{event.user.name}##{event.user.tag} from #{event.server.name}"
        end

        return ":tada: Congrats, anon <@#{event.user.id}>! You have won one of the 4discord Nitro giveaway codes! :tada:\n\n" \
        "Consider joining the bot's support server to help me continue on improving this project!\n" \
        "\n" \
        "Thank you for using 4discord! :champagne_glass:\n" \
        "\n" \
        "https://discord.com/invite/mYsn4K5ht9\n" \
        "#{code}"
      elsif !post['ext'].nil? && post['ext'].eql?('.webm')
        file_url.to_s
      end
    end

    def success(percent)
      rand <= percent / 100.0
    end
  end
end
