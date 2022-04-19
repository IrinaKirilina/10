# frozen_string_literal: true

require './train'

class CargoTrain < Train
  def initialize(number)
    @type = :cargo
    super
  end
end
