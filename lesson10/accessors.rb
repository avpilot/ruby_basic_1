module Accessors
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        history_name = "@#{name}_history".to_sym

        define_method(name) { instance_variable_get(var_name) }
        new_value_method(name, var_name, history_name)
        define_method("#{name}_history") { instance_variable_get(history_name) }
      end
    end

    def new_value_method(name, var_name, history_name)
      define_method("#{name}=".to_sym) do |value|
        previous_value = instance_variable_get(var_name)
        history = instance_variable_get(history_name)
        history ||= instance_variable_set(history_name, [previous_value])

        instance_variable_set(var_name, value)
        history << value unless history.last == value
      end
    end

    def strong_attr_accessor(name, var_class)
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        raise TypeError, 'Wrong variable type' unless value.is_a? var_class

        instance_variable_set(var_name, value)
      end
    end
  end

  module InstanceMethods
  end
end
