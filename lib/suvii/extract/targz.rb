require "fileutils"
require "zlib"
require "rubygems/package"

module Suvii
  class Extract
    class Targz < Extract
      CHUNK_SIZE = 65_536
      DIR_UP = ".."
      PAX_GLOBAL_HEADER = "pax_global_header"

      # can't use IO.copy_stream because TarReader::Entry#read has different arity when IO#read
      def self.copy_stream(tar_io, destination)
        File.open(destination, "wb") do |destination_file|
          until tar_io.eof?
            destination_file.write(tar_io.read(CHUNK_SIZE))
          end
        end
      end

      # (see Extract#extract_to)
      def extract_to(destination)
        Zlib::GzipReader.open(source) do |gz|
          Gem::Package::TarReader.new(gz) do |tar|
            tar.each do |tarfile|
              next if tarfile.full_name == PAX_GLOBAL_HEADER

              if tarfile.full_name.include?(DIR_UP)
                raise SecurityError, "can't write outside of destination directory, entry filename is #{tarfile.full_name.inspect}"
              end

              path = path_with_stripped_components(tarfile.full_name)
              destination_file = File.join(destination, path)

              if tarfile.directory?
                FileUtils.mkdir_p(destination_file)
              else
                destination_directory = File.dirname(destination_file)
                FileUtils.mkdir_p(destination_directory)
                Targz.copy_stream(tarfile, destination_file)
              end
            end
          end
        end
        destination
      end
    end
  end
end
