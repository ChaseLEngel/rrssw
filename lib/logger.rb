class Logger

	def initialize filename
		log_file = filename || File.join(__dir__, "../rrssw.log")
		@log_file = File.new(log_file, "a")
	end
	
	def error message
		@log_file.puts "[#{timestamp}][ERROR] #{message}"
	end

	def info message
		@log_file.puts "[#{timestamp}][INFO] #{message}"
	end

	private

		def timestamp
			Time.now.strftime('%b %d %Y %H:%M:%S')
		end

end
