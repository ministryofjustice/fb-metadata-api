RSpec.describe 'POST /services/published_metadata' do
  let(:response_body) { JSON.parse(response.body) }
  let!(:service_one) do
    create(
      :service,
      name: 'Service 1',
      created_by: 'greedo',
      metadata: [build(:metadata, created_by: 'greedo')],
      questionnaire: build(:questionnaire, :experiment)
    )
  end
  let!(:service_two) do
    create(
      :service,
      name: 'Service 2',
      created_by: 'han',
      metadata: [build(:metadata, created_by: 'han')],
      items: build_list(:items, 2)
    )
  end
  let!(:service_three) do
    create(
      :service,
      name: 'Ze Numero 3',
      created_by: 'greedo',
      metadata: [build(:metadata, created_by: 'greedo')],
      questionnaire: build(:questionnaire, :building)
    )
  end

  let(:params) do
    {
      services: {
        service_one.id => { versions: [service_one.metadata[0].id] },
        service_two.id => { versions: [service_two.metadata[0].id] },
        service_three.id => { versions: [service_three.metadata[0].id] }
      }
    }
  end

  context 'when paginating' do
    let(:per_page) { 1 }

    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
      post "/services/published_metadata?page=#{page}&per_page=#{per_page}", params:, as: :json
    end

    context 'when requesting first page' do
      let(:page) { 1 }

      it 'returns success response' do
        expect(response.status).to eq(200)
      end

      it 'returns the total services' do
        expect(response_body['total_services']).to be(3)
      end

      it 'returns the number of services in the per page param' do
        expect(response_body['services']).to match_array(
          [
            {
              'service_name' => service_one.name,
              'service_id' => service_one.id,
              'service_created_by' => service_one.created_by,
              'service_created_at' => instance_of(String),
              'service_updated_at' => instance_of(String),
              'items' => [],
              'metadata' => instance_of(Array)
            }
          ]
        )
      end
    end

    context 'when requesting second page' do
      let(:page) { 2 }

      it 'returns success response' do
        expect(response.status).to eq(200)
      end

      it 'returns the total services' do
        expect(response_body['total_services']).to be(3)
      end

      it 'returns the number of services in the per page param' do
        expect(response_body['services']).to match_array(
          [
            {
              'service_name' => service_two.name,
              'service_id' => service_two.id,
              'service_created_by' => service_two.created_by,
              'service_created_at' => instance_of(String),
              'service_updated_at' => instance_of(String),
              'items' => [instance_of(Hash), instance_of(Hash)],
              'metadata' => instance_of(Array)
            }
          ]
        )
      end
    end

    context 'when requesting first page and per page is 100' do
      let(:page) { 1 }
      let(:per_page) { 100 }

      it 'returns success response' do
        expect(response.status).to eq(200)
      end

      it 'returns the total services' do
        expect(response_body['total_services']).to be(3)
      end

      it 'returns the number of services in the per page param' do
        expect(response_body['services']).to match_array(
          [
            {
              'service_name' => service_one.name,
              'service_id' => service_one.id,
              'service_created_by' => service_one.created_by,
              'service_created_at' => instance_of(String),
              'service_updated_at' => instance_of(String),
              'items' => [],
              'metadata' => instance_of(Array)
            },
            {
              'service_name' => service_two.name,
              'service_id' => service_two.id,
              'service_created_by' => service_two.created_by,
              'service_created_at' => instance_of(String),
              'service_updated_at' => instance_of(String),
              'items' => [instance_of(Hash), instance_of(Hash)],
              'metadata' => instance_of(Array)
            },
            {
              'service_name' => service_three.name,
              'service_id' => service_three.id,
              'service_created_by' => service_three.created_by,
              'service_created_at' => instance_of(String),
              'service_updated_at' => instance_of(String),
              'items' => [],
              'metadata' => instance_of(Array)
            }
          ]
        )
      end
    end

    context 'when requesting second page and per page is 100' do
      let(:page) { 2 }
      let(:per_page) { 100 }

      it 'returns success response' do
        expect(response.status).to eq(200)
      end

      it 'returns the total services' do
        expect(response_body['total_services']).to be(3)
      end

      it 'returns the number of services in the per page param' do
        expect(response_body['services']).to match_array([])
      end
    end
  end
end
