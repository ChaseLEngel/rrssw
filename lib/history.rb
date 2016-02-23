require 'sqlite3'

require_relative './logger.rb'

module RRSSW
  # Functions for querying, inserting,
  # and deleting records in a SQLite3 database.
  class History
    attr_reader :file

    # Use existing database or create a new one.
    def initialize(filename)
      @file = filename || File.join(__dir__, '../rrssw.sqlite3')
      if File.exist? @file
        @db = SQLite3::Database.new @file
        RRSSW::Logger.debug "Found database:#{@file}"
      else
        create @file
        RRSSW::Logger.debug "Created database:#{@file}"
      end
      create_functions
    end

    # Check if a title is already in database.
    # request = Title from config, assumed to be a regular expression.
    # item_title = RSS title, string.
    def include?(request, item_title)
      # Get regular expressions that match request
      @db.execute("SELECT regex(title, '#{request}') FROM history")
         .flatten.each do |result|
           # If the RSS title request substring matches a database result.
           return true if result == item_title.match(request).to_s
         end
      false
    end

    def save(title)
      timestamp = Time.now.strftime('%b %d %Y %H:%M:%S')
      @db.execute('INSERT INTO history (title, timestamp) VALUES (?, ?)',
                  title,
                  timestamp)
    end

    def all
      @db.execute('SELECT * FROM history')
    end

    def all_formated
      report = ""
      all.each do |result|
        report << "Title: #{result[0]}\n"
        report << "Timestamp: #{result[1]}\n"
        report << "#{'-' * 50}\n"
      end
      puts report
      report
    end

    def delete_all
      @db.execute('DELETE FROM history')
    end

    private

    # Create database schema.
    def create(filename)
      @db = SQLite3::Database.new(filename)
      @db.execute <<-SQL
        create table history (
        title varchar(50),
        timestamp varchar(10)
        );
      SQL
    end

    # Define custom functions for SQLite3.
    def create_functions
      # Returns the matching expression between given expression and pattern.
      @db.create_function('regex', 2) do |func, expression, pattern|
        result = expression.to_s.match(Regexp.new(pattern.to_s))
        func.result = result.to_s if result
      end
    end
  end
end
