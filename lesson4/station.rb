class Station
  attr_reader :name, :cur_trains

  def initialize(name)
    @name = name
    @cur_trains = []
  end

  def arrival(train)
    self.cur_trains << train
  end

  def departure(train)
    self.cur_trains.delete(train)
  end

  def cur_train_types
    # Two types currently known: 'грузовой', 'пассажирский'
    freight_count = self.cur_trains.count { |train| train.type == 'грузовой' }
    puts "Грузовых: #{freight_count}"
    pass_count = self.cur_trains.count { |train| train.type == 'пассажирский' }
    puts "Пассажирских: #{pass_count}"
  end
end
