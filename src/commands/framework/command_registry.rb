# A registry class for BotCommands
#

FRAMEWORK = File.dirname(__FILE__)

class CommandRegistry
  require_relative "#{FRAMEWORK}/../chan_command"
  require_relative "#{FRAMEWORK}/../chans_command"
  require_relative "#{FRAMEWORK}/../4help_command"
  require_relative "#{FRAMEWORK}/../4channel_command"

  def register_commands(bot, db)
    ChanCommand.new.register(bot, db)
    ChansCommand.new.register(bot, db)
    HelpCommand.new.register(bot, db)
    ChannelCommand.new.register(bot, db)
  end
end
