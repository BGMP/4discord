# A registry class for BotCommands
#

class CommandRegistry
  require_relative '../chan_command'

  def register_commands(bot)
    ChanCommand.new.register(bot)
  end
end
