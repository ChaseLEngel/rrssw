require 'open-uri'
require 'rest-client'

# Handle downloading file from url.
module RRSSWDownload
  module_function

  def download(url, dest)
    url = encode url
    response = contact url
    file = File.join(dest, File.basename(URI.parse(url).path))
    File.open(file, 'w').write response
  end

  def contact(url)
    RestClient.get url
  end

  def encode(url)
    URI.encode(url.gsub('[', '%5B').gsub(']', '%5D'))
  end
end
