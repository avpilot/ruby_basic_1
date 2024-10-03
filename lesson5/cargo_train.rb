class CargoTrain < Train
  attr_reader :type

  CRUISING_SPEED = 60

  def initialize(number)
    super
    @type = :cargo
  end
end
