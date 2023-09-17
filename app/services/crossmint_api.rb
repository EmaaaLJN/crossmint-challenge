# frozen_string_literal: true

class CrossmintApi
  def initialize
    @url = ENV['API_URL']
    @key = ENV['API_KEY']
    @rate_queue = Limiter::RateQueue.new(5, interval: 9)
    @hydra = Typhoeus::Hydra.new(max_concurrency: 1)
  end

  def establish_data_from_goals
    request = request_get('map', @key, 'goal') do |response|
      response_body = JSON.parse response.body
      parsed_data = parse_goals(response_body['goal'])

      parsed_data.each do |elem, data|
        next if elem == 'SPACE'

        insert_element_database(elem, data)
      end
    end

    request.run
  end

  def action_collection_to_api(action, collection)
    collection.find_each do |coor|
      args = [coor.x, coor.y]

      entity_obj = coor.target

      args.push(entity_obj.direction) if action.to_s == 'add_comeths'
      args.push(entity_obj.color) if action.to_s == 'add_soloons'

      request = send(action, *args) do
        @rate_queue.shift
      end
      @hydra.queue(request)
    end
  end

  def run_requests
    @hydra.run
  end

  def add_polyanets(row, column, &block)
    params = { row:, column: }
    request_post('polyanets', params, &block)
  end

  def remove_polyanets(row, column, &block)
    params = { row:, column: }
    request_delete('polyanets', params, &block)
  end

  def add_comeths(row, column, direction, &block)
    params = { row:, column:, direction: }
    request_post('comeths', params, &block)
  end

  def remove_comeths(row, column, &block)
    params = { row:, column: }
    request_delete('comeths', params, &block)
  end

  def add_soloons(row, column, color, &block)
    params = { row:, column:, color: }
    request_post('soloons', params, &block)
  end

  def remove_soloons(row, column, &block)
    params = { row:, column: }
    request_delete('soloons', params, &block)
  end

  private

  def parse_goals(goals)
    result = {}

    goals.each.with_index do |rows, i|
      rows.each.with_index do |columns, j|
        result.key?(columns) ? result[columns].push([i, j]) : result[columns] = [[i, j]]
      end
    end

    result
  end

  def request_get(*path, &block)
    dynamic_path = path.join('/')
    build_request(:get, dynamic_path, &block)
  end

  def request_post(path, params = {}, &block)
    params.merge!(candidateId: @key)
    build_request(:post, path, params, &block)
  end

  def request_delete(path, params = {}, &block)
    params.merge!(candidateId: @key)
    build_request(:delete, path, params, &block)
  end

  def build_request(method, path, params = {}, &block)
    headers = { 'content-type': 'application/json' }
    request = Typhoeus::Request.new(build_url(path), method:, followlocation: true, headers:, body: params.to_json)

    request.on_complete do |response|
      request_handler(response, block)
    end
    request
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
    attributes.merge!({ color: attribute.downcase.to_sym }) if model_name.downcase == 'soloon'

    attributes
  end

  def request_handler(response, block)
    if block.nil?
      response_logger response, logger_success
    else
      block_content = block.arity == 1 ? block.call(response) : block.call
      response_logger response, block_content
    end
  end

  def response_logger(response, body)
    if response.success?
      body
    elsif response.timed_out?
      logger_timed_out
    elsif response.code.zero?
      logger_code_zero response
    else
      logger_error_code response
    end
  end

  def logger_success
    Rails.logger.info 'Request Success!'
  end

  def logger_timed_out
    Rails.logger.error 'Request got timed out'
  end

  def logger_code_zero(response)
    Rails.logger.error response.return_message.to_s
  end

  def logger_error_code(response)
    Rails.logger.error "HTTP request failed: #{response.code}."
  end
end
