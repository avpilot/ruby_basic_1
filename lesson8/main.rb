require_relative "railroad"


LIST_COMMANDS = <<HEREDOC
1 - Create station    5 - Create/attach wagons       9  - Take up wagon space
2 - Create train      6 - Unhook wagons              10 - Train wagons 
3 - Create route      7 - Move train by route        11 - Station trains
4 - Set train route   8 - Show current stations      99 - Exit
HEREDOC

def select_item_by_name(items, item_name)
  puts "Current #{item_name}s: [#{items.keys * ', '}]"
  print "Select #{item_name} or exit: "
  input_name = gets.chomp
  
  if input_name.upcase == "EXIT"
    return
  elsif items.keys.empty?
    puts "Need to create some #{item_name}"
    return
  elsif items[input_name].nil?
    puts "#{item_name.capitalize} not found"
  end

  items[input_name]
end

def create_station(railroad)
  print "Enter Station name or exit: "
  name = gets.chomp
  return if name.upcase == "EXIT"
  puts "Created: #{railroad.create_station(name).inspect}"
rescue StandardError => e
  puts "Exception: #{e.message}, try again..."
  retry
end

def build_route(railroad)
  print "Enter route name or exit: "
  route_name = gets.chomp
  if route_name.upcase == "EXIT"
    return
  elsif route_name.empty?
    raise ArgumentError, "Empty route name"
  end
    

  puts "\nSelect start station:"
  start_station = select_item_by_name(railroad.stations, "station")
  raise ArgumentError, "Empty start station" if start_station.nil?
  puts "\nSelect final station:"
  final_station = select_item_by_name(railroad.stations, "station")
  raise ArgumentError, "Empty final station" if final_station.nil?
  route = railroad.create_route(route_name, start_station, final_station)

  puts "Created: #{route.inspect}"

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
rescue StandardError => e
  puts "Exception: #{e.message}, try again..."
  retry
end

def create_train(railroad)
  print 'Enter train number or exit: '
  train_number = gets.chomp
  return if train_number.upcase == "EXIT"

  print "Enter train type [cargo/passenger] or exit: "
  type = gets.chomp.to_sym
  
  if type == :passenger
    puts "Created: #{railroad.create_passenger_train(train_number).inspect}"
  elsif type == :cargo
    puts "Created: #{railroad.create_cargo_train(train_number).inspect}"
  else
    raise TypeError, "Wrong Train type"
  end
rescue StandardError => e
  puts "Exception: #{e.message}, try again..."
  retry
end

def create_wagons(railroad)
  loop do

    begin
      print 'Enter wagon type [cargo/passenger]: '
      type = gets.chomp.to_sym

      if type == :cargo
        # befor creating wagon
        wagon_number = "cw#{CargoWagon.instances}"
        print 'Enter wagon volume: '
        volume = gets.chomp.to_f
        wagon = railroad.create_cargo_wagon(wagon_number, volume)
        puts "Created cargo wagon: #{wagon.inspect}"
      elsif type == :passenger
        wagon_number = "pw#{PassengerWagon.instances}"
        print 'Enter wagon seats count: '
        seats_count = gets.chomp.to_i
        wagon = railroad.create_passenger_wagon(wagon_number, seats_count)
        puts "Created passenger wagon: #{wagon.inspect}"
      else 
        raise TypeError, "Wrong Wagon type"
      end
    rescue StandardError => e
      puts "Exception: #{e.message}, try again..."
      retry
    end
    railroad.show_current_wagons
    print "Enter to continue or exit: "
    user_input = gets.chomp.upcase
    break if user_input == "EXIT"
  end
end

def set_train_route(railroad)
  train = select_item_by_name(railroad.trains, "Train")
  return if train.nil?
  route = select_item_by_name(railroad.routes, "Route")
  return if route.nil?
  train.set_route(route)
end

def move_train(railroad)
  train = select_item_by_name(railroad.trains, "train")
  return if train.nil?
  
  print 'Move (N)ext or (P)revious way point? [N/P]: '
  case gets.chomp.upcase
  when "N" then train.move_forward
  when "P" then train.move_back
  end
end

def attach_wagon(railroad)
  railroad.show_current_wagons
  print 'Need to create new wagons? [y/n]: '
  create_wagons(railroad) if gets.chomp.upcase == 'Y'

  loop do
    train = select_item_by_name(railroad.trains, "train")
    wagon = select_item_by_name(railroad.wagons, "wagon")

    if train.nil? || wagon.nil?
      puts "Need train or wagon to attach"
      break
    end
    if train.attach_wagon?(wagon)
      puts "#{railroad.wagons.key(wagon)} successfully attach "\
           "to #{train.number}"
    end
    print 'Continue [y/n]: '
    break unless gets.chomp.upcase == 'Y'
  end
end

def unhook_wagon(railroad)
  loop do
    train = select_item_by_name(railroad.trains, "train")
    wagon = select_item_by_name(railroad.wagons, "wagon")
    
    if train.nil? || wagon.nil?
      puts "Need train or wagon to unhook"
      break
    end

    if train.unhook_wagon?(wagon)
      puts "#{railroad.wagons.key(wagon)} successfully unhook "\
           "from #{train.number}"
    end
    print 'Continue [y/n]: '
    break unless gets.chomp.upcase == 'Y'
  end
end

def take_space(railroad)
  railroad.show_current_wagons
  print "Enter to continue or exit: "
  user_input = gets.chomp.upcase
  return if user_input == "EXIT"
  
  loop do
    puts 'Enter wagon number or exit: '
    wagon = select_item_by_name(railroad.wagons, "wagon")
    return if wagon.nil?
    print 'Space to take up: '
    if wagon.type == :cargo
      space_count = gets.chomp.to_f
    else
      space_count = gets.chomp.to_i
    end
    wagon.take_space(space_count)
    print 'Continue [y/n]: '
    break unless gets.chomp.upcase == 'Y'
  end
rescue StandardError => e
  puts "Exception: #{e.message}, try again..."
  retry
end

def show_train_wagons(railroad)
  puts 'Enter train number or exit: '
  train = select_item_by_name(railroad.trains, "train")
  return if train.nil?

  train.each_wagon do |wagon|
    puts "#{railroad.wagons.key(wagon)}, #{wagon.type}, "\
         "free: #{wagon.free_space}, busy: #{wagon.busy_space}"
  end
end

def show_station_trains(railroad)
  puts 'Enter station name or exit: '
  station = select_item_by_name(railroad.stations, "station")
  return if station.nil?

  station.each_train do |train|
    puts "  #{train.number}, #{train.type}, #{train.wagons.size} wagons"
    train.each_wagon do |wagon|
      puts "    #{railroad.wagons.key(wagon)}, #{wagon.type}, "\
           "free: #{wagon.free_space}, busy: #{wagon.busy_space}"
    end
  end
end


railroad = Railroad.new

puts "*" * 80
puts "Welcome to the Railroad management!"

loop do
  puts LIST_COMMANDS
  print "Select action: "
  
  case gets.to_i
  when 1 then create_station(railroad)
  when 2 then create_train(railroad)
  when 3 then build_route(railroad)
  when 4 then set_train_route(railroad)
  when 5 then attach_wagon(railroad)
  when 6 then unhook_wagon(railroad)
  when 7 then move_train(railroad)
  when 8 then railroad.show_current_stations
  when 9 then take_space(railroad)
  when 10 then show_train_wagons(railroad)
  when 11 then show_station_trains(railroad)
  when 99 then break
  else next
  end
  puts
end