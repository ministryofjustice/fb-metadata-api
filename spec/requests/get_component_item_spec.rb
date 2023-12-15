RSpec.describe 'GET /services/:service_id/components/:component_id/items' do
  let(:response_body) { JSON.parse(response.body) }
  let(:service_metadata) do
    JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'autocomplete.json')))
  end
  let(:service_id) { service_metadata['service_id'] }
  let!(:service) do
    create(
      :service,
      id: service_id,
      name: 'Service 1',
      metadata: [metadata]
    )
  end
  let(:metadata) do
    build(
      :metadata,
      data: service_metadata
    )
  end
  let(:autocomplete_service) { MetadataPresenter::Service.new(service_metadata) }
  let(:component_id_one) do
    autocomplete_service.find_page_by_url('cakes').components.first.uuid
  end

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
  end

  context 'when component has items' do
    let!(:items_one) do
      create(
        :items,
        service:,
        created_at: Time.zone.now - 1.day,
        component_id: component_id_one,
        data: [
          {
            "text": 'demogorgon',
            "value": '100'
          },
          {
            "text": 'mind flayer',
            "value": '200'
          }
        ]
      )
    end

    before do
      get "/services/#{service.id}/components/#{component_id_one}/items", as: :json
    end

    it 'returns success response' do
      expect(response.status).to be(200)
    end

    it 'returns all expected components and items for a service' do
      expect(response_body['items']).to eq(
        {
          component_id_one => [
            { 'text' => 'demogorgon', 'value' => '100' },
            { 'text' => 'mind flayer', 'value' => '200' }
          ]
        }
      )
    end
  end

  context 'when there are no items for that component' do
    before do
      get "/services/#{service.id}/components/#{component_id_one}/items", as: :json
    end

    it 'returns not found response' do
      expect(response.status).to be(404)
    end

    it 'includes an error message' do
      expect(response_body['message']).to include(/#{component_id_one}/)
    end
  end
end
