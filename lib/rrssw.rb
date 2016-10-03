require 'rss'

require_relative 'download.rb'
require_relative 'logger.rb'
require_relative 'feed.rb'

class Rrssw

  def initialize(groups, history, options)
    @groups = groups
    @options = options
    @history = history
  end

  def start
    @groups.each do |group|
      feed = contact_feed(group.rss)
      items = Feed.parse feed
      # Print sorted feed titles
      puts feed.map(&:title).sort if @options.dump
      search(group, items)
    end
  end

  private

  # Takes a URL to a RSS feed and returns a RSS object.
  def contact_feed(url)
    @contacted ||= {}
    begin
      # Check if url has already been seen. If not contact it.
      @contacted[url] ||= open(url) { |r| RSS::Parser.parse(r).items }
    rescue OpenURI::HTTPError => e
      Slogger.instance.error "#{e} occured while contacting #{url.inspect}"
      return []
    end
    @contacted[url].dup
  end

  def sizeMatch?(group, item)
    # Make sure sizes have been set.
    if group.size.size.nil? && item.size.size.nil?
      item.size.bytes <= group.size.bytes
    else
      true
    end
  end

  # Check requirments for group and request with RSS item
  def match?(group, request, item)
    item.title.match(request) &&
    sizeMatch?(group, item) &&
    !@history.include?(request, item.title)
  end

  # Matches titles to requests
  # group - OpenStruct of config elements.
  # item - RSS feed item object
  def search(group, items)
    # Creates an Array of [String, RSS item] for all combinations.
    group.requests.product(items).each do |request, item|
      if match?(group, request, item)
        download(group.path, item)
        Notification.send(item.title)
      end
    end
  end

  # Download file from RSS link to given path.
  # path - String of directory where file will be downloaded.
  # item - RSS item to be downloaded.
  def download(path, item)
    Download.download item.link, path
    Slogger.instance.info "Downloaded file #{item.title}"
    @history.save item.title
  end

  # Matches titles to requests
  # group - OpenStruct of config elements.
  # item - RSS feed item object
  def search(group, items)
    # Creates an Array of [String, RSS item] for all combinations.
    group.requests.product(items).each do |request, item|
      if match?(group, request, item)
        download(group.path, item)
        Notification.send(item.title)
      end
    end
  end

  # Download file from RSS link to given path.
  # path - String of directory where file will be downloaded.
  # item - RSS item to be downloaded.
  def download(path, item)
    Download.download item.link, path
    Slogger.instance.info "Downloaded file #{item.title}"
    @history.save item
  end

end
