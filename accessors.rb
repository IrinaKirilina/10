
module Accessors

  def self.included(klass)
    klass.extend ClassMethods
  end

  module ClassMethods

    def attr_accessor_with_history(*attribute_names)
      attribute_names.each do |attribute_name|
        class_eval(
          <<~"HEREDOC"
          # (1)
          attr_reader :#{attribute_name}

          # (2)
          def #{attribute}=(#{attribute})
            @#{attribute}_history ||= []
            @#{attribute}_history << #{attribute}
            @#{attribute} = #{attribute}
          end

          # (3)
          attr_reader :#{attribute_name}_history
          HEREDOC
        )
      end
    end

    def strong_attr_accessor(attribute_name, klass)
      class_eval(
        <<~"HEREDOC"
          # (1)
          attr_reader :#{attribute_name}

          # (2)
          def #{attribute}=(#{attribute})
            raise ArgumentError, "Значение должно быть класса #{klass}" unless #{attribute}.is_a?(klass)
            @#{attribute} = #{attribute}
          end
        HEREDOC
      )
    end
  end
end