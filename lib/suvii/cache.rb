require "cgi"
require "tmpdir"

module Suvii
  class Cache
    # Maps an archive URL to a path to its cached file.
    # @note This method doesn't write to a disk. It is a responsibility of a block implementation.
    #
    # @param url [String] URL of an archive to be processed.
    # @option options [String] :cache_path (random temporary directory) where the downloaded archive
    #   should be stored. You can provide path to a persistent folder to prevent downloading same
    #   files again.
    # @yield a block if the archive was not previously cached.
    # @yieldparam path [String] full path to the archive to be stored.
    # @return [String] full path to the stored archive.
    def self.fetch(url, options = {})
      cache_path = options[:cache_path] || Dir.mktmpdir
      escaped_url = CGI.escape(url)
      archive_path = File.join(cache_path, escaped_url)
      yield archive_path unless File.exist?(archive_path)
      archive_path
    end
  end
end
