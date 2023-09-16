# frozen_string_literal: true

# TODO: DEAL WITH ERROR AND EXCEPTIONS
namespace :crossmint do
  desc 'this task fills the 2d matrix megaverse with polyanet gathered from api entry point goals'
  task fill_megaverse: :environment do
    crossmint_api = CrossmintApi.new

    crossmint_api.establish_data_from_goals

    #ESTO LO TENGO QUE CAMBIAR, ES UNA LOGICA MUY DE SCOPE

    rate_queue = Limiter::RateQueue.new(5, interval: 9)
    hydra = Typhoeus::Hydra.new(max_concurrency: 1)

    Coordenate.polyanets.find_each do |coor|
      request = crossmint_api.add_polyanets(coor.x, coor.y) do
        rate_queue.shift
      end

      request.on_complete do |response|
        if response.success?
          rate_queue.shift
        elsif response.timed_out?
          Rails.logger.error 'Request got timed out'
        elsif response.code.zero?
          Rails.logger.error response.return_message.to_s
        else
          Rails.logger.error "HTTP request failed: #{response.code}."
        end
      end

      hydra.queue(request)
    end
    hydra.run
  end

  desc 'this task pretends to clean the matrix 2d megaverse'
  task clean_megaverse: :environment do
    crossmint_api = CrossmintApi.new

    rate_queue = Limiter::RateQueue.new(5, interval: 9)
    hydra = Typhoeus::Hydra.new(max_concurrency: 1)

    Coordenate.polyanets.find_each do |coor|
      request = crossmint_api.remove_polyanets(coor.x, coor.y)

      request.on_complete do |response|
        if response.success?
          rate_queue.shift
        elsif response.timed_out?
          Rails.logger.error 'Request got timed out'
        elsif response.code.zero?
          Rails.logger.error response.return_message.to_s
        else
          Rails.logger.error "HTTP request failed: #{response.code}."
        end
      end
      hydra.queue(request)
    end
    hydra.run
  end
end
