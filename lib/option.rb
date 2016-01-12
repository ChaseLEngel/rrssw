require 'optparse'
require 'ostruct'

class Option

	def self.parse argv
		options = OpenStruct.new
		opts_parser = OptionParser.new do |opts|
			opts.banner = "Ruby RSS Watch - Poll RSS feeds for torrent files."
			opts.on(nil, "--history", "Show history of what has been downloaded.") do |h|
				options[:history] = h
			end
			opts.on("-c", "--config=", "Specify config file. Default is config.yml") do |c|
				options[:config] = c
			end
			opts.on("-d", "--database=", "Specify database file. Default is rrssw.sqlite3") do |d|
				options[:database] = d
			end
			opts.on("-l", "--log=", "Specify log file. Default is rrssw.log") do |l|
				options[:log] = l
			end
			opts.on("-h", "--help", "Show this message.") do |help|
				puts opts
				exit
			end
		end
		opts_parser.parse!(argv)
		options
	end
	
end
