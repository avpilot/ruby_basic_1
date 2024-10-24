module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      vars_name = "@#{name}s".to_sym
      instance_variable_set(vars_name, [instance_variable_get(var_name)]) unless instance_variable_get(vars_name)
      
      define_method(name) { instance_variable_get(var_name)}
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(var_name, value)
        instance_variable_get(vars_name).append(value)
      end
      define_method("#{name}_history") { puts "some history here..."}
  end
  end

  # <имя_атрибута>_history

  def strong_attr_accessor
  end
end