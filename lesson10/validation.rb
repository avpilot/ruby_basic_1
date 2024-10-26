module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(name, validation_type, *args)
      case validation_type
      when :presence then new_presence_check(name)
      when :format then new_format_check(name, args)
      when :type then new_type_check(name, args.first)
      else raise 'Unknown validation type'
      end
    end

    def new_presence_check(name)
      define_method("#{name}_presence_validation") do
        var_value = instance_variable_get("@#{name}".to_sym)
        raise 'Presence validation error' if var_value.nil? || var_value.empty?
      end
    end

    def new_format_check(name, formats)
      define_method("#{name}_format_validation") do
        var_value = instance_variable_get("@#{name}".to_sym)
        formats.each do |format|
          raise 'Format validation error' if var_value !~ format
        end
      end
    end

    def new_type_check(name, var_type)
      define_method("#{name}_type_validation") do
        var_value = instance_variable_get("@#{name}".to_sym)
        raise 'Type validation error' unless var_value.is_a? var_type
      end
    end
  end

  module InstanceMethods
    def validate!
      method_names = methods.select { |name| name.end_with? '_validation' }
      method_names.each { |method_name| send(method_name) }
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end
  end
end
