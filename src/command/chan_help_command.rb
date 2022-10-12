# frozen_string_literal: true

module Bot
  class ChanHelpCommand
    include Command

    def register
      @bot.register_application_command(:'4help', 'Show general help for the bot')
      @bot.application_command(:'4help') do |event|
        event.respond(:ephemeral => false) do |e|
          e.add_embed do |embed|
            embed.title = '4discord Help Menu'
            embed.colour = Common::EMBED_COLOUR
            embed.add_field(:name => '/chan [board]',
                            :value => 'Pulls a random post from a 4chan board.',
                            :inline => true)
            embed.add_field(:name => '/chans [page]',
                            :value => 'Helps you discover all 4chan boards!',
                            :inline => true)
          end
        end
      end
    end
  end
end
