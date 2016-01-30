require 'minitest/autorun'
require 'fileutils'

require_relative '../lib/history.rb'

class HistoryTest < Minitest::Test
  def setup
    @filename = 'test.sqlite3'
    @history = RRSSW::History.new @filename
  end

  def test_file
    assert File.exist?(@filename), 'File not created.'
  end

  def test_save
    @history.save '1234'
  end

  def test_all
    @history.save '1234'
    assert_equal '1234', @history.all.flatten[0], 'Record not found in History.all'
  end

  def test_include
    @history.save '1234'
    assert @history.include?(/\d\d\d\d/, '1234'), 'Include? test failed.'
  end

  def test_formated
    @history.save '1234'
    expected_output = /Title: 1234\nTimestamp: \w{3} \d{2} \d{4} \d{2}:\d{2}:\d{2}\n-{50}/
    assert @history.all_formated.match(expected_output), 'Format doesn\'t match'
  end

  def teardown
    FileUtils.rm @filename
  end
end
