# frozen_string_literal: true

module Bot
  class ChansCommand
    include Command

    def register
      @bot.register_application_command(:chans, 'List all 4chan messageboards') do |cmd|
        cmd.string('page', 'Page number', :required => false)
      end

      @bot.application_command(:chans) do |event|
        page = event.options['page']
        page = if page.nil?
                 1
               else
                 page.to_i
               end

        # If page doesn't exist
        if (page < 1) || (page > 6)
          event.respond(:content => <<~STR, :ephemeral => true)
            Pages go from 1 to 6!
          STR

          next
        end

        # Render an embed with the boards
        event.respond(:ephemeral => false) do |e|
          e.add_embed do |embed|
            embed.title = '4chan boards'
            embed.colour = Common::EMBED_COLOUR

            Common::BOARDS.values[Common::BOARD_RANGES[page]].each do |v|
              embed.add_field(:name => v.to_s,
                              :value => "/chan #{Common::BOARDS.key(v)}",
                              :inline => true)
            end
            embed.footer = Discordrb::Webhooks::EmbedFooter.new(
              :text => "Page (#{page}/6)"
            )
          end
        end
      end
    end
  end
end
