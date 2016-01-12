#!/usr/bin/env ruby

require 'rss'
require 'open-uri'
require 'rest-client'

require_relative './lib/option.rb'
require_relative './lib/history.rb'
require_relative './lib/logger.rb'
require_relative './lib/config.rb'

def contactFeed
	search open(@group.rss){|rss| RSS::Parser.parse(rss) }
end

def search content
	@group.requests.each do |request|
		content.items.each do |item|
			if item.title.match(request) && !@history.include?(request, item.title)
				download item
			end
		end
	end
end

def download item
	url = URI.encode(item.link.gsub("[", "%5B").gsub("]", "%5D"))
	response = RestClient.get url
	file = File.join(@group.path, item.title).gsub(" ", ".") + ".torrent"
	torrent_file = File.new(file, "w")
	torrent_file.write response
	@logger.info "Downloaded file #{item.title}"
	@history.save item.title
end

def main
	options = Option.parse(ARGV)
	@logger = Logger.new options.log
	@history = History.new options.database
	@logger.info "History loaded:#{@history.file}"
	config = Config.new options.config 
	@logger.info "Config loaded:#{config.file}"
	if options.history
		puts @history.all_formated
		exit
	end
	config.groups.each do |group|
		@group = group
		contactFeed
	end
end

main
