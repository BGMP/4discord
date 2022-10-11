# frozen_string_literal: true

module Bot
  class CommandsManager

    def initialize(bot)
      @bot = bot
    end

    def register(clazz)
      clazz.new(@bot).register
    end
  end
end
