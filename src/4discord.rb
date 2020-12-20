require 'discordrb'
require 'nokogiri'
require 'yaml'
require 'sqlite3'

SRC = File.dirname(__FILE__)

require_relative "#{SRC}/4chan_api"
require_relative "#{SRC}/4chan_boards"
require_relative "#{SRC}/commands/framework/command_registry"

CONFIG = YAML.load_file("#{SRC}/../config/config.yml")

# Main Bot module
#
module Bot
  include ChanAPI
  include ChanBoards

  @bot = Discordrb::Commands::CommandBot.new :token     => CONFIG[:token],
                                             :client_id => CONFIG[:client_id],
                                             :prefix    => CONFIG[:prefix]

  @db = SQLite3::Database.new "#{SRC}/../config/bot.db"
  @db.execute <<-SQL
  create table if not exists channels (
    server_id int,
    channel_id int,
    channel_name varchar(100)
  );
  SQL

  CommandRegistry.new.register_commands(@bot, @db)

  at_exit do
    @bot.stop
  end

  @bot.run
end
