require 'minitest/autorun'

require_relative '../lib/config.rb'


class TestConfig < Minitest::Test

	def setup
		filename = File.join(__dir__, "test_config.yml")
		@config = Config.new(filename).groups[0]
	end

	def test_config_name
		expected = "group1"
		assert_equal expected, @config.name, "Should be #{expected} but got #{@config.name}"
	end

	def test_no_config_file
		filename = "doesnotexist.yml"
		assert_raises(Config::NoConfigFile) do 
			config = Config.new(filename)
		end
	end

	def test_config_rss
		expected = "https://example.com/rss"
		assert_equal expected, @config.rss, "Should be #{expected} but got #{@config.rss}"
	end

	def test_config_requests_returns_array
		expected = Array
		assert @config.requests.is_a?(expected), "Should be #{expected} but got #{@config.requests.class}"
	end

	def test_config_resquests
		expected = ["group1 E\\d+"]
		assert_equal expected, @config.requests, "Should be #{expected} but got #{@config.requests}"
	end

	def test_config_path
		expected = "/path/to/group1"
		assert_equal expected, @config.path, "Should be [#{expected}] but got [#{@config.path}]"
	end

end