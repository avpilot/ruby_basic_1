class PassengerTrain < Train
  attr_reader :type

  def initialize(number)
    super
    @type = :passenger
  end

  def attach_wagon(wagon)
    if wagon.type == type
      super(wagon)
      puts "Attach successfully!"
    else
      puts "Failed, differnt types of train and wagon"
    end
  end

  def unhook_wagon(wagon)
    if wagon.type == type
      super(wagon)
      puts "Unhook successfully!"
    else
      puts "Failed, differnt types of train and wagon"
    end
  end
end
