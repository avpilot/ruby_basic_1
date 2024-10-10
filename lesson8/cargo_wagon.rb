class CargoWagon < Wagon
  attr_reader :train, :type

  def initialize
    @train = nil
    @type = :cargo
  end
end
