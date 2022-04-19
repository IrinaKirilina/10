# frozen_string_literal: true

require './manufacturer'

class Car
  include Manufacturer

  attr_accessor :type, :number, :capacity, :reserved_capacity

  def initialize(number, capacity)
    @capacity = capacity
    @reserved_capacity = 0
    @number = number
  end

  def reserve_capacity(volume)
    @reserved_capacity += 1 if volume.positive?
  end

  def free_capacity
    capacity - reserved_capacity if capacity.positive?
  end

  attr_reader :reserved_capacity
end
