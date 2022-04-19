# frozen_string_literal: true

require './instance_counter'
require './validation'

class Station
  include InstanceCounter
  include Validation

  attr_accessor :name
  attr_reader :trains

  NAME_FORMATE = /^[a-zа-я]{3}/i.freeze

  @@all = []

  validate :name, :presence
  validate :name, :length, 3
  validate :name, :format, NAME_FORMATE
  
  def initialize(name)
    @name = name
    @trains = []
    @@all << self

    register_instance
  end

  def arrival(train)
    @trains << train
  end

  def departure(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def self.all
    @@all
  end

  def each_train(&block)
    @trains.each(&block) if block_given?
  end
end

