class Wagon
  include InstanceCounter
  include Manufacturer
  include Accessors
  include Validation

  attr_reader :train, :type, :total_place, :busy_place

  validate :total_place, :presence
  validate :total_place, :type, Numeric

  def initialize(total_place)
    @train = nil
    @total_place = total_place
    @busy_place = 0
    validate!
    total_place_validate!
    register_instance
  end

  def take_place
    raise 'should be emplemented in subclasses'
  end

  def free_place
    total_place - busy_place
  end

  def attach(train)
    @train = train
  end

  def unhook(_train)
    @train = nil
  end

  def total_place_validate!
    raise ArgumentError, 'Empty place count' if total_place.zero?
    raise ArgumentError, 'Negative place count' if total_place.negative?
  end
end
