# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  attr_reader :instances

  module ClassMethods
    def instances_count
      @instances ||= 0
      @instances += 1
    end

    def instances
      @instances ||= 0
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances_count
    end
  end
end
