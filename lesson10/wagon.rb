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

  protected

  def total_place_validate!
    raise ArgumentError, 'Not positive place count' unless total_place.positive?
  end
end
