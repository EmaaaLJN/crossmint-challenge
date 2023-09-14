require 'rails_helper'

describe CrossmintApi do
  subject { described_class.new }

  let(:api_url) { 'https://test-crossmint.io/api' }
  let(:api_key) { '0000-1111-2222-3333-4444' }

  # la api tiene que ser capaz de ir hacer un request a la api
  # evaluar si se realizo el request o no
  # obtener la informacion de goals
  # guardar la informacion de goals
  before do
    allow(ENV).to receive(:[]).with('API_URL').and_return(api_url)
    allow(ENV).to receive(:[]).with('API_KEY').and_return(api_key)
  end

  context "when makes a request to goals" do
    let(:url) { [api_url, 'map', api_key, 'goal'].join('/') }
    let(:stubbed_request) { mocked_goals_response_success(url) }
    let(:response) { subject.goals }

    before { stubbed_request }

    it 'has been properly requested' do
      response

      expect(stubbed_request).to have_been_requested
    end

    it 'has not empty response' do
      expect(response).to_not be_empty
    end

    it 'has a response with values for goals attribute' do
      expected_body_response = goals_body_success[:goal]

      expect(response).to match_array expected_body_response
    end
  end
end
