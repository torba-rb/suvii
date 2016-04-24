require "bundler/setup"
require "suvii"

require "minitest/autorun"
require "webmock/minitest"
require "minitest/assert_dirs_equal"

require "tmpdir"
require "fileutils"

WebMock.allow_net_connect!

module AssertDirsEqual
  class Matcher
    def refute_extra_files_in_target
      return true unless @exact_match

      expected_files = both_paths_in(@expected, @target).map { |pair| pair[1] }
      actual_expected_files = Dir.glob(File.join(@target, "**/*"))
      diff = actual_expected_files - expected_files
      diff.empty? || fail_with("found unexpected files #{diff.inspect} when exepcted #{expected_files.inspect}")
    end
  end
end
