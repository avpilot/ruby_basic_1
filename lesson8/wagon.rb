class Wagon
  include Manufacturer
  
  def attach(train)
    @train = train
  end

  def unhook(train)
    @train = nil
  end

  def free_space; end

  def busy_space; end
end
