class Route
  attr_reader :start_stn, :final_stn, :stations

  def initialize(start_stn, final_stn)
    @start_stn = start_stn
    @final_stn = final_stn
    @stations = [start_stn, final_stn]
  end

  def add_station(stn)
    # Add new station befor finish if not present
    self.stations.insert(-2, stn) unless stations.include? stn
  end

  def del_station(stn)
    self.stations.delete(stn) if stn != self.start_stn && stn != self.final_stn
  end

  def show_route_list
    self.stations.each { |stn| puts stn.name }
  end

  def next_point(stn)
    stations[self.stations.index(stn) + 1] unless stn == final_stn
  end

  def prev_point(stn)
    stations[self.stations.index(stn) - 1] unless stn == start_stn
  end
end
