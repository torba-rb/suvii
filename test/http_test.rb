require "test_helper"

module Suvii
  class HttpTest < Minitest::Test
    def path
      @path ||= File.join(Dir.mktmpdir, "hello.world")
    end

    def logger
      @logger ||= Minitest::Mock.new
    end

    def setup
      Suvii.logger = logger
    end

    def teardown
      Suvii.logger = nil
      FileUtils.rm(path) if File.exist?(path)
    end

    def test_200
      stub_request(:get, "http://hello.com/world").to_return(body: "hello world")
      logger.expect(:info, nil, ["downloading 'http://hello.com/world'"])

      Http.save("http://hello.com/world", path)

      assert File.exist?(path)
      assert_equal "hello world", File.read(path)
      logger.verify
    end

    def test_no_retries_by_default
      logger.expect(:info, nil, ["downloading 'http://hello.com/world'"])
      stub_request(:get, "http://hello.com/world")
        .to_return(status: [502, "Bad gateway"])
        .to_return(body: "hello world")

      assert_raises(OpenURI::HTTPError) do
        Http.save("http://hello.com/world", path)
      end
    end

    def test_max_attempts_for_200_response
      logger.expect(:info, nil, ["downloading 'http://hello.com/world'"])
      logger.expect(:warn, nil, ["failed to download 'http://hello.com/world': 502 Bad gateway"])
      logger.expect(:info, nil, ["downloading 'http://hello.com/world'"])

      stub_request(:get, "http://hello.com/world")
        .to_return(status: [502, "Bad gateway"])
        .to_return(body: "hello world")

      Http.save("http://hello.com/world", path, max_attempts_for_200_response: 2)

      assert File.exist?(path)
      assert_equal "hello world", File.read(path)
      logger.verify
    end

  end
end
