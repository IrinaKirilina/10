# frozen_string_literal: true

require './car'

class PassengerCar < Car
  attr_accessor

  def type
    :passenger
  end
end
