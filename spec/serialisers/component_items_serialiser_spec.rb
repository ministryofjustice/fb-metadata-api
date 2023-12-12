RSpec.describe ComponentItemsSerialiser do
  let(:service_metadata) do
    JSON.parse(File.read(fixtures_directory.join('service.json')))
  end
  let(:service_params) do
    {
      name: service_metadata['service_name'],
      created_by: service_metadata['created_by'],
      metadata_attributes: [{
        data: service_metadata,
        created_by: service_metadata['created_by'],
        locale: service_metadata['locale'] || 'en'
      }]
    }
  end
  let(:service) { Service.create!(service_params) }
  let(:items_params_one) do
    {
      service_id: service.id,
      component_id: '2f132e68-0e3b-48ed-a5ad-61f21fcb3d22',
      created_by: '0009212e-5925-4d28-a3f7-725774e2ac6b',
      data: [
        {
          "text": 'ragdoll',
          "value": '1'
        },
        {
          "text": 'maine coon',
          "value": '2'
        }
      ]
    }
  end
  let(:items_params_two) do
    {
      service_id: service.id,
      component_id: 'a572cfd2-9ab5-447c-8e22-c852609cbf6d',
      created_by: '0009212e-5925-4d28-a3f7-725774e2ac6b',
      data: [
        {
          "text": 'scottish fold',
          "value": '3'
        },
        {
          "text": 'devon rex',
          "value": '4'
        }
      ]
    }
  end

  context 'items' do
    let!(:items_one) { Items.create(items_params_one) }
    let!(:items_two) { Items.create(items_params_two) }

    it 'items should be valid against the schema' do
      all_items = Items.where(service_id: service.id)
      serialiser = ComponentItemsSerialiser.new(all_items, service.id)
      expect(serialiser.attributes).to eq(
        {
          service_id: service.id,
          autocomplete_ids: [items_one.id, items_two.id],
          items: {
            '2f132e68-0e3b-48ed-a5ad-61f21fcb3d22' => [
              { 'text' => 'ragdoll', 'value' => '1' },
              { 'text' => 'maine coon', 'value' => '2' }
            ],
            'a572cfd2-9ab5-447c-8e22-c852609cbf6d' => [
              { 'text' => 'scottish fold', 'value' => '3' },
              { 'text' => 'devon rex', 'value' => '4' }
            ]
          }
        }
      )
    end
  end
end
