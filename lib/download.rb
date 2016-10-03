require 'open-uri'
require 'rest-client'

require_relative 'logger.rb'

# Handle downloading file from url.
class Download
  def self.download(url, dest)
    url = encode url
    response = contact url
    file = File.join(dest, File.basename(URI.parse(url).path))
    if File.exist? file
      Logger.instance.warn "#{file.inspect} already exists. Overwriting it."
    end
    File.open(file, 'w').write response
  end

  def self.contact(url)
    begin
      RestClient.get url
    rescue RestClient::Exception => e
      Logger.instance.error "Download failed for #{url}: #{e.response}"
    end
  end

  def self.encode(url)
    URI.encode(url.gsub('[', '%5B').gsub(']', '%5D'))
  end
end
