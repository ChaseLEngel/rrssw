require 'ostruct'
require 'yaml'

require_relative './logger.rb'

# Read in config file and parse groups.
class Config
  NoConfigFile = Class.new(StandardError)

  attr_reader :file

  def initialize(filename)
    @file = filename || File.join(__dir__, '../config.yml')
    unless File.exist? @file
      fail NoConfigFile, "#{@file} does not exist or is not a file."
    end
    Slogger.instance.debug "Config loaded:#{@file}"
    @config = YAML.load_file(@file)
  end

  # Returns an array of group objects taken from config file.
  def groups
    groups = []
    @config['groups'].each do |k, v|
      groups << OpenStruct.new(
        name: k,
        rss: v['rss'],
        requests: v['requests'],
        path: v['path'])
    end
    groups.freeze
  end
end
