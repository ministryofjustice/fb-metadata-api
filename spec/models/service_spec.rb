require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:metadata).dependent(:destroy) }
    it { is_expected.to have_many(:items).dependent(:destroy) }
    it { is_expected.to have_one(:questionnaire).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:service) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:created_by) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:metadata) }
    it { is_expected.to accept_nested_attributes_for(:questionnaire) }
  end

  describe '.search' do
    let!(:service1) { create(:service, name: 'Cleaning Service') }
    let!(:service2) { create(:service, name: 'Delivery Service') }
    let!(:service3) { create(:service, name: 'Consulting') }

    context 'when search query is empty' do
      it 'returns matching services' do
        result = described_class.search('')

        expect(result).to match_array([])
      end
    end

    context 'when searching by full name' do
      it 'returns matching services' do
        result = described_class.search('Cleaning Service')

        expect(result).to contain_exactly(service1)
      end
    end

    context 'when searching by partial name' do
      it 'returns matching services' do
        result = described_class.search('Service')

        expect(result).to contain_exactly(service1, service2)
      end
    end

    context 'when searching by id' do
      it 'returns matching service by id' do
        result = described_class.search(service3.id)

        expect(result).to contain_exactly(service3)
      end
    end

    context 'when searching by partial id' do
      it 'returns matching service by id' do
        partial_id = service3.id[9, 9]
        result = described_class.search(partial_id)

        expect(result).to contain_exactly(service3)
      end
    end

    context 'when no match' do
      it 'returns empty relation' do
        expect(described_class.search('nonexistent')).to be_empty
      end
    end
  end

  describe '#latest_metadata' do
    let(:service) { create(:service) }
    let!(:old_metadata) { create(:metadata, service:, created_at: 3.days.ago) }
    let!(:new_metadata) { create(:metadata, service:, created_at: 1.day.ago) }

    it 'returns latest version metadata' do
      expect(service.latest_metadata).to eq(new_metadata)
    end
  end
end
