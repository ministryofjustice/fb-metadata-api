RSpec.describe Metadata, type: :model do
  subject(:metadata) do
    Metadata.new(
      service:,
      locale: 'en',
      data: service_metadata,
      created_by: 'Maverick'
    )
  end
  let(:service_metadata) do
    JSON.parse(File.read(Rails.root.join('spec', 'fixtures', 'autocomplete.json')))
  end
  let(:autocomplete_service) { MetadataPresenter::Service.new(service_metadata) }
  let(:service_id) { service_metadata['service_id'] }
  let(:component_id_one) do
    autocomplete_service.find_page_by_url('cakes').components.first.uuid
  end
  let(:component_id_two) do
    autocomplete_service.find_page_by_url('biscuits').components.first.uuid
  end
  let(:component_id_three) do
    autocomplete_service.find_page_by_url('ice-cream').components.first.uuid
  end

  describe '#autocomplete_component_uuids' do
    let(:service) { create(:service, id: service_id) }

    context 'when there are autocomplete components' do
      let(:expected_uuids) { [component_id_one, component_id_two, component_id_three] }

      before do
        create(:metadata, service:, data: service_metadata)
        create(
          :items,
          service:,
          component_id: component_id_one,
          service_id: service.id
        )
        create(
          :items,
          service:,
          component_id: component_id_two,
          service_id: service.id
        )
      end

      # it 'returns uuids of autocomplete components in a service' do
      #   expect(metadata.autocomplete_component_uuids).to eq(expected_uuids)
      # end
    end

    context 'when there are no autocomplete components' do
      let(:service_metadata) do
        JSON.parse(File.read(fixtures_directory.join('branching.json')))
      end
      let(:metadata) { create(:metadata, service:, data: service_metadata) }

      it 'returns empty' do
        expect(metadata.autocomplete_component_uuids).to be_empty
      end
    end
  end
end
