RSpec.describe 'GET /services/:service_id/versions' do
  let(:response_body) { JSON.parse(response.body) }

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
  end

  context 'when service exists' do
    context 'when default locale' do
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
            email_input_name_user: 'mojo'
          },
          pages: []
        })
      end

      before do
        get "/services/#{service.id}/versions", as: :json
      end

      it 'returns success response' do
        expect(response.status).to be(200)
      end

      it 'returns all versions of the service' do
        expect(response_body).to eq({
          'service_id' => service.id,
          'service_name' => service.name,
          'versions' => [
            {
              'version_id' => latest_version.id,
              'created_at' => latest_version.created_at.iso8601
            },
            {
              'version_id' => first_version.id,
              'created_at' => first_version.created_at.iso8601
            }
          ]
        })
      end
    end

    context 'when requesting locale' do
      let(:service) do
        create(:service,
               metadata: [welsh_version, english_version])
      end
      let(:welsh_version) do
        build(:metadata, data: {
          configuration: {
            pdf_heading: 'Helo Byd!'
          },
          pages: []
        }, locale: 'cy')
      end
      let(:english_version) do
        build(:metadata, data: {
          configuration: {
            email_input_name_user: 'mojo'
          },
          pages: []
        })
      end

      before do
        get "/services/#{service.id}/versions?locale=cy", as: :json
      end

      it 'returns success response' do
        expect(response.status).to be(200)
      end

      it 'returns all versions of the service' do
        expect(response_body).to eq({
          'service_id' => service.id,
          'service_name' => service.name,
          'versions' => [
            {
              'version_id' => welsh_version.id,
              'created_at' => welsh_version.created_at.iso8601
            }
          ]
        })
      end
    end
  end

  context 'when service does not exist' do
    before do
      get '/services/1234-abcdef/versions', as: :json
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
