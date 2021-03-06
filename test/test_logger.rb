require 'minitest/autorun'
require 'fileutils'

require_relative '../lib/logger.rb'

class TestSlogger < Minitest::Test
  def setup
    @test_log = File.join(__dir__, 'test.log')
    @message = 'message'
  end

  def test_setting_debug
    assert((Slogger.debug = true))
  end

  def log_regex(type, exp)
    /\A\[\w{3} \d{1,2} \d{4} \d{2}(:\d{2}){2}\]\[#{type.upcase}\] #{@message}\n\z/ =~ exp
  end

  def read_log
    @r ||= File.open(@test_log, 'r').read
  end

  def test_error
    Slogger.error @message, @test_log
    assert log_regex('error', read_log), "#{read_log.inspect} does not match."
  end

  def test_debug
    Slogger.debug = true
    Slogger.debug @message, @test_log
    assert log_regex('debug', read_log), "#{read_log.inspect} does not match."
  end

  def test_info
    Slogger.info @message, @test_log
    assert log_regex('info', read_log), "#{read_log.inspect} does not match."
  end

  def test_with_incorrect_log_type
    assert_raises(NoMethodError) do
      Slogger.notatype 'Not a type!.', @test_log
    end
  end

  def teardown
    FileUtils.rm @test_log if File.exist? @test_log
  end
end
