class Wagon
  include Manufacturer, InstanceCounter

  def attach(train)
    @train = train
  end

  def unhook(train)
    @train = nil
  end
end
