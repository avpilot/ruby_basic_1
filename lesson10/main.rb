require_relative 'railroad'

def list_commands
  <<~HEREDOC
    1 - Create station    6 - Attach wagons          11 - Train wagons
    2 - Create train      7 - Unhook wagons          12 - Station trains
    3 - Create wagon      8 - Move train by route    99 - Exit
    4 - Create route      9 - Show current stations
    5 - Set train route  10 - Take up wagon space
  HEREDOC
end

def route_commands
  <<~HEREDOC
    1 - Add way point
    2 - Delete way point
    3 - Show route points
    4 - Save route
  HEREDOC
end

def select_item_by_name(items, item_name)
  puts "Current #{item_name}s: [#{items.keys * ', '}]"
  print "Select #{item_name} or exit: "
  input_name = gets.chomp

  return if input_name.upcase == 'EXIT'

  puts "Need to create some #{item_name}" if items.keys.empty?
  puts "#{item_name.capitalize} not found" if items[input_name].nil?
  items[input_name]
end

def create_station(railroad)
  print 'Enter Station name or exit: '
  name = gets.chomp
  return if name.upcase == 'EXIT'

  puts "Created: #{railroad.create_station(name).inspect}"
rescue StandardError => e
  puts "Exception: #{e.message}, try again..."
  retry
end

def build_route(railroad)
  route_name = gets.chomp
  raise ArgumentError, 'Empty route name' if route_name.empty?

  start_station = select_item_by_name(railroad.stations, 'start station')
  final_station = select_item_by_name(railroad.stations, 'final station')
  raise ArgumentError, 'Empty final station' if start_station.nil? ||
                                                final_station.nil?

  route = railroad.create_route(route_name, start_station, final_station)
  puts "Created: #{route.inspect}"
  manage_route(railroad, route)
end

def add_waypoint(railroad, route)
  station = select_item_by_name(railroad.stations, 'add way point')
  route.add_station(station) if station
end

def del_waypoint(railroad, route)
  station = select_item_by_name(railroad.stations, 'del way point')
  route.delete_station(station) if station
end

def manage_route(railroad, route)
  loop do
    puts route_commands
    print 'Select action: '
    case gets.to_i
    when 1 then add_waypoint(railroad, route)
    when 2 then del_waypoint(railroad, route)
    when 3 then route.show_route_list
    when 4 then break
    end
  end
end

def create_train(railroad)
  print 'Enter train number: '
  train_number = gets.chomp

  print 'Enter train type [cargo/passenger] or exit: '
  case gets.chomp.to_sym
  when :passenger
    puts "Created: #{railroad.create_passenger_train(train_number).inspect}"
  when :cargo
    puts "Created: #{railroad.create_cargo_train(train_number).inspect}"
  else raise TypeError, 'Wrong Train type'
  end
end

def new_cargo_wagon(railroad)
  wagon_number = "cw#{CargoWagon.instances}"
  print 'Enter wagon volume: '
  volume = gets.chomp.to_f
  railroad.create_cargo_wagon(wagon_number, volume)
end

def new_passenger_wagon(railroad)
  wagon_number = "pw#{PassengerWagon.instances}"
  print 'Enter wagon seats count: '
  seats_count = gets.chomp.to_i
  railroad.create_passenger_wagon(wagon_number, seats_count)
end

def new_wagon(railroad)
  print 'Enter wagon type [cargo/passenger]: '
  type = gets.chomp.to_sym

  case type
  when :cargo then wagon = new_cargo_wagon(railroad)
  when :passenger then wagon = new_cargo_wagon(railroad)
  else raise TypeError, 'Wrong Wagon type'
  end
  puts "Created #{type} wagon: #{wagon.inspect}"
end

def create_wagons(railroad)
  loop do
    railroad.show_current_wagons
    new_wagon(railroad)
    print 'Enter to continue or exit: '
    user_input = gets.chomp.upcase
    break if user_input == 'EXIT'
  end
rescue StandardError => e
  puts "Exception: #{e.message}, try again..."
  retry
end

def train_route(railroad)
  train = select_item_by_name(railroad.trains, 'Train')
  return if train.nil?

  route = select_item_by_name(railroad.routes, 'Route')
  return if route.nil?

  train.waypoints(route)
end

def move_train(railroad)
  train = select_item_by_name(railroad.trains, 'train')
  return if train.nil?

  print 'Move (N)ext or (P)revious way point? [N/P]: '
  case gets.chomp.upcase
  when 'N' then train.move_forward
  when 'P' then train.move_back
  end
end

def attach_wagon(railroad)
  train = select_item_by_name(railroad.trains, 'train')
  wagon = select_item_by_name(railroad.wagons, 'wagon')

  if train.nil? || wagon.nil?
    puts 'Need train or wagon to attach'
  elsif train.attach_wagon?(wagon)
    puts "#{railroad.wagons.key(wagon)} attach to #{train.number}"
  end
end

def unhook_wagon(railroad)
  train = select_item_by_name(railroad.trains, 'train')
  wagon = select_item_by_name(railroad.wagons, 'wagon')

  if train.nil? || wagon.nil?
    puts 'Need train or wagon to unhook'
  elsif train.unhook_wagon?(wagon)
    puts "#{railroad.wagons.key(wagon)} successfully unhook "\
         "from #{train.number}"
  end
end

def take_place(railroad)
  railroad.show_current_wagons
  puts 'Enter wagon number: '
  wagon = select_item_by_name(railroad.wagons, 'wagon')
  return if wagon.nil?

  if wagon.type == :cargo
    print 'Volume to take up: '
    wagon.take_place(gets.chomp.to_f)
  elsif wagon.type == :passenger
    wagon.take_place
  end
end

def show_train_wagons(railroad)
  puts 'Enter train number or exit: '
  train = select_item_by_name(railroad.trains, 'train')
  return unless train

  puts "Train #{train.number} has no wagons" if train.wagons.empty?
  train.each_wagon do |wagon|
    puts "#{railroad.wagons.key(wagon)}, #{wagon.type}, "\
         "free: #{wagon.free_place}, busy: #{wagon.busy_place}"
  end
end

def show_wagons(railroad, train)
  train.each_wagon do |wagon|
    puts "    #{railroad.wagons.key(wagon)}, #{wagon.type}, "\
         "free: #{wagon.free_place}, busy: #{wagon.busy_place}"
  end
end

def show_station_trains(railroad)
  station = select_item_by_name(railroad.stations, 'station')
  return unless station

  puts "#{station.name} has no trains" if station.current_train_names.empty?
  station.each_train do |train|
    puts "-#{train.number}, #{train.type}, #{train.wagons.size} wagons"
    show_wagons(railroad, train)
  end
end

railroad = Railroad.new

puts '*' * 80
puts 'Welcome to the Railroad management!'

loop do
  puts list_commands
  print 'Select action: '

  case gets.to_i
  when 1 then create_station(railroad)
  when 2 then create_train(railroad)
  when 3 then create_wagons(railroad)
  when 4 then build_route(railroad)
  when 5 then train_route(railroad)
  when 6 then attach_wagon(railroad)
  when 7 then unhook_wagon(railroad)
  when 8 then move_train(railroad)
  when 9 then railroad.show_current_stations
  when 10 then take_place(railroad)
  when 11 then show_train_wagons(railroad)
  when 12 then show_station_trains(railroad)
  when 99 then break
  else next
  end
  puts
rescue StandardError => e
  puts "Exception: #{e.message}, try again..."
  retry
end
