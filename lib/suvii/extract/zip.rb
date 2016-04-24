require "zip"

module Suvii
  class Extract
    class Zip < Extract
      # (see Extract#extract_to)
      def extract_to(destination)
        ::Zip::File.open(source) do |zip_file|
          zip_file.each do |entry|
            path = path_with_stripped_components(entry.name)
            destination_file = File.join(destination, path)
            entry.extract(destination_file)
          end
        end
        destination
      end
    end
  end
end
