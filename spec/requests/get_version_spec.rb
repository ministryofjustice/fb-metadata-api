RSpec.describe 'GET /services/:service_id/versions/:version_id' do
  let(:response_body) { JSON.parse(response.body) }

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
  end

  context 'when service exists' do
    let(:service) do
      create(:service,
             metadata: [first_version, latest_version])
    end
    let(:first_version) do
      build(:metadata)
    end
    let(:latest_version) do
      build(:metadata, data: {
        configuration: {
          _id: 'service',
          _type: 'config.service'
        },
        pages: []
      })
    end

    before do
      get "/services/#{service.id}/versions/#{latest_version.id}", as: :json
    end

    it 'returns success response' do
      expect(response.status).to be(200)
    end

    it 'returns metadata' do
      expect(response_body).to include({
        'configuration' => { '_id' => 'service', '_type' => 'config.service' },
        'created_by' => latest_version.created_by,
        'locale' => 'en',
        'pages' => [],
        'service_id' => service.id,
        'service_name' => service.name,
        'version_id' => latest_version.id
      })
    end
  end

  context 'when service does not exist' do
    before do
      get '/services/1234-abcdef/versions/1234', as: :json
    end

    it 'returns not found response' do
      expect(response.status).to be(404)
    end

    it 'returns not found message' do
      expect(response_body).to eq({
        'message' => ["Couldn't find Service with 'id'=\"1234-abcdef\""]
      })
    end
  end

  context 'when service exist but version does not exist' do
    let(:service) { create(:service) }

    before do
      get "/services/#{service.id}/versions/1234", as: :json
    end

    it 'returns not found response' do
      expect(response.status).to be(404)
    end

    it 'returns not found message' do
      expect(response_body).to eq({
        'message' => ["Couldn't find Metadata Version with 'id'=1234"]
      })
    end
  end
end
