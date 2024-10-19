class CargoWagon < Wagon
  def initialize(volume)
    super(volume)
    @type = :cargo
  end

  def take_place(volume)
    raise 'Not enough place' if free_place < volume
    @busy_place += volume
  end

  protected

  def validate!
    super
    raise TypeError, 'Wrong volume type' unless total_place.kind_of? Numeric
  end
end
