class Station
  include Validation
  include InstanceCounter

  attr_reader :name, :current_trains

  validate :name, :presence

  def initialize(name)
    @name = name.to_s
    @current_trains = []
    validate!
    register_instance
  end

  def arrival(train)
    current_trains << train unless current_trains.include? train
  end

  def departure(train)
    current_trains.delete(train) if current_trains.include? train
  end

  def current_train_names
    current_trains.map(&:number)
  end

  def each_train(&block)
    current_trains.each { |train| block.call(train) }
  end

  # def validate!
  #   raise ArgumentError, 'Empty staton name' if name.empty?
  # end
end
