class PassengerWagon < Wagon
  attr_reader :train, :type, :free_seats

  def initialize(seats_count)
    @train = count
    @type = :passenger
    @seats_count = seats_count.to_i
    @free_seats = seats_count.to_i
    validate!
  end

  def take_seat
    raise 'No free seats' if @free_seats.zero?

    @free_seats -= 1
  end

  def occupied_seats
    seats_count - free_seats
  end

  protected

  def validate!
    raise ArgumentError, 'Empty seats count' if seats_count.empty?
    raise ArgumentError, 'Wrong seats count' if seats_count <= 0
  end
end
