RSpec.describe 'GET /services/:service_id/versions/latest' do
  include_examples 'application authentication' do
    let(:action) do
      service = create(
        :service,
        metadata: [build(:metadata)]
      )

      get "/services/#{service.id}/versions/latest", as: :json
    end
  end
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
        get "/services/#{service.id}/versions/latest", as: :json
      end

      it 'returns success response' do
        expect(response.status).to be(200)
      end

      it 'returns metadata' do
        expect(response_body).to include({
          'configuration' => { 'email_input_name_user' => 'mojo' },
          'created_by' => latest_version.created_by,
          'locale' => 'en',
          'pages' => [],
          'service_id' => service.id,
          'service_name' => service.name,
          'version_id' => latest_version.id
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
        get "/services/#{service.id}/versions/latest?locale=cy", as: :json
      end

      it 'returns success response' do
        expect(response.status).to be(200)
      end

      it 'returns the welsh version' do
        expect(response_body).to include({
          'configuration' => { 'pdf_heading' => 'Helo Byd!' },
          'created_by' => welsh_version.created_by,
          'locale' => 'cy',
          'pages' => [],
          'service_id' => service.id,
          'service_name' => service.name,
          'version_id' => welsh_version.id
        })
      end
    end
  end

  context 'when service does not exist' do
    before do
      get '/services/1234-abcdef/versions/latest', as: :json
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
