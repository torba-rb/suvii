require "test_helper"

module Suvii
  class Extract
    class TargzTest < Minitest::Test
      def teardown
        FileUtils.rm_rf(destination)
      end

      def destination
        @destination ||= Dir.mktmpdir
      end

      def test_extract_to
        subject = Targz.new("test/fixtures/trumbowyg.tar.gz")
        result = subject.extract_to(destination)
        assert_equal destination, result
        assert_dirs_equal "test/fixtures/results", destination
      end

      def test_extract_to_with_strip_components
        subject = Targz.new("test/fixtures/trumbowyg.tar.gz", strip_components: 1)
        subject.extract_to(destination)
        assert_dirs_equal "test/fixtures/results/Trumbowyg-1.1.7", destination
      end
    end
  end
end
