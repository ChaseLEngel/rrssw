#!/usr/bin/env ruby

require 'rss'

require_relative './lib/option.rb'
require_relative './lib/history.rb'
require_relative './lib/logger.rb'
require_relative './lib/config.rb'
require_relative './lib/download.rb'

def contact_feed(url)
  @contacted ||= {}
  begin
    @contacted[url] ||= open(url) { |r| RSS::Parser.parse(r).items }
  rescue OpenURI::HTTPError => e
    RRSSW::Logger.error "#{e} occured while contacting #{url.inspect}"
    return []
  end
  @contacted[url].dup
end

# Takes two arrays and returns matching titles.
def search(requests, titles)
  matches = {} # Hold request and its matching title.
  requests.product(titles).each do |r, t|
    next if matches.key? r # Make sure not to add duplicates.
    matches[r] = t if t.match(r) && !@history.include?(r, t)
  end
  matches.values
end

def download(path, matches)
  matches.each do |i|
    RRSSW::Download.download i.link, path
    RRSSW::Logger.info "Downloaded file #{i.title}"
    @history.save i.title
  end
end

options = Option.parse(ARGV)
@history = RRSSW::History.new options.database
if options.history
  @history.all_formated
  exit
end
config = RRSSW::Config.new options.config
config.groups.each do |g|
  items = contact_feed(g.rss)
  matches = search(g.requests, items.map(&:title))
  items.keep_if { |i| matches.include? i.title } # Get matches from items
  download(g.path, items)
end
