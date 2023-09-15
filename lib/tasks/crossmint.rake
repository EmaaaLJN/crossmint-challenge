# frozen_string_literal: true

# TODO: DEAL WITH ERROR AND EXCEPTIONS
namespace :crossmint do
  desc 'this task fills the 2d matrix megaverse with polyanet gathered from api entry point goals'
  task fill_megaverse: :environment do
    crossmint_api = CrossmintApi.new

    # get information and save into database
    crossmint_api.establish_data_from_goals if Polyanet.count.zero?

    # set polyanet to megaverse matrix
    Coordenate.includes(target: [:polyanet]).find_each do |coor|
      crossmint_api.add_polyanets(coor.x, coor.y)
    end
  end
end
