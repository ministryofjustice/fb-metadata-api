RSpec.describe 'DELETE /services', type: :request do
  let(:response_body) { JSON.parse(response.body) }
  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
  end

  let(:service_metadata) do
    JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'autocomplete.json')))
  end
  let(:params) { { service_id: } }
  let(:expected_message) { "Service #{service.name} has been deleted" }

  context 'when PLATFORM_ENV is test' do
    before do
      allow(ENV).to receive(:[])
      allow(ENV).to receive(:[]).with('PLATFORM_ENV').and_return('test')
    end

    context 'when service exists' do
      let(:service_id) { service_metadata['service_id'] }
      let!(:service) do
        create(
          :service,
          id: service_id
        )
      end

      before do
        delete "/services/#{service_id}", params:, as: :json
      end

      it 'returns success status' do
        expect(response.status).to be(200)
      end

      it 'returns correct message' do
        expect(response.body).to include(expected_message)
      end
    end

    context 'when service does not exist' do
      let(:service_id) { SecureRandom.uuid }

      before do
        delete "/services/#{service_id}", params:, as: :json
      end

      it 'returns not found response' do
        expect(response.status).to be(404)
      end

      it 'returns error message' do
        expect(
          response_body['message']
        ).to match_array(
          ["Couldn't find Service with 'id'=#{service_id}"]
        )
      end
    end
  end

  context 'when PLATFORM_ENV is live' do
    let(:service_id) { service_metadata['service_id'] }
    let!(:service) do
      create(
        :service,
        id: service_id
      )
    end

    before do
      allow(ENV).to receive(:[])
      allow(ENV).to receive(:[]).with('PLATFORM_ENV').and_return('live')

      delete "/services/#{service_id}", params:, as: :json
    end

    it 'returns forbidden' do
      expect(response.status).to eq(200)
    end

    it 'returns error message' do
      expect(response.body).to include(expected_message)
    end
  end
end
