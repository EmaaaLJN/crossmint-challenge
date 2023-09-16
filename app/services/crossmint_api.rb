# frozen_string_literal: true

class CrossmintApi
  def initialize
    @url = ENV['API_URL']
    @key = ENV['API_KEY']
  end

  # TODO: DEAL WITH ERROR AND EXCEPTIONS
  def establish_data_from_goals
    request = request_get('map', @key, 'goal')

    # CHANGE THIS BECAUSE IM DOING DRY
    request.on_complete do |response|
      if response.success?
        response_body = JSON.parse response.body
        parsed_data = parse_goals(response_body['goal'])

        parsed_data.each do |elem, data|
          next if elem == 'SPACE'

          insert_element_database(elem, data)
        end

      elsif response.timed_out?
        Rails.logger.error 'Request got timed out'
      elsif response.code.zero?
        Rails.logger.error response.return_message.to_s
      else
        Rails.logger.error "HTTP request failed: #{response.code}."
      end
    end

    request.run
  end

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
    dynamic_path = path.join('/')
    build_request(:get, dynamic_path)
  end

  def request_post(path, params = {})
    params.merge!(candidateId: @key)
    build_request(:post, path, params)
  end

  def request_delete(path, params = {})
    params.merge!(candidateId: @key)
    build_request(:delete, path, params)
  end

  def build_request(method, path, params = {})
    headers = { 'content-type': 'application/json' }
    Typhoeus::Request.new(build_url(path), method:, followlocation: true, headers:, body: params.to_json)
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
