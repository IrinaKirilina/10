# frozen_string_literal: true
require "./station"
require "./route"
require "./passenger_train"
require "./cargo_train"
require "./train"
require "./car"
require "./cargo_car"
require "./passenger_car"

class RailRoad
  attr_accessor :stations, :route, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  def manage_rail_road
    puts 'Создание железной дороги'
    loop do
      puts '------------------'
      puts 'Выберите действие:'
      puts ACTIONS
      action = gets.chomp.to_i
      case action
      when 0
        break
      when 1
        puts 'Выберите действие со станциями:'
        puts STATIONS_ACTIONS
        station_action = gets.chomp.to_i
        case station_action
        when 1
          list_stations
        when 2
          manage_station
        when 3
          list_station_trains
        end
      when 2
        puts 'Выберите действие с маршрутами:'
        puts ROUTES_ACTIONS
        route_action = gets.chomp.to_i
        case route_action
        when 1
          list_routes
        when 2
          manage_route
        when 3
          show_route
        when 4
          add_station_to_route
        when 5
          delete_station
        when 6
          forward_move
        when 7
          backward_move
        end
      when 3
        puts 'Выберите действие с поездами:'
        puts TRAINS_ACTIONS
        train_action = gets.chomp.to_i
        case train_action
        when 1
          list_trains
        when 2
          manage_train
        when 3
          assign_route_to_train
        when 4
          car_add
        when 5
          car_remove
        when 6
          reserve_car_capacity
        when 7
          list_train_cars
        end
      end
    end
  end

  private

  ACTIONS = [
    '1 - станции',
    '2 - маршруты',
    '3 - поезда',
    '0 - выход'
  ].freeze

  STATIONS_ACTIONS = [
    '1 - показать список станции',
    '2 - создать станцию',
    '3 - показать список поездов на станции',
    '(любой другой номер) - отмена'
  ].freeze

  ROUTES_ACTIONS = [
    '1 - показать список маршрутов',
    '2 - создать маршрут',
    '3 - показать маршрут',
    '4 - добавить станцию в маршрут',
    '5 - удалить станцию из маршрута',
    '6 - переместить поезд по маршруту вперед',
    '7 - переместить поезд по маршруту назад',
    '(любой другой номер) - отмена'
  ].freeze

  TRAINS_ACTIONS = [
    '1 - показать список поездов',
    '2 - создать поезд',
    '3 - назначать маршрут поезду',
    '4 - добавлять вагоны к поезду',
    '5 - отцеплять вагоны от поезда',
    '6 - занять место в вагоне',
    '7 - показать список вагонов у поезда',
    '(любой другой номер) - отмена'
  ].freeze

  def list_stations
    @stations.each.with_index do |station, index|
      puts "Cписок станций: #{index} #{station.name}"
    end
  end

  def list_routes
    @routes.each.with_index do |route, index|
      puts "#{index}: Маршрут #{route.name}"
    end
  end

  def list_trains
    @trains.each.with_index do |train, index|
      puts "#{index}: Поезд #{train.number}, #{train.type}"
    end
  end

  def find_station(name)
    @stations.find { |station| station.name == name }
  end

  def create_station(name)
    new_station = Station.new(name)
    @stations << new_station
    new_station
  end

  def add_station(name)
    station = find_station(name)
    return station if station

    create_station(name)
  end

  def manage_station
    puts 'Добавление станции:'
    print 'Введите название станции: '
    station_name = gets.chomp
    if station_name
      add_station(station_name)
      puts 'Станция добавлена'
    else
      puts 'Необходимо указать название станции'
    end
  end

  def find_route(name)
    @routes.find { |route| route.name == name }
  end

  def create_route(name, first_station, last_station)
    route = Route.new(name, first_station, last_station)
    @routes << route
    route
  end

  def add_route(name, first_station, last_station)
    route = find_route(name)
    return route if route

    create_route(name, first_station, last_station)
  end

  def manage_route
    puts 'Добавление маршрута: '
    print 'Введите название маршрута: '
    route_name = gets.chomp
    print 'Введите название начальной станции: '
    station_first_name = gets.chomp
    print 'Введите название конечной станции: '
    station_last_name = gets.chomp
    if route_name && station_first_name && station_last_name
      station_first = add_station(station_first_name)
      station_last = add_station(station_last_name)
      add_route(route_name, station_first_name, station_last_name)
      puts 'Маршрут добавлен'
    else
      puts 'Необходимо указать все названия'
    end
  end

  def add_station_to_route
    puts 'Добавление станции в маршрут:'
    print 'Введите название маршрута в который нужно добавить станцию: '
    route_name = gets.chomp
    print 'Введите название станции которую нужно добавить: '
    new_station = gets.chomp
    if route_name
      route = find_route(route_name)
      if route
        route.add_station(new_station)
      else
        puts "Маршрут '#{route_name}' не найден"
      end
    else
      puts 'Необходимо ввести название маршрута'
    end
  end

  def show_route
    puts 'Отображение маршрута:'
    print 'Введите название маршрута: '
    route_name = gets.chomp
    if route_name
      route = find_route(route_name)
      if route
        route.stations.each.with_index(1) do |station, index|
          puts "#{index}. #{station}"
        end
      else
        puts "Маршрут '#{route_name}' не найден"
      end
    else
      puts 'Необходимо ввести название маршрута'
    end
  end

  def delete_station
    puts 'Удаление станции из маршрута:'
    print 'Введите название маршрута из которого необходимо удалить станцию: '
    route_name = gets.chomp
    print 'Введите название станции, которую нужно удалить: '
    station_name = gets.chomp
    if route_name
      route = find_route(route_name)
      if route
        route.delete_station(station_name)
        puts "Станция #{station_name} удалена из маршрута"
      else
        puts 'Необходимо ввести название маршрута из которого необходимо удалить станцию'
      end
    else
      puts "Маршрут '#{route_name}' не найден"
    end
  end

  def forward_move
    puts 'Перемещение поезда по маршруту вперед:'
    print 'Для перемещения вперед введите Forward: '
    forward = gets.chomp
    if forward
      move_forward
      puts 'Перемещение вперед'
    else
      'Для движения вперед необходимо ввести Forward'
    end
  end

  def backward_move
    puts 'Перемещение поезда по маршруту назад'
    print 'Для перемещения поезда назад введите Backward: '
    backward = gets.chomp
    if backward
      move_backward
      puts 'Перемещение назад'
    else
      puts 'Для перемещения назад необходимо ввести Backward'
    end
  end

  def find_train(train_number, train_type)
    @trains.find { |train| train.number == train_number && train.type.to_sym == train_type }
  end

  def create_train(train_number, train_type)
    train =
      if train_type.to_sym == :cargo
        CargoTrain.new(train_number)
      else
        PassengerTrain.new(train_number)
      end
    @trains << train
    train
  end

  def add_train(train_number, train_type)
    train = find_train(train_number, train_type)
    return train if train

    # Если введенные данные невалидные, то программа должна вывести сообщение о возникших ошибках и заново запросить данные у пользователя. Реализовать это через механизм обработки исключений
    begin
      create_train(train_number, train_type)
    rescue StandardError => e
      puts 'Ошибка при создании поезда: '
      puts e.message
    end
  end

  def manage_train
    puts 'Добавление поезда:'
    print 'Введите номер поезда: '
    train_number = gets.chomp
    print 'Введите тип поезда (грузовой или пассажирский): '
    train_type = gets.chomp.to_sym
    add_train(train_number, train_type)
    puts "Создан поезд: #{train_number}, #{train_type}"
  end

  def assign_route_to_train
    puts 'Назначение маршрута поезду: '
    print 'Введите номер поезда, которому нужно назначить маршрут: '
    train_number = gets.chomp
    print 'Введите тип поезда, которому нужно назначить маршрут: '
    train_type = gets.chomp.to_sym
    if train_number && train_type
      train = find_train(train_number, train_type)
      if train
        print 'Введите название маршрута: '
        route_name = gets.chomp
        if route_name
          route = find_route(route_name)
          if route
            train.assign_route(route_name)
            puts "Поезду #{train_number} #{train_type} назначен маршрут #{route_name}"
          else
            puts "Маршрут #{route_name} не найден"
          end
        else
          puts 'Необходимо ввести название маршрута'
        end
      else
        puts "Поезд #{train_number} #{train_type} не найден"
      end
    else
      puts 'Необходимо ввести номер и тип поезда'
    end
  end

  def car_add
    puts 'Добавление вагона к поезду: '
    print 'Введите номер поезда, к которому нужно добавить вагон: '
    train_number = gets.chomp
    print 'Введите тип поезда, к которому нужно добавить вагон - cargo/passenger: '
    train_type = gets.chomp.to_sym
    if train_number && train_type
      train = find_train(train_number, train_type)
      if train
        print 'Введите тип вагона - cargo/passenger: '
        car_type = gets.chomp.to_sym
        print 'Введите номер вагона: '
        car_number = gets.chomp
        print 'Введите вместимость вагона: '
        capacity = gets.chomp
        if car_type
          car = if car_type == :cargo
                  CargoCar.new(car_number, capacity)
                else
                  PassengerCar.new(car_number, capacity)
                end
          train.add_car(car)
          puts 'Вагон добавлен'
        else
          puts 'Необходимо ввести тип вагона'
        end
      else
        puts "Поезд #{train_number} #{train_type} не найден"
      end
    else
      'Необходимо ввести номери и тип поезда'
    end
  end

  def car_remove
    puts 'Отцепление вагона от поезда:'
    print 'Введите номер поезда, от которого нужно отцепить вагон: '
    train_number = gets.chomp
    print 'Введите тип поезда, от которого нужно отцепить вагон: '
    train_type = gets.chomp.to_sym
    if train_number && train_type
      train = find_train(train_number, train_type)
      if train
        train.remove_car(car)
        puts 'Вагон отцеплен'
      else
        puts 'Поезд не найден'
      end
    else
      puts 'Необходимо ввести номер и тип поезда'
    end
  end

  def list_train_cars
    print 'Введите номер поезда: '
    train_number = gets.chomp
    print 'Введите тип поезда: '
    train_type = gets.chomp.to_sym
    if train_number && train_type
      train = find_train(train_number, train_type)
      train&.each_car do |car|
        puts "Вагон №#{car.number} #{car.type}, количество свободных мест: #{train.cars.count}"
      end
    end
  end

  def list_station_trains
    print 'Введите название станциии: '
    station_name = gets.chomp
    station = find_station(station_name)
    if station
      station.each_train do |train|
        puts "Поезд №#{train.number} #{train.type}, количество свободных вагонов: #{car.free_capacity.lengh}"
      end
    else
      print 'Поезд не найден'
    end
  end

  def reserve_car_capacity
    print 'Введите номер поезда: '
    train_number = gets.chomp
    print 'Введите тип поезда: '
    train_type = gets.chomp.to_sym
    if train_number && train_type
      train = find_train(train_number, train_type)
      if train
        print 'Введите номер вагона чтобы занять место: '
        car_number = gets.chomp
        if car_number
          car = train.find_car(car_number)
          if car
            print 'Введите количество чтобы занять место в вагоне: '
            volume = gets.chomp.to_i
            if volume
              reserved_capacity = car.reserve_capacity(volume)
              puts 'Место забронировано'
            else
              print 'Необходимо ввести количество'
            end
          else
            'Вагон не найден'
          end
        else
          print 'Небходимо ввести номер вагона'
        end
      else
        print 'Поезд не найден'
      end
    else
      print 'Необходимо ввести номер и тип поезда'
    end
  end
end
