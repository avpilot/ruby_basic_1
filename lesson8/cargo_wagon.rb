class CargoWagon < Wagon
  def initialize(volume)
    @type = :cargo
    super(volume)
  end

  def take_place(volume)
    raise 'Not enough place' if free_place < volume
    @busy_place += volume
  end
end
