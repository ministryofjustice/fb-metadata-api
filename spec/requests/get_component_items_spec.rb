RSpec.describe 'GET /services/:service_id/items/all' do
  let(:response_body) { JSON.parse(response.body) }

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
  end

  context 'when service exists' do
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
    let!(:service_2) do
      create(
        :service,
        name: 'Service 2',
        metadata: [build(:metadata)]
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
    let(:component_id_two) do
      autocomplete_service.find_page_by_url('biscuits').components.first.uuid
    end
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
    let!(:updated_items_one) do
      create(
        :items,
        service:,
        created_at: Time.zone.now,
        component_id: component_id_one,
        data: [
          {
            "text": 'demogorgon',
            "value": '100'
          },
          {
            "text": 'mind flayer',
            "value": '200'
          },
          {
            "text": 'mothra',
            "value": '500'
          }
        ]
      )
    end
    let!(:items_two) do
      create(
        :items,
        service:,
        component_id: component_id_two,
        data: [
          {
            "text": 'vecna',
            "value": '300'
          }
        ]
      )
    end
    let!(:another_service_items) do
      create(
        :items,
        service: service_2,
        component_id: SecureRandom.uuid,
        data: [
          {
            "text": 'godzilla',
            "value": '1000000'
          }
        ]
      )
    end

    before do
      get "/services/#{service.id}/items/all", as: :json
    end

    it 'returns success response' do
      expect(response.status).to be(200)
    end

    it 'returns all expected components and items for a service' do
      expect(response_body['items']).to eq(
        {
          component_id_one => [
            { 'text' => 'demogorgon', 'value' => '100' },
            { 'text' => 'mind flayer', 'value' => '200' },
            { 'text' => 'mothra', 'value' => '500' }
          ],
          component_id_two => [
            { 'text' => 'vecna', 'value' => '300' }
          ]
        }
      )
    end

    it 'returns all expected autocomplete ids' do
      expect(response_body['autocomplete_ids']).to eq(
        [updated_items_one.id, items_two.id]
      )
    end
  end

  context 'when service does not exist' do
    before do
      get '/services/1234-abcdef/items/all', as: :json
    end

    it 'returns not found response' do
      expect(response.status).to be(404)
    end

    it 'returns not found message' do
      expect(response_body).to eq({
        'message' => ["Couldn't find Service with 'id'=1234-abcdef"]
      })
    end
  end
end
