class Station
  include InstanceCounter, Validator
  
  attr_reader :name, :current_trains

  @@instances = 0


  def initialize(name)
    @name = name.to_s
    @current_trains = []
    validate!
    @@instances += 1
    register_instance
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

  def self.all
    @@instances
  end

  protected

  def validate!
    raise ArgumentError, "Empty staton name" if name.empty?
  end
end
