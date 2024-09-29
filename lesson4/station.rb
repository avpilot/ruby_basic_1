class Station
  attr_reader :name, :current_trains

  def initialize(name)
    @name = name
    @current_trains = []
  end

  def arrival(train)
    current_trains << train
  end

  def departure(train)
    current_trains.delete(train)
  end

  def current_train_types
    # Two types currently known: 'грузовой', 'пассажирский'
    freight_count = current_trains.count do |train|
      train.type == 'грузовой'
    end
    puts "Грузовых: #{freight_count}"
    
    passenger_count = current_trains.count do |train|
      train.type == 'пассажирский'
    end
    puts "Пассажирских: #{passenger_count}"
  end
end
