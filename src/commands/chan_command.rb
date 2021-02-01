# Node bot command

class ChanCommand
  require 'nokogiri'
  require 'time-hash'

  DEFAULT_BOARD      = "b"
  POST_EMBED_COLOUR  = "#9b1f1f"
  REPLY_EMBED_COLOUR = "#dd2929"
  EXPIRE_LATEST_PULL = 120               # 120 seconds
  EXPIRE_LATEST_BOARD = 120              # 120 seconds

  def register(bot, db)

    @latest_pulls = TimeHash.new         # Latest posts randomly pulled by /chan. { :channel_id => post } map
    @latest_board = TimeHash.new         # Latest boards /chan pulled a post from. { :channel_id => board } map

    bot.command(:chan,
                :descritpion         => "Main command for fetching random 4chan posts and replies",
                :usage               => "/chan <board | replies>",
                :min_args            => 0,
                :max_args            => 1,
                :rescue              => "An internal exception has occurred."
    ) do |event, board|

      return if event.message.channel.type != 0

      row = db.execute("SELECT * FROM channels WHERE server_id = ?", [event.server.id])
      if row.empty?
        return "<@#{bot.profile.id}> is not hooked to any channel on this discord server!\n" \
        " » Use `/4channel <channel>` to hook it up!"
      else
        hooked_channel = row[0][1]

        return unless event.channel.id.eql?(hooked_channel)
      end

      unless event.channel.nsfw
        return "Channel `##{event.channel.name}` must be NSFW!\n" \
        " » https://support.discord.com/hc/en-us/articles/115000084051-NSFW-channels-and-content"
      end

      channel_id = event.channel.id.to_s
      latest = @latest_pulls[channel_id]

      if board.nil?
        board = DEFAULT_BOARD
      elsif board.eql?("replies")
        if latest.nil?
          return "You must pull a post first! Use /chan"
        else

          replies = latest["last_replies"]

          if replies.nil? or replies.empty?
            bot.channel(channel_id).send_embed do |embed|
              embed.description = "This post has no replies."
            end
          else
            replies[0.. 5].each do |reply|
              file_url = ChanAPI.get_media_url(@latest_board[channel_id], reply["tim"], reply["ext"])

              bot.channel(channel_id).send_embed do |embed|
                embed.title = "#{reply["name"]} No. #{reply["no"]}"
                embed.colour = REPLY_EMBED_COLOUR
                embed.description = Nokogiri::HTML(reply["com"]).text
                embed.image = Discordrb::Webhooks::EmbedImage.new(
                    :url => file_url
                )
              end

              if !reply["ext"].nil? and reply["ext"].eql? ".webm"
                return "#{file_url}"
              end
            end
          end

          return
        end
      end

      board = ChanBoards.name_to_board_slug(board.downcase)
      if board.nil? then return "Invalid board!" end

      page = rand(0.. 9)
      thread_number = page == 0 ? rand(0.. 9) + 1 : rand(0.. 9)

      post = ChanAPI.get_post(board, page, thread_number)

      @latest_pulls.put(channel_id, post, EXPIRE_LATEST_PULL)
      @latest_board.put(channel_id, board, EXPIRE_LATEST_BOARD)

      file_url = ChanAPI.get_media_url(board.to_s, post["tim"], post["ext"])

      bot.channel(channel_id).send_embed do |embed|
        embed.title = "#{post["name"]} No. #{post["no"]}"
        embed.colour = POST_EMBED_COLOUR
        embed.description = Nokogiri::HTML(post["com"]).text
        embed.add_field(:name => "Link",
                        :value => ChanAPI.get_thread_url(board, post["no"])
        )
        embed.image = Discordrb::Webhooks::EmbedImage.new(
            :url => file_url
        )
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(
            :text => "API » Page #{page} » Thread #{thread_number}"
        )
      end

      if !post["ext"].nil? and post["ext"].eql? ".webm"
        "#{file_url}"
      end
    end
  end
end
