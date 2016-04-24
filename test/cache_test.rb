require "test_helper"

module Suvii
  class CacheTest < Minitest::Test
    def test_with_cache_path
      path = Cache.fetch("http://hello.com/file.gz", cache_path: "/tmp/dir") {  }
      assert_equal "/tmp/dir/http%3A%2F%2Fhello.com%2Ffile.gz", path
    end

    def test_without_cache_path
      path = Cache.fetch("http://hello.com/file.gz") {  }
      assert path.start_with?(Dir.tmpdir, path)
      assert path.end_with?("/http%3A%2F%2Fhello.com%2Ffile.gz", path)
    end

    def test_no_block_is_called_when_file_exists
      cache_path = Dir.mktmpdir
      archive_path = File.join(cache_path, "hello.world")
      FileUtils.touch(archive_path)

      block_executed = false
      Cache.fetch("hello.world", cache_path: cache_path) do
        block_executed = true
      end
      refute block_executed
    ensure
      FileUtils.rm_rf(archive_path)
    end

    def test_block_is_called_when_file_doesnt_exist
      cache_path = "/tmp"
      archive_path = File.join(cache_path, "hello.world")

      block_executed = false
      Cache.fetch("hello.world", cache_path: cache_path) do |path|
        assert_equal archive_path, path
        block_executed = true
      end
      assert block_executed, "block should be executed"
    end
  end
end
