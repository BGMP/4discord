# A command to display some of the most popular 4chan boards
#

class ChansCommand
  require_relative '../4chan_boards'

  EMBED_COLOR = "#9b1f1f"
  BOARD_RANGES = {
      1 => 0.. 11,
      2 => 12.. 23,
      3 => 24.. 35,
      4 => 36.. 47,
      5 => 48.. 59,
      6 => 60.. 73
  }

  def register(bot)

    bot.command(:chans,
                :descritpion         => "Displays some of the most popular 4chan boards",
                :usage               => "/chans",
                :min_args            => 0,
                :max_args            => 1,
                :permission_message  => "You do not have permission to use /chan",
                :chain_usable        => false,
                :rescue              => "An internal exception has occurred."
    ) do |event, page|

      if page.nil?
        page = 1
      end

      page = page.to_i

      if page < 0 or page > 6
        return "Pages go from 1 to 6!"
      end

      bot.channel(event.channel.id).send_embed do |embed|
        embed.title = "4chan boards"
        embed.colour = EMBED_COLOR

        BOARDS.values[BOARD_RANGES[page]].each do |value|
          embed.add_field(:name => value.to_s,
                          :value => "/chan #{BOARDS.key(value)}",
                          :inline => true
          )
        end

        embed.footer = Discordrb::Webhooks::EmbedFooter.new(
            :text => "Page (#{page}/6)"
        )
      end
    end
  end
end
