require 'ostruct'
require 'yaml'

class Config

	NoConfigFile = Class.new(StandardError)
	
	def initialize filename
		file = filename || File.join(__dir__, "config.yml")
		raise NoConfigFile unless File.exists? file
		@config = YAML.load_file(file)
	end

	def groups
		groups = []
		@config["groups"].each do |k, v|
			groups << OpenStruct.new(
				name: k, 
				rss: v["rss"], 
				requests: v["requests"], 
				path: v["path"])
		end
		groups
	end

end