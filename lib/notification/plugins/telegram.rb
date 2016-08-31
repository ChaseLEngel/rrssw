require 'rest-client'

class String
  def to_instance
    ('@' + self).to_sym
  end
end

class Telegram
  ATTRIBUTES = %w{message token chat_id}

  def initialize(opts)
    @options = opts
    set_attributes
    @url = "https://api.telegram.org/bot#{@token}/sendMessage"
  end

  # Define class instance variables
  def set_attributes
    ATTRIBUTES.each do |attr|
      opts_value = @options[attr]
      fail "Attribute #{attr} is nil" if opts_value.nil?
      instance_variable_set attr.to_instance, opts_value
    end
  end

  def format_message(title)
    @message.gsub '%title%', title
  end

  # Send message to Telegram
  def send(title)
    message = format_message title
    RestClient.post @url, chat_id: @chat_id, text: message
  end
end
