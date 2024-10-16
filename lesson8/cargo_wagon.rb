class CargoWagon < Wagon
  attr_reader :train, :type, :free_volume

  def initialize(volume)
    @train = nil
    @type = :cargo
    @volume = volume
    @free_volume = volume
    validate!
  end

  def take_volume(volume)
    raise 'Not enough volume' if volume > free_volume

    free_volume -*-= volume
  end

  def busy_space
    volume - free_volume
  end

  def free_space
    free_volume
  end

  protected

  def validate!
    raise ArgumentError, 'Empty volume' if volume.empty?
    raise ArgumentError, 'Wrong volume' if volume <= 0
    raise TypeError, 'Wrong volume type' if seats_count.kind_of? Numeric
  end
end
