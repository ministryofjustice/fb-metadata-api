RSpec.describe 'POST /services', type: :request do
  include_examples 'application authentication' do
    let(:action) do
      post '/services', params:, as: :json
    end
  end
  let(:response_body) { JSON.parse(response.body) }
  let(:service) do
    JSON.parse(
      File.read(fixtures_directory.join('service.json'))
    ).deep_symbolize_keys
  end

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
    post '/services', params:, as: :json
  end

  context 'when valid attributes' do
    let(:params) { { metadata: service } }

    it 'returns created status' do
      expect(response.status).to be(201)
    end

    it 'returns service representation' do
      expect(response_body.deep_symbolize_keys).to include(service)
    end

    it 'returns service id' do
      expect(
        Service.exists?(response_body['service_id'])
      ).to be_truthy
    end

    it 'returns version id' do
      expect(
        Metadata.exists?(response_body['version_id'])
      ).to be_truthy
    end
  end

  context 'when a locale is in the metadata' do
    let(:params) { { metadata: service.merge(locale: 'cy') } }

    it 'should set the locale correctly' do
      expect(response_body['locale']).to eq('cy')
    end
  end

  context 'when invalid attributes' do
    let(:params) { {} }

    it 'returns unprocessable entity' do
      expect(response.status).to be(422)
    end

    it 'returns error message' do
      expect(
        response_body['message']
      ).to match_array(
        ["The property '#/' did not contain a required property of 'metadata'"]
      )
    end
  end

  context 'when form name already exists' do
    let(:params) { { metadata: service } }
    before do
      post '/services', params:, as: :json
    end

    it 'returns unprocessable entity' do
      expect(response.status).to be(422)
    end

    it 'returns an error message' do
      expect(
        response_body['message']
      ).to match_array(
        ['Name has already been taken']
      )
    end
  end

  context 'when no locale is in the metadata' do
    let(:params) { { metadata: service.reject { |k, _| k == :locale } } }

    it 'returns unprocessable entity' do
      expect(response.status).to be(422)
    end

    it 'returns an error message' do
      expect(
        response_body['message']
      ).to match_array(
        ["The property '#/metadata' did not contain a required property of 'locale'"]
      )
    end
  end
end
