#!/usr/bin/env ruby

require 'rss'

require_relative './lib/option.rb'
require_relative './lib/history.rb'
require_relative './lib/logger.rb'
require_relative './lib/config.rb'
require_relative './lib/download.rb'

def contact_feed
  @contacted ||= {}
  @contacted[@group.rss] ||= open(@group.rss) { |r| RSS::Parser.parse(r).items }
  search @contacted[@group.rss]
end

def search(items)
  matches = @group.requests.product(items)
                  .select { |r, i| i.title.match(r) }
                  .select { |r, i| !@history.include?(r, i.title) }
  matches.each do |_, i|
    RRSSWDownload.download i.link, @group.path
    RRSSWLogger.info "Downloaded file #{item.title}"
    @history.save item.title
  end
end

def main
  options = Option.parse(ARGV)
  @history = History.new options.database
  if options.history
    @history.all_formated
    exit
  end
  config = Config.new options.config
  config.groups.each do |group|
    @group = group
    contact_feed
  end
end

main
