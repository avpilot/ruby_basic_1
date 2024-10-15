class CargoWagon < Wagon
  attr_reader :train, :type, :free_volume

  def initialize(volume)
    @train = nil
    @type = :cargo
    @volume = volume.to_f
    @free_volume = volume.to_f
    validate!
  end

  def take_volume(volume)
    raise 'Not enough volume' if volume > free_volume
  end

  def busy_volume
    volume - free_volume
  end

  protected

  def validate!
    raise ArgumentError, 'Empty volume' if volume.empty?
    raise ArgumentError, 'Wrong volume' if volume <= 0
  end
end
