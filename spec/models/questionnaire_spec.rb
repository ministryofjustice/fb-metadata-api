require 'rails_helper'

RSpec.describe Questionnaire, type: :model do
  subject(:questionnaire) { build(:questionnaire) }

  describe 'associations' do
    it { is_expected.to belong_to(:service).required }
  end

  describe 'constants' do
    it 'defines NEW_FORM_REASON_OPTIONS correctly' do
      expect(described_class::NEW_FORM_REASON_OPTIONS)
        .to match_array(%w[building experiment])
    end

    it 'defines ESTIMATED_PAGE_COUNT_OPTIONS correctly' do
      expect(described_class::ESTIMATED_PAGE_COUNT_OPTIONS)
        .to match_array(%w[under_20 20_to_50 50_to_100 over_100])
    end

    it 'defines ESTIMATED_FIRST_YEAR_SUBMISSIONS_COUNT_OPTIONS correctly' do
      expect(described_class::ESTIMATED_FIRST_YEAR_SUBMISSIONS_COUNT_OPTIONS)
        .to match_array(%w[under_10000 10000_to_100000 over_100000])
    end

    it 'defines SUBMISSION_DELIVERY_METHOD_OPTIONS correctly' do
      expect(described_class::SUBMISSION_DELIVERY_METHOD_OPTIONS)
        .to match_array(%w[email collate direct_to_service])
    end

    it 'defines REQUIRED_MOJ_FORMS_FEATURE_OPTIONS correctly' do
      expect(described_class::REQUIRED_MOJ_FORMS_FEATURE_OPTIONS)
        .to match_array(
          %w[
            multiple_questions
            multiple_branches
            control_visibility
            save_progress
            collect_responses
            hosting_off
            something_else
          ]
        )
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:new_form_reason).allow_blank }
    it { is_expected.to validate_inclusion_of(:new_form_reason).in_array(described_class::NEW_FORM_REASON_OPTIONS).allow_blank }
    it { is_expected.to validate_inclusion_of(:estimated_page_count).in_array(described_class::ESTIMATED_PAGE_COUNT_OPTIONS).allow_blank }
    it { is_expected.to validate_inclusion_of(:estimated_first_year_submissions_count).in_array(described_class::ESTIMATED_FIRST_YEAR_SUBMISSIONS_COUNT_OPTIONS).allow_blank }
    it { is_expected.to validate_inclusion_of(:submission_delivery_method).in_array(described_class::SUBMISSION_DELIVERY_METHOD_OPTIONS).allow_blank }
    it { is_expected.to validate_inclusion_of(:required_moj_forms_features).in_array(described_class::REQUIRED_MOJ_FORMS_FEATURE_OPTIONS).allow_blank }
  end
end
