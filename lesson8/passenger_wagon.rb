class PassengerWagon < Wagon
  def initialize(seats_count)
    @type = :passenger
    super(seats_count)
  end

  def take_place
    raise 'Not enough place' if free_place.zero?
    @busy_place += 1
  end
end
