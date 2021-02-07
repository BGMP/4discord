# A class to continuously check on 4chan's API status, and log changes to its responses
#

require 'discordrb'
require 'net/http'

require_relative '4chan_api'

module ChanStatus

  class << self
    def run_async_checker

      Thread::new do

        @a_status = "Not checked"
        @i_status = "Not checked"

        while true
          post = ChanAPI.get_post("b", 0, 0)  # Pull a random post to later test against media

          a4cdn_uri = URI("https://a.4cdn.org/boards.json")
          i4cdn_uri = URI(ChanAPI.get_media_url("b", post["tim"], post["ext"]))

          a4cdn_response = Net::HTTP.get_response(a4cdn_uri)
          i4cdn_response = Net::HTTP.get_response(i4cdn_uri)

          a_status = "#{a4cdn_response.code} #{a4cdn_response.message}"
          i_status = "#{i4cdn_response.code} #{i4cdn_response.message}"

          if @a_status != a_status
            Discordrb::LOGGER.info("API endpoints returned status #{a_status}. Previously: #{@a_status}.")
            @a_status = a_status
          end

          if @i_status != i_status
            Discordrb::LOGGER.info("API media returned status #{i_status}. Previously: #{@i_status}.")
            @i_status = i_status
          end

          sleep(600)  # Check the API status every 10 minutes.
        end
      end
    end
  end
end
