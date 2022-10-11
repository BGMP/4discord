# frozen_string_literal: true

# A class to continuously check on 4chan's API status, and log changes to its responses
#

module Bot
  class ChanStatus

    def initialize
      @a_status = 'Not checked'
      @i_status = 'Not checked'
    end

    def run_async_checker
      Thread.new do
        Thread.current[:discordrb_name] = '4chan_api'
        loop do

          # Pull a random post to later test against media
          post = ChanAPI.get_post('b', 0, 0)

          a4cdn_uri = URI('https://a.4cdn.org/boards.json')
          i4cdn_uri = URI(ChanAPI.get_media_url('b', post['tim'], post['ext']))

          a4cdn_response = Net::HTTP.get_response(a4cdn_uri)
          i4cdn_response = Net::HTTP.get_response(i4cdn_uri)

          a_status = "#{a4cdn_response.code} #{a4cdn_response.message}"
          i_status = "#{i4cdn_response.code} #{i4cdn_response.message}"

          # If status changed, log it to console

          if @a_status != a_status
            Discordrb::LOGGER.info("API endpoints returned status #{a_status}. Previously: #{@a_status}.")
            @a_status = a_status
          end

          if @i_status != i_status
            Discordrb::LOGGER.info("API media returned status #{i_status}. Previously: #{@i_status}.")
            @i_status = i_status
          end

          # Check the API status every 10 minutes
          sleep(600)
        end
      end
    end
  end
end
