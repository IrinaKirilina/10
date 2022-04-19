require './instance_counter'
require './station'
require './validation'

class Route
  include InstanceCounter
  include Validation
  
  attr_reader :stations, :name

  NAME_FORMAT = /^[a-zа-я\d]{3}/i.freeze

  validate :name, :presence
  validate :name, :length, 3
  validate :name, :format, NAME_FORMAT

  def initialize(name, first_station, last_station)
    @stations = [first_station, last_station]
    @name = name

    register_instance
  end

  def add_station(station)
    stations.insert(-2, station)
  end

  def delete_station(station)
    stations.delete(station)
  end
end
