module Validation
  ValidationError = Class.new(StandardError)
  
  def self.included(klass)
    klass.extend ClassMethods
    klass.send :include, InstanceMethods
  end

  module ClassMethods

    AVAILABLE_VALIDATE_TYPES = %i[presence format length type].freeze

    def validate(attribute_name, validation_type, additional_params = nil)
      raise ArgumentError, "Указан неверный тип валидации" unless AVAILABLE_VALIDATE_TYPES.include?(validation_type)

      @validations ||= []
      @validations << { attribute_name: attribute_name, validation_type: validation_type, additional_params: additional_params }
    end
  end

  module InstanceMethods
    def validate!
      class_validations.each do |validation|
        attribute_name, additional_params = validation.values_at(:attribute_name, :additional_params)

        value = send(attribute_name)
        
        case validation[:validation_type]
        when :presence
          validate_presence(attribute_name, value)
        when :format
          validate_format(attribute_name, value, additional_params)
        when :length
          validate_length(attribute_name, value, additional_params)
        when :type
          validate_type(attribute_name, value, additional_params)
        end
      end
    end

    def valid?
      validate!
      true
    rescue ValidationError
      false
    end

    private

    def class_validations
      self.class.instance_variable_get(@validations)
    end

    def validate_presence(value)
      return if !value.nil? && value != ""
      
      raise ValidationError, "Значение атрибута #{attribute_name} не должно быть пустым"
    end

    def validate_format(attribute_name, value, regexp)
      return if regexp.to_sym == NUMBER_FORMAT || NAME_FORMAT
      
      raise Validation::FormatError, "Значение аттрибута #{attribute_name} должно соответствовать формату #{regexp}"
    end

    def validate_length(attribute_name, value, length)
      return if value.to_s.length >= length
      
      raise ValidationError, "Значение атрибута #{attribute_name} должно содержать не менее #{length} символов"
    end
    
    def validate_type(attribute_name, value, klass)
      return if value.is_a?(klass)
      
      raise ValidationError, "Значение атрибута #{attribute_name} должно принадлежать классу #{klass}"
    end
  end
end
