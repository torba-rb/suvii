require "tmpdir"
require "logger"

require "suvii/cache"
require "suvii/http"
require "suvii/extract"

# @since 0.1.0
module Suvii
  # Downloads and extracts an archive to a temp directory.
  #
  # @param url [String] URL of an archive to be fetched.
  # @option (see Cache.fetch)
  # @option (see Http.save)
  # @option (see Extract#initialize)
  # @return [String] path to a temp directory with the archive being extracted.
  def self.fetch(url, options = {})
    path_to_archive = Cache.fetch(url, options) do |path|
      Http.save(url, path, options)
    end

    extractor = Extract.class_for(path_to_archive).new(path_to_archive, options)
    extractor.extract_to(Dir.mktmpdir)
  end

  # @return [Logger] instance of Logger compatible class.
  def self.logger
    @logger ||= Logger.new(STDOUT).tap do |logger|
      logger.level = Logger::INFO
      logger.formatter = proc { |_, _, _, msg| msg }
    end
  end

  # Overrides default logger instance.
  #
  # @param logger [Logger] instance of Logger compatible class.
  def self.logger=(logger)
    @logger = logger
  end
end
