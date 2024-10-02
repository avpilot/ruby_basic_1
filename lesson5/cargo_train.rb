class CargoTrain < Train
  attr_reader :type

  CRUISING_SPEED = 60

  def initialize(number)
    super
    @type = :cargo
  end

  def attach_wagon(wagon)
    if wagon.type == type
      super(wagon)
      wagon.attach(self)
      puts "Attach successfully!"
    else
      puts "Failed, differnt types of train and wagon"
    end
  end

  def unhook_wagon(wagon)
    if wagon.type == type
      super(wagon)
      wagon.unhook(self)
      puts "Unhook successfully!"
    else
      puts "Failed, differnt types of train and wagon"
    end
  end
end
