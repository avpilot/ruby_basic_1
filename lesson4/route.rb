class Route
  attr_reader :start_station, :final_station, :stations

  def initialize(start_station, final_station)
    @start_station = start_station
    @final_station = final_station
    @stations = [start_station, final_station]
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
    stations.each { |station| puts station.name }
  end

  def next_point(station)
    stations[stations.index(station) + 1] unless station == final_station
  end

  def previous_point(station)
    stations[stations.index(station) - 1] unless station == start_station
  end
end
