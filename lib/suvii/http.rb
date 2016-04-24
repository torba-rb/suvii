require "open-uri"

module Suvii
  # Thin wrapper around {https://github.com/ruby/ruby/blob/trunk/lib/open-uri.rb OpenURI},
  # therefore proxy can be configured via standard env variables.
  class Http
    # Saves a content of the url to a file.
    #
    # @param url [String] URL to be fetched.
    # @param destination [String] path to a file to be created with the URL content.
    # @option options [Integer] :max_attempts_for_200_response (1, i.e. no retries) number of times
    #   to fetch a remote resource until get a 200 response.
    # @raise [OpenURI::HTTPError]
    # @return [true]
    def self.save(url, destination, options = {})
      attempts ||= 1
      uri = URI.parse(url)
      Suvii.logger.info("downloading '#{url}'")
      IO.copy_stream(uri.open, destination)
      true
    rescue OpenURI::HTTPError => e
      if attempts < (options[:max_attempts_for_200_response] || 1)
        Suvii.logger.warn("failed to download '#{url}': #{e.message}")
        attempts += 1
        retry
      else
        raise
      end
    end
  end
end
