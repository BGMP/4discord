# frozen_string_literal: true

module Bot
  class ChanCommand
    include Command

    def register
      @bot.register_application_command(:chan, 'Pull a random post from a messageboard') do |cmd|
        cmd.string('board', 'Choose a 4chan board', :required => false)
      end

      @bot.application_command(:chan) do |event|

        # If the channel is not marked as NSFW, display a warning instead
        unless event.channel.nsfw
          event.respond(:content => <<~STR, :ephemeral => true)
            :warning: Channel `##{event.channel.name}` must be NSFW!

            More info: https://support.discord.com/hc/en-us/articles/115000084051-NSFW-channels-and-content
          STR

          next
        end

        board = event.options['board']

        # We choose a random page, and a random thread
        page = rand(0..9)
        thread_number = page.zero? ? rand(1..10) : rand(0..9)

        # If the user did not provide a board, render from the default board
        render_post(event, Common::DEFAULT_BOARD, page, thread_number) if board.nil?

        # If the user did provide a board but it was invalid, display board not found
        board = name_to_board_slug(board)
        if board.nil?
          event.respond(:content => <<~STR, :ephemeral => true)
            Board not found!

            Use /chans [page] to browse all boards.
          STR

          next
        end

        # Board was found! We render the post...
        render_post(event, board, page, thread_number)
      end
    end

    # Renders a 4chan post to a Discord text channel. This includes content such as:
    #   - Anon No.
    #   - Post Link.
    #   - Linked media (img/vid).
    #   - API info.
    #
    # @param event Discord event
    # @param board Board slug
    # @param page Page number
    # @param thread_number Thread number
    def render_post(event, board, page, thread_number)
      post = ChanAPI.get_post(board, page, thread_number)
      file_url = ChanAPI.get_media_url(board, post['tim'], post['ext'])

      comment = post['com'].nil? ? '' : post['com'].gsub('<br>', "\n")

      event.respond(:ephemeral => false) do |e|
        e.add_embed do |embed|
          embed.title = "#{post['name']} No. #{post['no']}"
          embed.colour = Common::POST_EMBED_COLOUR
          embed.description = Nokogiri::HTML(comment).text
          embed.add_field(:name => 'Link',
                          :value => ChanAPI.get_thread_url(board, post['no']))
          embed.image = Discordrb::Webhooks::EmbedImage.new(
            :url => file_url
          )
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(
            :text => "API » Page #{page} » Thread #{thread_number}"
          )
        end
      end

      # If the post has a video attached just send its link, Discord will take care of displaying it.
      if !post['ext'].nil? && post['ext'].eql?('.webm')
        event.send_message(:content => file_url.to_s)
      end
    end

    # Converts the provided board name into its board slug equivalent (i.e: Random => b).
    # If the passed name happens to already be the slug, for example "b", the method will return it as is.
    #
    # @param name The name of the board
    # @return The slug corresponding to the passed board name, or nil if not found
    def name_to_board_slug(name)
      key = name.downcase
      if Common::BOARDS.key?(key.to_sym) || Common::BOARDS.key?(key.to_s)
        name
      else
        slug = Common::BOARDS.key(key)
        slug.nil? ? nil : slug.to_s
      end
    end
  end
end
