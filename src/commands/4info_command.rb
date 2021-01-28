# Command for general bot information and metrics

class BotInfoCommand
  EMBED_COLOUR = "#9b1f1f"

  # Members of the 4discord staff team allowed to perform info requests.
  STAFF = [
      265233026072444929, # BGM
      238736626262605824, # KingOfSquares
      626141898146578433, # Teszeo
      308254655148720131  # AbdulAkbar
  ]

  def register(bot, db)

    bot.command(:"4info",
                :descritpion         => "Display general information and metrics for the bot.",
                :usage               => "/4info",
                :min_args            => 0,
                :max_args            => 0,
                :rescue              => "An internal exception has occurred."
    ) do |event|

      sender_id = event.user.id
      unless STAFF.include?(sender_id)
        return "You do not have permission."
      end

      rows = db.execute("SELECT * FROM channels")
      registered_servers_count = rows.size

      bot.channel(event.channel.id).send_embed do |embed|
        embed.title = "Information Report"
        embed.colour = EMBED_COLOUR
        embed.add_field(:name => "Used in",
                        :value => "#{registered_servers_count} #{registered_servers_count == 1 ? "server" : "servers"}",
                        :inline => true
        )
        embed.add_field(:name => "Version",
                        :value => BotVersion::VERSION,
                        :inline => true
        )
        embed.add_field(:name => "Environment",
                        :value => BotVersion::ENV,
                        :inline => true
        )
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(
            :text => "Created by @BGM#3867"
        )
      end
    end
  end
end
