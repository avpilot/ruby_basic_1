class Train
  attr_reader :speed, :carriage_count, :type, :current_route, :current_station

  def initialize(number, type, carriage_count)
    @number = number
    @type = type
    @carriage_count = carriage_count
    @speed = 0
    @current_route = nil
    @current_station = nil
  end

  def accelerate
    @speed = 80
  end

  def stop
    @speed = 0
  end

  def attache_carriege
    @carriage_count += 1 if speed == 0
  end

  def unhook_carriege
    @carriage_count -= 1 if speed == 0 if carriage_count >= 1
  end

  def get_route(route)
    @current_route = route
    @current_station = route.start_station
    route.start_station.arrival(self)
  end

  def move(station_a, station_b)
    station_a.departure(self)
    @current_station = station_b
    station_b.arrival(self)
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
    puts "Previous: #{previous_station}" if previous_station
    puts "Current: #{current_station}" if current_station
    puts "Next: #{next_station}" if next_station
  end
end
