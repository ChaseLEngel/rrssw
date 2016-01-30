require 'open-uri'
require 'rest-client'

module RRSSW
  # Handle downloading file from url.
  class Download
    def self.download(url, dest)
      url = encode url
      response = contact url
      file = File.join(dest, File.basename(URI.parse(url).path))
      File.open(file, 'w').write response
    end

    def self.contact(url)
      RestClient.get url
    end

    def self.encode(url)
      URI.encode(url.gsub('[', '%5B').gsub(']', '%5D'))
    end
  end
end
