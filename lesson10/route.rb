class Route
  include Validation
  include InstanceCounter

  attr_reader :start_station, :final_station, :stations

  validate :start_station, :presence
  validate :final_station, :presence
  validate :start_station, :type, Station
  validate :final_station, :type, Station

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
    return unless station != start_station && station != final_station

    stations.delete(station)
  end

  def show_route_list
    stations[0..-2].each { |station| print "#{station.name}-" }
    puts stations[-1].name
  end

  def next_point(station)
    stations[stations.index(station) + 1] unless station == final_station
  end

  def previous_point(station)
    stations[stations.index(station) - 1] unless station == start_station
  end
end
