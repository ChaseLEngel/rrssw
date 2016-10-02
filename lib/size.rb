class Size
  attr_reader :size

  BLK = 1024

  def initialize(size)
    @size = size
  end

  def formatted
    @size
  end

  # Convert formatted size to bytes
  def bytes
    amount = @size.split(' ')[0].to_i
    unit = @size.split(' ')[1].upcase
    @bits ||= case unit
              when 'KB'
                amount*BLK
              when 'MB'
                amount*BLK**2
              when 'GB'
                amount*BLK**3
              when 'TB'
                amount*BLK**4
              else
                0
              end
  end
end
