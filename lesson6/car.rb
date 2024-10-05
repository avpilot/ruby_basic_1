module Debugger
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def debug(log)
      puts "!!!Debug #{log} !!!"
    end
  end

  module InstanceMethods
    def debug(log)
      self.class.debug(log)
    end

    def print_class
      puts self.class
    end
  end
end


class Car
  include Debugger::InstanceMethods
  extend Debugger::ClassMethod
end

class MotorBike
end