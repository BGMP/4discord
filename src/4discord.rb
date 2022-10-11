# frozen_string_literal: true

require 'discordrb'
require 'net/http'
require 'nokogiri'
require 'sqlite3'
require 'yaml'

require_relative '4chan_api'
require_relative '4chan_status'
require_relative 'common'
require_relative 'command/framework/command'
require_relative 'command/framework//commands_manager'
require_relative 'command/chan_help_command'
require_relative 'command/chan_command'
require_relative 'command/chans_command'

# Main Bot module
#
module Bot

  #
  # Initialize Bot
  #

  @bot = Discordrb::Bot.new(:token => Common::CONFIG[:token], :intents => [:server_messages])

  #
  # Command Registration
  #

  cmd_manager = CommandsManager.new(@bot)
  cmd_manager.register(ChanCommand)
  cmd_manager.register(ChansCommand)
  cmd_manager.register(ChanHelpCommand)

  #
  # Initialize API status checker
  #

  status_checker = ChanStatus.new
  status_checker.run_async_checker

  at_exit do
    @bot.stop
  end

  @bot.run
end
