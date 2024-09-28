class Train
  attr_reader :speed, :carriage_count, :type, :cur_route, :cur_stn

  def initialize(number, type, carriage_count)
    @number = number
    @type = type
    @carriage_count = carriage_count
    @speed = 0
    @cur_route = nil
    @cur_stn = nil
  end

  def accelerate
    @speed = 80
  end

  def stop
    @speed = 0
  end

  def attache_carriege
    @carriage_count += 1 if self.speed == 0
  end

  def unhook_carriege
    @carriage_count -= 1 if self.speed == 0 if self.carriage_count >= 1
  end

  def get_route(route)
    @cur_route = route
    @cur_stn = route.start_stn
    route.start_stn.arrival(self)
  end

  def move(stn_a, stn_b)
    stn_a.departure(self)
    @cur_stn = stn_b
    stn_b.arrival(self)
  end

  def move_forward
    next_stn = cur_route.next_point(self.cur_stn)
    self.move(self.cur_stn, next_stn) if next_stn
  end

  def move_back
    prev_stn = cur_route.prev_point(self.cur_stn)
    self.move(self.cur_stn, prev_stn) if prev_stn
  end

  def nearest_stations
    next_stn = cur_route.next_point(self.cur_stn)
    prev_stn = cur_route.prev_point(self.cur_stn)
    puts "Previous: #{prev_stn}" if prev_stn 
    puts "Current: #{self.cur_stn}" if self.cur_stn
    puts "Next: #{next_stn}" if next_stn
  end
end
