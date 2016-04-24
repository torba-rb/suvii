module Suvii
  class Extract
    UnknownFormatError = Class.new(StandardError)

    TARGZ_RE = /\.t(ar\.)?gz\z/
    ZIP_RE = /\.zip\z/

    # Detects proper class for given archive path.
    #
    # @return [Targz, Zip]
    # @param source [String] local path to an archive.
    # @raise [UnknownFormatError] when archive format is not supported.
    def self.class_for(source)
      case source
      when TARGZ_RE then Targz
      when ZIP_RE then Zip
      else raise UnknownFormatError, "unknown format for #{source}"
      end
    end

    # @return [String]
    attr_reader :source

    # @return [Integer, nil]
    attr_reader :strip_components

    # @param source [String] local path to an archive.
    # @option options [Integer] :strip_components (nil, i.e. no skipping) specifies number of top-level
    #   directories to be skipped during the archive extraction. Same as `strip-components` option
    #   for GNU tar.
    def initialize(source, options = {})
      @source = source
      @strip_components = options[:strip_components]
    end

    # Performs archive extraction.
    #
    # @param destination [String] directory where the archive should be extracted.
    # @return [String] destination.
    def extract_to(destination)
      raise NotImplementedError
    end

    private

    def path_with_stripped_components(path)
      if strip_components
        segments = path.split(File::SEPARATOR)
        segments[strip_components..-1].join(File::SEPARATOR)
      else
        path
      end
    end
  end
end

require "suvii/extract/targz"
require "suvii/extract/zip"
