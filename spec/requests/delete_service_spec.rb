RSpec.describe 'Deletion Service', type: :request do
  include_examples 'application authentication' do
    let(:action) do
      delete service_path(service_id)
    end
  end

  let!(:service) do
    create(
      :service,
      id: service_id,
      name: 'Best Service',
      created_by: 'Servicer',
      metadata: [build(:metadata, created_by: 'Servicer')]
    )
  end

  let(:response_body) { JSON.parse(response.body) }
  let(:service_id) { SecureRandom.uuid }

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
  end

  describe 'GET /services' do
    it 'returns http success' do
      get '/services', as: :json
      expect(response.status).to eq(200)
      expect(Service.exists?(response_body['services'][0]['service_id'])).to be_truthy
    end
  end

  describe 'DESTROY /services/:service_id' do
    context 'when valid attributes' do
      before do
        expect(Service.exists?(service_id)).to be_truthy
        expect(Metadata.where(service_id:).exists?).to be_truthy
        delete service_path(service_id)
      end

      it 'returns OK 200 status' do
        expect(response.status).to be(200)
      end

      it 'Service cannot be found anymore' do
        expect(Service.exists?(service_id)).to be_falsey
      end

      it 'There is no metadata associated to it anymore' do
        expect(Metadata.where(service_id:).exists?).to be_falsey
      end
    end

    context 'if service does not exists anymore, attributes are invalid' do
      before do
        delete service_path(service_id)
        delete service_path(service_id)
      end

      it 'returns bad request 400 status' do
        expect(response.status).to be(400)
      end
    end
  end
end
