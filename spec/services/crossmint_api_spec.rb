# frozen_string_literal: true

require 'rails_helper'

describe CrossmintApi do
  subject { described_class.new }

  let(:api_url) { 'https://test-crossmint.io/api' }
  let(:api_key) { '0000-1111-2222-3333-4444' }

  before do
    allow(ENV).to receive(:[]).with('API_URL').and_return(api_url)
    allow(ENV).to receive(:[]).with('API_KEY').and_return(api_key)
  end

  context 'when making a request to goals' do
    let(:url) { [api_url, 'map', api_key, 'goal'].join('/') }
    let(:stubbed_request) { mocked_goals_response_success(url) }
    let(:response) { subject.establish_data_from_goals }

    before { stubbed_request }

    it 'has been properly requested' do
      response

      expect(stubbed_request).to have_been_requested
    end

    context 'when inserting element into database' do
      let(:polyanet_ocurrences) { 113 }
      let(:cometh_ocurrences) { 25 }

      it 'is polyanet' do
        expect { response }.to change(Polyanet, :count).from(0).to(polyanet_ocurrences)
      end

      it 'is a cometh' do
        expect { response }.to change(Cometh, :count).from(0).to(cometh_ocurrences)
      end
    end
  end

  # TODO: faltan los casos donde el api devuelve un resultado invalido
  context 'when making a request to polyanets' do
    let(:url) { [api_url, 'polyanets'].join('/') }
    let(:params) { { row: 2, column: 2, candidateId: api_key } }

    context 'when requesting is add a polyanets' do
      let(:stubbed_request) { post_response_success(url) }

      let(:request) { subject.add_polyanets(2, 2) }

      before { stubbed_request }

      it 'has been properly requested' do
        request

        expect(stubbed_request).to have_been_requested
      end

      it 'responds with success' do
        expect(request.code).to be 200
      end
    end

    context 'when requesting is delete a polyanets' do
      let(:stubbed_request) { mocked_delete_polyanets_response_success(url) }

      let(:request) { subject.remove_polyanets(2, 2) }

      before { stubbed_request }

      it 'has been properly requested' do
        request

        expect(stubbed_request).to have_been_requested
      end

      it 'responds with success' do
        expect(request.code).to be 200
      end
    end
  end
end
