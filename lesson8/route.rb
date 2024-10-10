class Route
  include InstanceCounter, Validator

  attr_reader :start_station, :final_station, :stations


  def initialize(start_station, final_station)
    @start_station = start_station
    @final_station = final_station
    validate!
    @stations = [start_station, final_station]
    register_instance
  end

  def add_station(station)
    # Add new station befor finish if not present
    stations.insert(-2, station) unless stations.include? station
  end

  def delete_station(station)
    if station != start_station && station != final_station
      stations.delete(station) 
    end
  end

  def show_route_list
    print "\nCurrent route:\n[ "
    stations[0..-2].each { |station| print "#{station.name}-" }
    puts "#{stations[-1].name} ]"
  end

  def next_point(station)
    stations[stations.index(station) + 1] unless station == final_station
  end

  def previous_point(station)
    stations[stations.index(station) - 1] unless station == start_station
  end

  protected

  def validate!
    if start_station.nil?
      raise ArgumentError, "Empty start station"
    elsif  final_station.nil?
      raise ArgumentError, "Empty final station"
    elsif start_station.class != Station || final_station.class != Station
      raise TypeError, "Wrong station type"
    end
  end
end
