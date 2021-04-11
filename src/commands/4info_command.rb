# frozen_string_literal: true

# Command for general bot information and metrics

class BotInfoCommand
  EMBED_COLOUR = '#9b1f1f'

  def register(bot)
    bot.command(:"4info",
                :description => 'Display general information and metrics for the bot.',
                :usage => '/4info',
                :min_args => 0,
                :max_args => 0,
                :rescue => 'An internal exception has occurred.') do |event|
      servers_added_to = bot.servers.size

      bot.channel(event.channel.id).send_embed do |embed|
        embed.title = 'Information Report'
        embed.colour = EMBED_COLOUR
        embed.add_field(:name => 'Used in',
                        :value => "#{servers_added_to} #{servers_added_to == 1 ? 'server' : 'servers'}",
                        :inline => true)
        embed.add_field(:name => 'Version',
                        :value => BotVersion::VERSION,
                        :inline => true)
        embed.add_field(:name => 'Environment',
                        :value => BotVersion::ENV,
                        :inline => true)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(
          :text => 'Created by @BGM#3867'
        )
      end
    end
  end
end
