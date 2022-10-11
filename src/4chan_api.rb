# frozen_string_literal: true

# A module to easily interact with 4chan's API
#
module Bot
  module ChanAPI
    require 'json'
    require 'net/https'
    require 'open-uri'

    API = 'https://a.4cdn.org/{0}/catalog.json'
    API_MEDIA = 'https://i.4cdn.org/{0}/{1}{2}'
    API_THREAD = 'https://boards.4chan.org/{0}/thread/{1}'

    class Error < RuntimeError; end
    class << self
      attr_accessor :logger, :timeout

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
        api_get(API.gsub('{0}', board.to_s)) do |io|
          JSON.parse(io.read)
        end
      end

      # Gets all 10 threads within the specified page
      def get_page_posts(board, page)
        api_get(API.gsub('{0}', board.to_s)) do |io|
          JSON.parse(io.read)[page]['threads']
        end
      end

      # Gets the specified thread (0-9) from the specified page
      def get_post(board, page, thread_number)
        api_get(API.gsub('{0}', board.to_s)) do |io|
          JSON.parse(io.read)[page]['threads'][thread_number]
        end
      end

      # Gets the link to media content served by 4chan's cdn
      #
      # @param board The board where this piece of media is to be found
      # @param tim The tim (identifier) of the post/reply
      # @param ext The extension of the piece of media
      #
      # @return The link to the media piece
      def get_media_url(board, tim, ext)
        API_MEDIA
          .gsub('{0}', board.to_s)
          .gsub('{1}', tim.to_s)
          .gsub('{2}', ext.to_s)
      end

      # Gets the link to a 4chan thread
      #
      # @param board The board where the requested thread was posted at
      # @param no The thread's number
      #
      # @return The link to the thread
      def get_thread_url(board, no)
        API_THREAD
          .gsub('{0}', board.to_s)
          .gsub('{1}', no.to_s)
      end
    end
  end
end
