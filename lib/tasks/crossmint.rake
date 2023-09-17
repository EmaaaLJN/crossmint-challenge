# frozen_string_literal: true

namespace :crossmint do
  desc 'this task fills the 2d matrix megaverse with polyanet gathered from api entry point goals'
  task fill_megaverse: :environment do
    crossmint_api = CrossmintApi.new

    # set data into database
    crossmint_api.establish_data_from_goals

    # send polyanets to api
    crossmint_api.action_collection_to_api :add_polyanets, Coordenate.polyanets

    # send comeths to api
    crossmint_api.action_collection_to_api :add_comeths, Coordenate.comeths

    # send soloons to api
    crossmint_api.action_collection_to_api :add_soloons, Coordenate.soloons

    # execute enqueued request
    crossmint_api.run_requests
  end

  desc 'this task cleans the matrix 2d megaverse from api. NOTE: this command does not remove records from database.'
  task clean_megaverse: :environment do
    crossmint_api = CrossmintApi.new

    # remove polyanets from api
    crossmint_api.action_collection_to_api :remove_polyanets, Coordenate.polyanets

    # remove comeths from api
    crossmint_api.action_collection_to_api :remove_comeths, Coordenate.comeths

    # remove soloons from api
    crossmint_api.action_collection_to_api :remove_soloons, Coordenate.soloons

    # execute enqueued request
    crossmint_api.run_requests
  end
end
