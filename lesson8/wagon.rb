class Wagon
  include Manufacturer, InstanceCounter

  attr_reader :train, :type, :busy_place, :total_place

  def initialize(total_place)
    @train = nil
    @total_place = total_place
    @busy_place = 0
    validate!
    register_instance
  end

  def take_place
    raise 'need emplementation of this method'
  end

  def free_place
    total_place - busy_place
  end

  def attach(train)
    @train = train
  end

  def unhook(train)
    @train = nil
  end

  protected

  def validate!
    raise ArgumentError, 'Empty place count' if total_place.zero?
    raise ArgumentError, 'Negative place count' if total_place < 0
  end
end
