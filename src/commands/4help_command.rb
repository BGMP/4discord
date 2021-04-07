# frozen_string_literal: true

# A command to display general help for the bot
#

class HelpCommand
  EMBED_COLOUR = '#9b1f1f'

  def register(bot, db)
    bot.command(:"4help",
                :description => 'Displays general help for the bot',
                :usage => '/4help',
                :min_args => 0,
                :max_args => 0,
                :rescue => 'An internal exception has occurred.') do |event|
      return if event.message.channel.type != 0

      row = db.execute('SELECT * FROM channels WHERE server_id = ?', [event.server.id])
      if row.empty?
        return "<@#{bot.profile.id}> is not hooked to any channel on this discord server!\n" \
        ' » Use `/4channel <channel>` to hook it up!'
      else
        hooked_channel_id = row[0][1]
        hooked_channel_name = row[0][2]

        return unless event.channel.id.eql?(hooked_channel_id)

        bot.channel(event.channel.id).send_embed do |embed|
          embed.title = '4discord Help Menu'
          embed.description = "Currently hooked to `##{hooked_channel_name}`"
          embed.colour = EMBED_COLOUR
          embed.add_field(:name => '/chan <board>',
                          :value => 'Pulls a random post from a 4chan board.',
                          :inline => true)
          embed.add_field(:name => '/chan replies',
                          :value => 'Pulls some replies to the latest randomly pulled post within a 15 minutes window.',
                          :inline => true)
          embed.add_field(:name => '/chans <page>',
                          :value => 'Helps you discover all 4chan boards!',
                          :inline => true)
          embed.add_field(:name => '/4channel <channel>',
                          :value => 'Hook 4discord to a text channel.',
                          :inline => true)
        end
      end
    end
  end
end
