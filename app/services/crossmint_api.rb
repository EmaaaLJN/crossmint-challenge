# frozen_string_literal: true

class CrossmintApi
  def initialize
    @url = ENV['API_URL']
    @key = ENV['API_KEY']
  end

  # TODO: DEAL WITH ERROR AND EXCEPTIONS
  def establish_data_from_goals
    response = request_get('map', @key, 'goal')

    if response.success?
      parsed_data = parse_goals(response['goal'])

      parsed_data.each do |elem, data|
        next if elem == 'SPACE'

        insert_element_database(elem, data)
      end
    end
  end

  # TODO: DEAL WITH ERROR AND EXCEPTIONS
  def add_polyanets(row, column)
    params = { row:, column: }
    request_post('polyanets', params)
  end

  # TODO: DEAL WITH ERROR AND EXCEPTIONS
  def remove_polyanets(row, column)
    params = { row:, column: }
    request_delete('polyanets', params)
  end

  def add_comeths(row, column, direction)
    params = { row:, column:, direction: }
    request_post('comeths', params)
  end

  def remove_comeths(row, column)
    params = { row:, column: }
    request_delete('comeths', params)
  end

  def parse_goals(goals)
    result = {}

    goals.each.with_index do |rows, i|
      rows.each.with_index do |columns, j|
        if result.key? columns
          result[columns].push([i, j])
        else
          result[columns] = [[i, j]]
        end
      end
    end

    result
  end

  private

  def request_get(*path)
    HTTParty.get build_url(*path)
  end

  def request_post(path, request = {})
    request.merge!(candidateId: @key)
    HTTParty.post build_url(path), body: request
  end

  def request_delete(path, request = {})
    request.merge!(candidateId: @key)
    HTTParty.delete build_url(path), body: request
  end

  def build_url(*paths)
    [@url, *paths].join('/')
  end

  def insert_element_database(elem, data)
    elem_type = elem.split('_')

    if elem_type.size < 2
      model = constantize_model elem_type.first

      create_record(model, data)
    else
      specific_attribute, model_name = elem_type
      model = constantize_model model_name
      attributes = attributes_by_element_type(model_name, specific_attribute)

      create_record(model, data, attributes)
    end
  end

  def create_record(model, coords, attributes = {})
    coords.each do |(x, y)|
      model_record = model.create(attributes)
      create_coordenate(model_record, x, y)
    end
  end

  def create_coordenate(model_record, coord_x, coord_y)
    if (coor = model_record.create_coordenate(x: coord_x, y: coord_y))
      Rails.logger.info "#{model_record.class.name} created with coordenate: x:#{coor.x}, y: #{coor.y}"
    else
      Rails.logger.warn "unabled to create #{model_record.class.name}"
    end
  end

  def constantize_model(model)
    model.downcase.upcase_first.constantize
  end

  def attributes_by_element_type(model_name, attribute)
    attributes = {}
    attributes.merge!({ direction: attribute.downcase.to_sym }) if model_name.downcase == 'cometh'
  end
end
