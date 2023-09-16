# frozen_string_literal: true

namespace :crossmint do
  desc 'this task fills the 2d matrix megaverse with polyanet gathered from api entry point goals'
  task fill_megaverse: :environment do
    crossmint_api = CrossmintApi.new

    # set data into database
    crossmint_api.establish_data_from_goals

    rate_queue = Limiter::RateQueue.new(5, interval: 9)
    hydra = Typhoeus::Hydra.new(max_concurrency: 1)

    # send polyanets to api
    Coordenate.polyanets.find_each do |coor|
      request = crossmint_api.add_polyanets(coor.x, coor.y) do
        rate_queue.shift
      end
      hydra.queue(request)
    end

    # send comeths to api
    Coordenate.comeths.find_each do |coor|
      cometh = coor.target
      request = crossmint_api.add_comeths(coor.x, coor.y, cometh.direction) do
        rate_queue.shift
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
      request = crossmint_api.remove_polyanets(coor.x, coor.y) do
        rate_queue.shift
      end
      hydra.queue(request)
    end
    hydra.run
  end
end
