require 'sqlite3'

class History

	def initialize filename
		file = filename || File.join(__dir__, "rrssw.sqlite3")
		if File.exists? file
			@db = SQLite3::Database.new file
		else
			create file
		end
		createFunctions
	end

	def include? request, item_title
		# Get regular expressions that match request
		results = @db.execute("SELECT regex(title, '#{request}') FROM history").flatten
		results.each do |result|
			return true if result == item_title.match(request).to_s
		end
		return false
	end

	def save title
		timestamp = Time.now.strftime('%b %d %Y %H:%M:%S')
		@db.execute("INSERT INTO history (title, timestamp)
			VALUES (?, ?)", 
			title, timestamp)
	end

	def all
		@db.execute("SELECT * FROM history")
	end

	def all_formated
		report = ""
		self.all.each do |result|
			report << "Title: #{result[0]}\n"
			report << "Timestamp: #{result[1]}\n"
			report << "-"*50+"\n"
		end
		report
	end

	def delete_all
		@db.execute("DELETE FROM history")
	end

	private

		def create filename
			@db = SQLite3::Database.new(filename)
			@db.execute <<-SQL
				create table history (
					title varchar(50),
					timestamp varchar(10)
				);
			SQL
		end

		def createFunctions
			# Returns the matching expression between given expression and pattern.
			@db.create_function("regex", 2) do |func, expression, pattern|
				result = expression.to_s.match(Regexp.new(pattern.to_s))
				func.result = if result
					result.to_s
				else
					nil
				end
			end
  	end
end
