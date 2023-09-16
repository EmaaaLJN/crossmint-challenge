# frozen_string_literal: true

# TODO: DEAL WITH ERROR AND EXCEPTIONS
namespace :crossmint do
  desc 'this task fills the 2d matrix megaverse with polyanet gathered from api entry point goals'
  task fill_megaverse: :environment do
    crossmint_api = CrossmintApi.new

    # get information and save into database
    crossmint_api.establish_data_from_goals
    crossmint_api.establish_data_from_goals if Polyanet.count.zero?

    Coordenate.comeths.find_each do |coor|
      cometh = coor.target
      crossmint_api.add_comeths(coor.x, coor.y, cometh.direction)
    end

    Coordenate.polyanets.find_each do |coor|
      crossmint_api.add_polyanets(coor.x, coor.y)
    end
  end

  desc 'this task pretends to clean the matrix 2d megaverse'
  task clean_megaverse: :environment do
    crossmint_api = CrossmintApi.new

    Coordenate.comeths.find_each do |coor|
      crossmint_api.remove_comeths(coor.x, coor.y)
    end

    Coordenate.polyanets.find_each do |coor|
      crossmint_api.remove_polyanets(coor.x, coor.y)
    end
  end
end
