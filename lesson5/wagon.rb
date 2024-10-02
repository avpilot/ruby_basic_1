class Wagon
  
  def attach(train)
    @train = train
  end

  def unhook(train)
    @train = nil
  end
end
