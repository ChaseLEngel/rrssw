module Notification
  def self.configure(options)
    @options = options
    @plugins = loadPlugins
  end

  def self.send(title)
    @plugins.each { |p| p.send(title) }
  end

  # Require files and return array of class names
  def self.requireAll(files)
    files.map do |file|
      require file
      File.basename(file).chomp!('.rb').capitalize
    end
  end

  def self.loadPlugins
    # Get all Ruby files from plugins directory
    files = Dir[__dir__ + '/plugins/*.rb']
    # Keep if key in configure options
    files.keep_if { |f| @options.keys.include? File.basename(f).chomp('.rb') }
    klassnames = requireAll files
    klasses = []
    # Instantiate all classes
    klassnames.each do |klassname|
      klass = Object.const_get(klassname)
      klasses << klass.new(@options[klassname.downcase])
    end
    klasses
  end

end
