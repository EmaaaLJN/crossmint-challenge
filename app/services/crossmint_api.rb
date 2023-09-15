# frozen_string_literal: true

class CrossmintApi
  def initialize
    @url = ENV['API_URL']
    @key = ENV['API_KEY']
  end

  def goals
    response = request_get('map', @key, 'goal')
    # TODO: por ahora solo esto.
    response['goal']
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
end
