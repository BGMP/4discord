require 'net/http'

require_relative '4chan_api'

module ChanStatus
  LOG_TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S.%L'

  class << self
    def run_active_checker

      Thread::new do
        while true
          post = ChanAPI.get_post("b", 0, 0)  # Pull a random post to later test against media

          a4cdn_uri = URI("https://a.4cdn.org/boards.json")
          i4cdn_uri = URI(ChanAPI.get_media_url("b", post["tim"], post["ext"]))

          a4cdn_response = Net::HTTP.get_response(a4cdn_uri)
          i4cdn_response = Net::HTTP.get_response(i4cdn_uri)

          puts("[INFO : 4chan_api @ #{Time.now.strftime(LOG_TIMESTAMP_FORMAT)}] API endpoints returned status #{a4cdn_response.code} #{a4cdn_response.message}")
          puts("[INFO : 4chan_api @ #{Time.now.strftime(LOG_TIMESTAMP_FORMAT)}] API media returned status #{i4cdn_response.code} #{i4cdn_response.message}")

          sleep(600)                                           # Check the API status every 10 minutes.
        end
      end
    end
  end
end
