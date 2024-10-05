class Wagon
  include Manufacturer
  
  def attach(train)
    @train = train
  end

  def unhook(train)
    @train = nil
  end
end
