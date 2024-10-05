class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :speed, :current_route, :current_station, :wagons, :type

  CRUISING_SPEED = 80

  @@trains = {}


  def initialize(number)
    @number = number
    @wagons = []
    @speed = 0
    @current_route = nil
    @current_station = nil
    @type = nil
    @@trains[number] = self
    register_instance
  end

  def accelerate
    @speed = CRUISING_SPEED
  end

  def stop
    @speed = 0
  end

  def set_route(route)
    @current_route = route
    @current_station = route.start_station
    route.start_station.arrival(self)
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

  def attach_wagon(wagon)
    if type && speed == 0 && wagon.type == type && wagons.none?(wagon)
      @wagons.append(wagon)
      wagon.attach(self)
      puts "Attach successfully!"
    else
      puts "Failed, something went wrong..."
    end
  end

  def unhook_wagon(wagon)
    if speed == 0 && wagons.include?(wagon)
      @wagons.delete(wagon)
      wagon.unhook(self)
      puts "Unhook successfully!"
    else
      puts "Failed, something went wrong..."
    end
  end

  def self.find(number)
    @@trains[number]
  end

  private

  # Вызываются только внутри класса Train
  def move(station_a, station_b)
    station_a.departure(self)
    @current_station = station_b
    station_b.arrival(self)
  end
end
