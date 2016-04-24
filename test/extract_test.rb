require "test_helper"

module Suvii
  class ExtractTest < Minitest::Test
    def test_class_for_targz
      klass = Extract.class_for("/tmp/hello.tar.gz")
      assert_equal Extract::Targz, klass
    end

    def test_class_for_tgz
      klass = Extract.class_for("/tmp/hello.tgz")
      assert_equal Extract::Targz, klass
    end

    def test_class_for_zip
      klass = Extract.class_for("/tmp/hello.zip")
      assert_equal Extract::Zip, klass
    end

    def test_class_for_unknown
      assert_raises(Extract::UnknownFormatError) do
        Extract.class_for("/tmp/hello.rar")
      end
    end
  end
end
