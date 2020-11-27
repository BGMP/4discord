# A registry class for BotCommands
#

class CommandRegistry
  require_relative '../chan_command'
  require_relative '../chans_command'
  require_relative '../4help_command'

  def register_commands(bot)
    ChanCommand.new.register(bot)
    ChansCommand.new.register(bot)
    HelpCommand.new.register(bot)
  end
end
