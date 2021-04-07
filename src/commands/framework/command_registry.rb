# frozen_string_literal: true

# A registry class for BotCommands
#

class CommandRegistry
  require_relative '../chan_command'
  require_relative '../chans_command'
  require_relative '../4help_command'
  require_relative '../4channel_command'
  require_relative '../4info_command'

  def register_commands(bot, db, config)
    ChanCommand.new.register(bot, db, config)
    ChansCommand.new.register(bot, db)
    HelpCommand.new.register(bot, db)
    ChannelCommand.new.register(bot, db)
    BotInfoCommand.new.register(bot)
  end
end
