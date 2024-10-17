require_relative 'manufacturer'
require_relative 'validator'
require_relative 'instance_counter'
require_relative 'train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'cargo_wagon'
require_relative 'passenger_wagon'

VEHICLE_TYPES = [:cargo, :passenger]

class Railroad
  attr_reader :trains, :stations, :routes, :wagons

  def initialize
    @trains = {}
    @stations = {}
    @routes = {}
    @wagons = {}
  end

  def create_station(name)
    stations[name] = Station.new(name)
  end

  def create_cargo_train(train_number)
    trains[train_number] = CargoTrain.new(train_number)
  end

  def create_cargo_wagon(wagon_number, volume)
    wagons[wagon_number] = CargoWagon.new(volume)
  end

  def create_passenger_wagon(wagon_number, seats_count)
    wagons[wagon_number] = PassengerWagon.new(seats_count)
  end

  def create_passenger_train(train_number)
    trains[train_number] = PassengerTrain.new(train_number)
  end

  def create_route(route_name, start_station, final_station)
    routes[route_name] = Route.new(start_station, final_station)
  end

  def show_current_wagons
    puts "\nCurrent wagons: "
    puts "No wagons yet..." if wagons.empty?
    wagons.each do |name, wagon|
      print "  #{name}, #{wagon.type}, "\
             "free: #{wagon.free_space}, busy: #{wagon.busy_space}"

      if wagon.train
        puts " - Train: #{wagon.train.number}"
      else
        puts " - Free"
      end
    end
  end

  def show_current_stations
    puts "\nCurrent station with trains:"
    stations.each do |station_name, station|
      puts "-#{station_name}: "
      station.each_train do |train|
        puts "  #{train.number}, #{train.type}, #{train.wagons.size} wagons"
        train.each_wagon do |wagon|
          puts "    #{wagons.key(wagon)}, #{wagon.type}, "\
               "free: #{wagon.free_space}, busy: #{wagon.busy_space}"
        end
      end
    end
  end
end
