require_relative "railroad"


LIST_COMMANDS = <<HEREDOC
1 - Create station    4 - Set train route         7 - Move train by route
2 - Create train      5 - Create/attach wagons    8 - Show current station list
3 - Create route      6 - Unhook wagons           9 - Exit
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
    print "\nEnter new wagon name or exit: "
    wagon_name = gets.chomp
    break if wagon_name == "exit"

    begin
      print 'Enter wagon type [cargo/passenger]: '
      type = gets.chomp.to_sym

      if type == :cargo
        print 'Enter wagon volume: '
        volume = gets.chomp.to_f
        wagon = railroad.create_cargo_wagon(wagon_name, volume)
        puts "Created cargo wagon: #{wagon.inspect}"
      elsif type == :passenger
        print 'Enter wagon seats count: '
        seats_count = gets.chomp.to_i
        wagon = railroad.create_passenger_wagon(wagon_name, seats_count)
        puts "Created passenger wagon: #{wagon.inspect}"
      else 
        raise TypeError, "Wrong Wagon type"
      end
    rescue StandardError => e
      puts "Exception: #{e.message}, try again..."
      retry
    end
    puts "Current wagons: "
    railroad.show_current_wagons
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
  puts "\nCurrent wagons: "
  railroad.show_current_wagons
  print 'Need to create new wagons? [y/n]:'
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
  when 9 then break
  else next
  end
  puts
end