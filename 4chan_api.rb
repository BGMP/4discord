
API = "https://a.4cdn.org/{0}/catalog.json".freeze
API_MEDIA = "https://i.4cdn.org/{0}/{1}{2}".freeze
API_THREAD = "https://boards.4chan.org/{0}/thread/{1}".freeze

module ChanAPI
  require 'json'
  require 'net/https'
  require 'open-uri'

  class Error < RuntimeError; end

  class << self
    attr_accessor :logger
    attr_accessor :timeout

    def log(msg)
      logger&.debug(msg)
    end

    # Just gets a URL and wraps errors in ChanAPI::Error
    def api_get(url, &block)
      Timeout.timeout(timeout || 0) do
        open(url, &block)
      end
    rescue OpenURI::HTTPError => e
      log "Failed to get url #{url}: #{e}"
      raise Error
    rescue Timeout::Error
      log "Timed out (#{timeout}) getting url #{url}"
      raise Error
    end

    # Gets all the pages for the specified board
    def get_pages(board)
      api_get(API.gsub("{0}", board)) do |io|
        JSON.parse(io.read)
      end
    end

    # Gets all 10 threads within the specified page
    def get_page_posts(board, page)
      api_get(API.gsub("{0}", board.to_s)) do |io|
        JSON.parse(io.read)[page]["threads"]
      end
    end

    # Gets the specified thread (0-9), from the specified page
    def get_post(board, page, thread_number)
      api_get(API.gsub("{0}", board.to_s)) do |io|
        JSON.parse(io.read)[page]["threads"][thread_number]
      end
    end
  end
end
