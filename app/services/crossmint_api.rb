class CrossmintApi
  def initialize
    @url = ENV['API_URL']
    @key = ENV['API_KEY']
  end

  def goals
    response = request_get 'goal'
    # TODO: por ahora solo esto.
    response['goal']
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
  def request_get(path)
    HTTParty.get build_url(path)
  end

  def request_post(path)
    HTTParty.post build_url(path)
  end

  def build_url(path = '')
    # por las dudas uso map
    [@url, 'map', @key, path].join('/')
  end
end
