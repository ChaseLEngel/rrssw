module RRSSW
  # Log messages to a file.
  class Logger
    LOG_FILE = File.join(__dir__, '../rrssw.log')
    LOG_TYPES = %i(debug info error).freeze

    def self.method_missing(type, message, log_file = LOG_FILE)
      fail NoMethodError, type unless LOG_TYPES.include? type
      time = Time.now.strftime('%b %d %Y %H:%M:%S')
      File.open(log_file, 'a') do |f|
        f.puts "[#{time}][#{type.upcase}] #{message}"
      end
    end
  end
end
