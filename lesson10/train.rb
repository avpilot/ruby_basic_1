require_relative 'station'

class Train
  include InstanceCounter
  include Manufacturer
  include Validation
  include Accessors

  attr_reader :number, :speed, :wagons, :type

  attr_accessor_with_history :current_route
  strong_attr_accessor :current_station, Station

  CRUISING_SPEED = 80

  validate :number, :presence
  validate :number, :format, /^([a-z]|\d){3}-?([a-z]|\d){2}$/i

  def initialize(number)
    @number = number.to_s
    @wagons = []
    @speed = 0
    @current_route = nil
    @current_station = nil
    @type = nil
    validate!
    register_instance
  end

  def accelerate
    @speed = CRUISING_SPEED
  end

  def stop
    @speed = 0
  end

  def move_forward
    next_station = current_route.next_point(current_station)
    move(current_station, next_station) if next_station
  end

  def move_back
    previous_station = current_route.previous_point(current_station)
    move(current_station, previous_station) if previous_station
  end

  def nearest_stations
    next_station = current_route.next_point(current_station)
    previous_station = current_route.previous_point(current_station)
    { previous: previous_station, current: current_station, next: next_station }
  end

  def attach_wagon?(wagon)
    if type && speed.zero? && wagon.type == type && wagons.none?(wagon)
      @wagons.append(wagon)
      wagon.attach(self)
      true
    else
      false
    end
  end

  def unhook_wagon?(wagon)
    if speed.zero? && wagons.include?(wagon)
      @wagons.delete(wagon)
      wagon.unhook(self)
      true
    else
      false
    end
  end

  def each_wagon(&block)
    wagons.each { |wagon| block.call(wagon) }
  end

  private

  # Вызываются только внутри класса Train
  def move(station_a, station_b)
    station_a.departure(self)
    @current_station = station_b
    station_b.arrival(self)
  end
end
