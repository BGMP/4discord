require 'configuration'
require 'discordrb'
require 'yaml'

require_relative '4chan_api'
require_relative '4chan_boards'

# A module which represents default values to the bot's behaviour
#
module BotDefaults
  CONFIG = YAML.load_file("config/config.yml")
  DEFAULT_BOARD = "b"
  EMBED_COLOR = "#9b1f1f"
end

# Main Bot module
#
module Bot
  include BotDefaults
  include ChanAPI
  include ChanBoards

  bot = Discordrb::Commands::CommandBot.new :token => CONFIG[:token],
                                            :client_id => CONFIG[:client_id],
                                            :prefix => CONFIG[:prefix]

  bot.command :chan do |event|
    input = event.message.to_s.split(" ")
    if input.length > 2
      "Too many arguments!"
    end

    input_board = input[1]
    if !input_board.nil? and ChanBoards.name_to_board_slug(input_board).nil?
      "Invalid board!"
    end

    board = input_board.nil? ? DEFAULT_BOARD : ChanBoards.name_to_board_slug(input_board)
    page = rand(0.. 9)
    thread_number = rand(0.. 9)

    post = ChanAPI.get_post(board, page, thread_number)
    file_url = API_MEDIA.gsub("{0}", board.to_s)
                   .gsub("{1}", post["tim"].to_s)
                   .gsub("{2}", post["ext"].to_s)

    bot.channel(event.channel.id).send_embed do |embed|
      embed.title = "#{post["name"]} No. #{post["no"]}"
      embed.colour = EMBED_COLOR
      embed.description = post["com"]
      embed.add_field(:name => "Link",
                      :value => API_THREAD.gsub("{0}", board.to_s)
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

  at_exit do
    bot.stop
  end

  bot.run
end
