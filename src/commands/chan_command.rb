# Node bot command

class ChanCommand
  DEFAULT_BOARD = "b"
  EMBED_COLOR = "#9b1f1f"

  def register(bot)

    bot.command(:chan,
                :descritpion         => "Main command for getting random 4chan posts",
                :usage               => "/chan <board>",
                :min_args            => 0,
                :max_args            => 1,
                :permission_message  => "You do not have permission to use /chan",
                :chain_usable        => false,
                :rescue              => "An internal exception has occurred."
    ) do |event, board|

      board = board.nil? ? DEFAULT_BOARD : ChanBoards.name_to_board_slug(board.downcase)
      if board.nil? then return "Invalid board!" end

      page = rand(0.. 9)
      thread_number = page == 0 ? rand(0.. 9) + 1 : rand(0.. 9)

      post = ChanAPI.get_post(board, page, thread_number)
      file_url = API_MEDIA
                     .gsub("{0}", board.to_s)
                     .gsub("{1}", post["tim"].to_s)
                     .gsub("{2}", post["ext"].to_s)

      bot.channel(event.channel.id).send_embed do |embed|
        embed.title = "#{post["name"]} No. #{post["no"]}"
        embed.colour = EMBED_COLOR
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

      if post["ext"].eql? ".webm"
        "#{file_url}"
      end
    end
  end
end
