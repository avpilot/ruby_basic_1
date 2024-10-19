class PassengerWagon < Wagon
  def initialize(seats_count)
    super(seats_count)
    @type = :passenger
  end

  def take_place
    raise 'Not enough place' if free_place == 0
    @busy_place += 1
  end

  protected

  def validate!
    super
    raise TypeError, 'Wrong seats count' unless total_place.kind_of? Integer
  end
end
