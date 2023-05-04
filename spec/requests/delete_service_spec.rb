RSpec.describe 'DELETE /services', type: :request do
  let(:response_body) { JSON.parse(response.body) }
  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
  end

  let(:service_metadata) do
    JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'autocomplete.json')))
  end

  context 'when service exists' do
    let(:service_id) { service_metadata['service_id'] }
    let!(:service) do
      create(
        :service,
        id: service_id
      )
    end
    let(:params) { { service_id: service_id } }
    let(:expected_message) { "Service #{service.name} has been deleted" }

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
    let(:params) { { service_id: service_id } }

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
