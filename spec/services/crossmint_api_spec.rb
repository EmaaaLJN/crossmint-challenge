# frozen_string_literal: true

require 'rails_helper'

describe CrossmintApi do
  subject { described_class.new }

  let(:api_url) { 'https://test-crossmint.io/api' }
  let(:api_key) { '0000-1111-2222-3333-4444' }

  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with('API_URL').and_return(api_url)
    allow(ENV).to receive(:[]).with('API_KEY').and_return(api_key)
  end

  shared_examples_for 'requesting to api' do
    before { stubbed_request }

    it 'has been properly requested' do
      hydra.queue(request)
      hydra.run
      expect(stubbed_request).to have_been_requested
    end

    it 'responds with success' do
      expect(request.run.code).to be 200
    end
  end

  shared_examples_for 'a failed response' do
    let(:stubbed_request) { post_response_failed(url) }

    before { stubbed_request }

    it 'responds with 400 error' do
      code = nil
      Typhoeus.on_complete { |c| code = c.code }
      hydra.queue request
      hydra.run

      expect(code).to eq 400
    end
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
      let(:soloon_ocurrences) { 28 }

      it 'is polyanet' do
        expect { response }.to change(Polyanet, :count).from(0).to(polyanet_ocurrences)
      end

      it 'is a cometh' do
        expect { response }.to change(Cometh, :count).from(0).to(cometh_ocurrences)
      end

      it 'is a soloon' do
        expect { response }.to change(Soloon, :count).from(0).to(soloon_ocurrences)
      end
    end
  end

  context 'when making a request to polyanets' do
    let(:url) { [api_url, 'polyanets'].join('/') }
    let(:params) { { row: 2, column: 2, candidateId: api_key } }
    let(:hydra) { Typhoeus::Hydra.new }

    before { Typhoeus::Expectation.clear }

    context 'when requesting is add a polyanets' do
      let(:stubbed_request) { post_response_success(url) }
      let(:request) { subject.add_polyanets(2, 2) }

      it_behaves_like 'requesting to api'
    end

    context 'when requesting is delete a polyanets' do
      let(:stubbed_request) { delete_response_success(url) }
      let(:request) { subject.remove_polyanets(2, 2) }

      it_behaves_like 'requesting to api'
    end
  end

  context 'when making a request to soloons' do
    let(:url) { [api_url, 'soloons'].join('/') }
    let(:params) { { row: 2, column: 2, color: 'white', candidateId: api_key } }
    let(:hydra) { Typhoeus::Hydra.new }

    before { Typhoeus::Expectation.clear }

    context 'when requesting is add a soloons' do
      let(:stubbed_request) { post_response_success(url) }
      let(:request) { subject.add_soloons(2, 2, 'red') }

      it_behaves_like 'requesting to api'
    end

    context 'when requesting is add a soloons' do
      let(:stubbed_request) { delete_response_success(url) }
      let(:request) { subject.remove_soloons(2, 2) }

      it_behaves_like 'requesting to api'
    end

    context 'when requesting fails' do
      let(:request) { subject.add_soloons(2, '', 'red') }

      it_behaves_like 'a failed response'
    end
  end

  context 'when making a request to comeths' do
    let(:url) { [api_url, 'comeths'].join('/') }
    let(:params) { { row: 2, column: 2, direction: 'up', candidateId: api_key } }
    let(:hydra) { Typhoeus::Hydra.new }

    before { Typhoeus::Expectation.clear }

    context 'when requesting is add a comeths' do
      let(:stubbed_request) { post_response_success(url) }
      let(:request) { subject.add_comeths(2, 2, 'up') }

      it_behaves_like 'requesting to api'
    end

    context 'when requesting is add a comeths' do
      let(:stubbed_request) { delete_response_success(url) }
      let(:request) { subject.remove_comeths(2, 2) }

      it_behaves_like 'requesting to api'
    end

    context 'when requesting fails' do
      let(:request) { subject.add_comeths(2, '', 'up') }

      it_behaves_like 'a failed response'
    end
  end
end
