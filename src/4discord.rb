require 'discordrb'
require 'nokogiri'
require 'yaml'

require_relative '4chan_api'
require_relative '4chan_boards'
require_relative 'commands/framework/command_registry'

CONFIG = YAML.load_file("config/config.yml")

# Main Bot module
#
module Bot
  include ChanAPI
  include ChanBoards

  @bot = Discordrb::Commands::CommandBot.new :token => CONFIG[:token],
                                            :client_id => CONFIG[:client_id],
                                            :prefix => CONFIG[:prefix]

  CommandRegistry.new.register_commands(@bot)

  at_exit do
    @bot.stop
  end

  @bot.run
end
