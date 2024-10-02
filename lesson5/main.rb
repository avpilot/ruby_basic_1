require_relative "railroad"


LIST_COMMANDS = <<HEREDOC
1 - Create station    4 - Set train route         7 - Move train by route
2 - Create train      5 - Create/attach wagons    8 - Show current station list
3 - Create route      6 - Unhook wagons           9 - Exit
HEREDOC

def select_item_by_name(items, item_name)
  puts "Current #{item_name}s: [#{items.keys * ', '}]"
  print "Select #{item_name}: "
  items[gets.chomp]
end

def build_route(railroad)
  print "\nEnter route name: "
  route_name = gets.chomp

  puts "\nSelect start station:"
  start_station = select_item_by_name(railroad.stations, "station")
  puts "\nSelect final station:"
  final_station = select_item_by_name(railroad.stations, "station")
  railroad.create_route(route_name, start_station, final_station)
  route = railroad.routes[route_name]

  loop do
    puts "\n1 - Add way point"
    puts "2 - Delete way point"
    puts "3 - Show route points"
    puts "4 - Save route"
    print "Select action: "

    user_input = gets.to_i
    case user_input
    when 1 
      station = select_item_by_name(railroad.stations, "add way point")
      route.add_station(station) if station
    when 2
      station = select_item_by_name(railroad.stations, "del way point")
      route.delete_station(station) if station
    when 3 then route.show_route_list
    when 4 then break
    else next
    end
  end
end

def create_train(railroad)
  print "\nEnter train type (cargo/passenger): "
  type = gets.chomp.to_sym
  print 'Enter train number: '
  train_number = gets.chomp
  
  if type == :passenger
    railroad.create_passenger_train(train_number)
  elsif type == :cargo
    railroad.create_cargo_train(train_number)
  end
end

def create_wagons(railroad)
  loop do
    print "\nEnter new wagon name or exit: "
    wagon_name = gets.chomp
    break if wagon_name == "exit"

    print 'Enter wagon type [cargo/passenger]: '
    case gets.chomp.to_sym
    when :cargo then railroad.create_cargo_wagon(wagon_name)
    when :passenger then railroad.create_passenger_wagon(wagon_name)
    else puts "Unknown wagon type"
    end
    puts "Current wagons: "
    railroad.show_current_wagons
  end
end

def set_train_route(railroad)
  train = select_item_by_name(railroad.trains, "Train")
  route = select_item_by_name(railroad.routes, "Route")
  train.set_route(route)
end

def move_train(railroad)
  train = select_item_by_name(railroad.trains, "train")
  print 'Move (N)ext or (P)revious way point? [N/P]: '
  case gets.chomp.upcase
  when "N" then train.move_forward
  when "P" then train.move_back
  end
end

def attach_wagon(railroad)
  puts "\nCurrent wagons: "
  railroad.show_current_wagons
  print 'Need to create new wagons? [y/n]:'
  create_wagons(railroad) if gets.chomp.upcase == 'Y'

  loop do
    puts "\nTrain=|  <-|=Wagon"
    train = select_item_by_name(railroad.trains, "train")
    wagon = select_item_by_name(railroad.wagons, "wagon")
    train.attach_wagon(wagon)
    print 'Continue [y/n]: '
    break unless gets.chomp.upcase == 'Y'
  end
end

def unhook_wagon(railroad)
  loop do
    puts "\nTrain =| X |= Wagon"
    train = select_item_by_name(railroad.trains, "train")
    wagon = select_item_by_name(railroad.wagons, "wagon")
    train.unhook_wagon(wagon)
    print 'Continue [y/n]: '
    break unless gets.chomp.upcase == 'Y'
  end
end

railroad = Railroad.new

puts "*" * 80
puts "Welcome to the Railroad management!"

loop do
  puts LIST_COMMANDS
  print "Select action: "
  
  case gets.to_i
  when 1
    print "\nEnter Station name: "
    railroad.create_station(gets.chomp)
  when 2 then create_train(railroad)
  when 3 then build_route(railroad)
  when 4 then set_train_route(railroad)
  when 5 then attach_wagon(railroad)
  when 6 then unhook_wagon(railroad)
  when 7 then move_train(railroad)
  when 8 then railroad.show_current_stations
  when 9 then break
  else next
  end
  puts
end