# A command to display general help for the bot
#

class ChannelCommand
  LABEL = "4channel"

  def register(bot, db)

    bot.command(LABEL.to_sym,
                :descritpion            => "Hooks 4discord to the specified channel",
                :usage                  => "/4channel <channel> to hook 4discord to a text channel!",
                :required_permissions   =>  [:administrator],
                :permission_message     => false,
                :min_args               => 1,
                :max_args               => 1,
                :rescue                 => "An internal exception has occurred."
    ) do |event, channel_name|

      current_server = event.server
      server_channel_match = current_server.channels.find { |c| c.name.eql?(channel_name) or "<##{c.id}>".eql?(channel_name) }
      if server_channel_match.nil?
        return "Channel `##{channel_name}` not found! You must create it first!"
      end

      row = db.execute("SELECT * FROM channels WHERE server_id = ?", [current_server.id])
      if row.empty?
        db.execute("INSERT INTO channels (server_id, channel_id, channel_name) VALUES (?, ?, ?)", [current_server.id, server_channel_match.id, server_channel_match.name])
      else
        db.execute("UPDATE channels SET channel_id = ?, channel_name = ? WHERE server_id = ?", [server_channel_match.id, server_channel_match.name, current_server.id])
      end

      return ":link: <@#{bot.profile.id}> will now respond to commands on `##{server_channel_match.name}`"
    end
  end
end
