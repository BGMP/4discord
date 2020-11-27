# A command to display general help for the bot
#

class HelpCommand
  LABEL = "4help"
  EMBED_COLOUR = "#9b1f1f"

  def register(bot)

    bot.command(LABEL.to_sym,
                :descritpion         => "Displays general help for the bot",
                :usage               => "/4help",
                :min_args            => 0,
                :max_args            => 0,
                :chain_usable        => false,
                :rescue              => "An internal exception has occurred."
    ) do |event|
      bot.channel(event.channel.id).send_embed do |embed|
        embed.title = "4discord Help Menu"
        embed.colour = EMBED_COLOUR
        embed.add_field(:name => "/chan <board>",
                        :value => "Pulls a random post from a 4chan board",
                        :inline => true
        )
        embed.add_field(:name => "/chan <replies>",
                        :value => "Pulls 5 replies from the latest randomly pulled post",
                        :inline => true
        )
        embed.add_field(:name => "/chans <page>",
                        :value => "Helps you discover all 4chan boards!",
                        :inline => true
        )
      end
    end
  end
end
