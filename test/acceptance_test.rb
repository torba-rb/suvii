require "test_helper"

module Suvii
  class AcceptanceTest < Minitest::Test
    attr_reader :destination

    def teardown
      FileUtils.rm_rf(destination)
    end

    def test_zip
      @destination = Suvii.fetch(
        "https://github.com/torba-rb/Trumbowyg/archive/1.1.7.zip",
        strip_components: 1,
        max_attempts_for_200_response: 2
      )
      assert_dirs_equal "test/fixtures/results/Trumbowyg-1.1.7", destination
    end

    def test_targz
      @destination = Suvii.fetch(
        "https://github.com/torba-rb/Trumbowyg/archive/1.1.7.tar.gz",
        strip_components: 1,
        max_attempts_for_200_response: 2
      )
      assert_dirs_equal "test/fixtures/results/Trumbowyg-1.1.7", destination
    end
  end
end
