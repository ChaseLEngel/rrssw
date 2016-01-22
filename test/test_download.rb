require 'minitest/autorun'
require 'fileutils'
require 'yaml'

require_relative '../lib/download.rb'

class TestDownload < Minitest::Test
  def setup
    @url = 'https://raw.githubusercontent.com/ChaseLEngel/rrssw/master/test/test.file'
    @file = File.join(__dir__, 'test.file')
  end

  def test_file_download
    RRSSWDownload.download @url, __dir__
    assert File.exist?(@file), "File didn't get written to disk."
  end

  def test_contact_url
    expected = "This is a test file.\n"
    actual = RRSSWDownload.contact @url
    assert_equal expected, actual
  end

  def test_encode_replaces_brackets
    url = 'https://www.example.com/file[with]brackets'
    expected = 'https://www.example.com/file%255Bwith%255Dbrackets'
    assert_equal expected, RRSSWDownload.encode(url)
  end

  def teardown
    FileUtils.rm @file if File.exist? @file
  end
end
