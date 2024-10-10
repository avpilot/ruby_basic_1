class CargoWagon < Wagon
  attr_reader :train, :type, :free_volume

  def initialize(volume)
    @train = nil
    @type = :cargo
    @volume = volume
    @free_volume = volume
  end

  def take_volume(volume)
    raise "Not enough volume" if volume > free_volume
  end

  def busy_volume
    volume - free_volume
  end
end
