RSpec.describe 'GET /services/:service_id/versions/previous' do
  include_examples 'application authentication' do
    let(:action) do
      service = create(
        :service,
        metadata: [build(:metadata)]
      )
      get "/services/#{service.id}/versions/previous", as: :json
    end
  end
  let(:response_body) { JSON.parse(response.body) }

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
  end

  context 'when service exists' do
    let(:service) do
      create(:service,
             metadata: [previous_version, nth_version])
    end
    let(:nth_version) do
      build(:metadata)
    end
    let(:previous_version) do
      build(:metadata, data: {
                         configuration: {},
                         pages: []
                       },
                       created_at: Time.zone.now - 1.hour)
    end

    before do
      get "/services/#{service.id}/versions/previous", as: :json
    end

    context 'in the successful case' do
      it 'returns success response' do
        expect(response.status).to be(200)
      end

      it 'returns metadata' do
        expect(response_body).to include({
          'configuration' => {},
          'created_by' => previous_version.created_by,
          'locale' => 'en',
          'pages' => [],
          'service_id' => service.id,
          'service_name' => service.name,
          'version_id' => previous_version.id
        })
      end
    end
  end

  context 'when service does not exist' do
    before do
      get '/services/1234-abcdef/versions/previous', as: :json
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
end
