require 'sqlite3'

require_relative './logger.rb'

# Functions for querying, inserting,
# and deleting records in a SQLite3 database.
class History
  attr_reader :file

  # Use existing database or create a new one.
  def initialize(filename)
    @file = filename || File.join(__dir__, '../rrssw.sqlite3')
    @cache = {}
    if File.exist? @file
      @db = SQLite3::Database.new @file
      Slogger.instance.debug "Found database:#{@file}"
    else
      create @file
      Slogger.instance.debug "Created database:#{@file}"
    end
    create_functions
  end

  # Check if a title is already in database.
  # request - String expression from config.
  # title - String title from RSS feed.
  def include?(request, title)
    # Try cache first
    if check_cache(request, title)
      Slogger.instance.debug "Cache hit for #{title}"
      return true
    end
    Slogger.instance.debug "Cache miss for #{title}"
    find(request)
    check_cache(request, title)
  end

  def save(title)
    timestamp = Time.now.strftime('%b %d %Y %H:%M:%S')
    @db.execute('INSERT INTO history (title, timestamp) VALUES (?, ?)',
                title,
                timestamp)
  end

  def print
    all.each do |result|
      puts %(Title: #{result[0]}\nTimestamp: #{result[1]}\n#{'-' * 50})
    end
  end

  def delete_all
    @db.execute('DELETE FROM history')
  end

  private

  def all
    @db.execute('SELECT * FROM history')
  end

  # Cache past queries based on request.
  def check_cache(request, title)
    @cache[request] ||= find(request)
    @cache[request].each do |result|
      return true if result == title.match(request).to_s
    end
    false
  end

  # Get regular expressions that match request
  def find(request)
    query = "SELECT regex(title, '#{request}') FROM history"
    @cache[request] = @db.execute(query).flatten
  end

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
