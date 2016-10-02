require_relative 'size'

module Feed
  def self.parse(feed)
    items = []
    feed.each do |item|
      items << Item.new(
        item.title,
        item.link,
        self.parseSize(item.description),
        self.parseFormat(item.description),
        item.pubDate)
    end
    items
  end

  def self.parseSize(str)
    regx = Regexp.new(/\d+(\.\d+)*( )*(KB|MB|GB|TB|kb|mb|gb|tb)/)
    str.match(regx).to_s
  end

  def self.parseFormat(str)
    regx = Regexp.new(//)
    str.match(regx).to_s
  end
end

class Item
  attr_reader :title, :link, :size, :format, :pub_date
  def initialize(title, link, size, format, pub_date)
    @title = title
    @link = link
    @size = Size.new(size)
    @format = format
    @pub_date = pub_date
  end
end
