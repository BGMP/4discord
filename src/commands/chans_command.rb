# A command to display some of the most popular 4chan boards
#

class ChansCommand
  require_relative './../4chan_boards'

  EMBED_COLOUR = "#9b1f1f"
  BOARD_RANGES = {
      1 => 0.. 11,
      2 => 12.. 23,
      3 => 24.. 35,
      4 => 36.. 47,
      5 => 48.. 59,
      6 => 60.. 73
  }

  def register(bot, db)

    bot.command(:chans,
                :descritpion         => "Displays some of the most popular 4chan boards",
                :usage               => "/chans",
                :min_args            => 0,
                :max_args            => 1,
                :rescue              => "An internal exception has occurred."
    ) do |event, page|

      return if event.message.channel.type != 0

      row = db.execute("SELECT * FROM channels WHERE server_id = ?", [event.server.id])
      if row.empty?
        return "<@#{bot.profile.id}> is not hooked to any channel on this discord server!\n" \
        " » Use `/4channel <channel>` to hook it up!"
      else
        hooked_channel = row[0][1]
        return unless event.channel.id.eql?(hooked_channel)
      end

      unless event.channel.nsfw
        return "Channel `##{event.channel.name}` must be NSFW!\n" \
        " » https://support.discord.com/hc/en-us/articles/115000084051-NSFW-channels-and-content"
      end

      if page.nil?
        page = 1
      end

      page = page.to_i
      if page < 1 or page > 6
        return "Pages go from 1 to 6!"
      end

      bot.channel(event.channel.id).send_embed do |embed|
        embed.title = "4chan boards"
        embed.colour = EMBED_COLOUR

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
