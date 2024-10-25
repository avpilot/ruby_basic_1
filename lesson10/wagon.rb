class Wagon
  include InstanceCounter
  include Manufacturer
  include Accessors

  attr_reader :type, :total_place
  attr_accessor_with_history :train
  strong_attr_accessor :busy_place, Integer

  def initialize(total_place)
    @train = nil
    @total_place = total_place
    @busy_place = 0
    validate!
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

  protected

  def validate!
    raise ArgumentError, 'Empty place count' if total_place.zero?
    raise ArgumentError, 'Negative place count' if total_place.negative?
  end
end
