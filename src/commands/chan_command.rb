# Node bot command

class ChanCommand
  DEFAULT_BOARD      = "b"
  POST_EMBED_COLOUR  = "#9b1f1f"
  REPLY_EMBED_COLOUR = "#dd2929"

  def register(bot)

    @latest_pulls = Hash.new         # Latest posts randomly pulled by /chan. { :channel_id => post } map
    @latest_board = Hash.new         # Latest board /chan pulled a post from. { :channel_id => post } map

    bot.command(:chan,
                :descritpion         => "Main command for fetching random 4chan posts and replies",
                :usage               => "/chan <board | replies>",
                :channels            => ["4chan"],
                :min_args            => 0,
                :max_args            => 1,
                :permission_message  => "You do not have permission to use /chan",
                :chain_usable        => false,
                :rescue              => "An internal exception has occurred."
    ) do |event, board|

      channel_id = event.channel.id.to_s
      latest = @latest_pulls[channel_id]

      if board.nil?
        board = DEFAULT_BOARD
      elsif board.eql?("replies")
        if latest.nil?
          return "You must pull a random post first! Use /chan"
        else

          replies = latest["last_replies"]

          if replies.nil? or replies.empty?
            bot.channel(channel_id).send_embed do |embed|
              embed.description = "This post has no replies."
            end
          else
            replies[0.. 5].each do |reply|
              file_url = API_MEDIA
                             .gsub("{0}", @latest_board[channel_id])
                             .gsub("{1}", reply["tim"].to_s)
                             .gsub("{2}", reply["ext"].to_s)

              bot.channel(channel_id).send_embed do |embed|
                embed.title = "#{reply["name"]} No. #{reply["no"]}"
                embed.colour = REPLY_EMBED_COLOUR
                embed.description = Nokogiri::HTML(reply["com"]).text
                embed.image = Discordrb::Webhooks::EmbedImage.new(
                    :url => file_url
                )
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

      @latest_pulls[channel_id] = post
      @latest_board[channel_id] = board

      file_url = API_MEDIA
                     .gsub("{0}", board.to_s)
                     .gsub("{1}", post["tim"].to_s)
                     .gsub("{2}", post["ext"].to_s)

      bot.channel(channel_id).send_embed do |embed|
        embed.title = "#{post["name"]} No. #{post["no"]}"
        embed.colour = POST_EMBED_COLOUR
        embed.description = Nokogiri::HTML(post["com"]).text
        embed.add_field(:name => "Link",
                        :value => API_THREAD
                                      .gsub("{0}", board.to_s)
                                      .gsub("{1}", post["no"].to_s)
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
