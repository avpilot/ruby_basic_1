class Station
  attr_reader :name, :current_trains

  def initialize(name)
    @name = name
    @current_trains = []
  end

  def arrival(train)
    current_trains << train unless current_trains.include? train
  end

  def departure(train)
    current_trains.delete(train) if current_trains.include? train
  end

  def current_train_names
    current_trains.map { |train| train.number }
  end
end
