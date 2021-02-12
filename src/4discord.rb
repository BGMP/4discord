require 'discordrb'
require 'yaml'
require 'sqlite3'
require 'net/http'

require_relative '4chan_api'
require_relative '4chan_boards'
require_relative '4chan_status'
require_relative 'data/version'
require_relative 'commands/framework/command_registry'

CONFIG = YAML.load_file("../config/config.yml")

# Main Bot module
#
module Bot
  include ChanAPI
  include ChanBoards
  include ChanStatus
  include BotVersion

  @bot = Discordrb::Commands::CommandBot.new :token     => CONFIG[:token],
                                             :client_id => CONFIG[:client_id],
                                             :prefix    => CONFIG[:prefix]

  @db = SQLite3::Database.new "../config/bot.db"
  @db.execute <<-SQL
  create table if not exists channels (
    server_id int,
    channel_id int,
    channel_name varchar(100)
  );
  SQL

  CommandRegistry.new.register_commands(@bot, @db, CONFIG)
  ChanStatus.run_async_checker

  at_exit do
    @bot.stop
  end

  @bot.run
end
