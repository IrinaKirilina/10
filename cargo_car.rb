# frozen_string_literal: true

require './car'

class CargoCar < Car
  attr_accessor :type

  def type
    :cargo
  end
end
