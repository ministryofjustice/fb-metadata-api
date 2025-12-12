class Questionnaire < ApplicationRecord
  belongs_to :service, optional: true

  NEW_FORM_REASON_OPTIONS = %w[building experiment].freeze
  ESTIMATED_PAGE_COUNT_OPTIONS = %w[under_20 20_to_50 50_to_100 over_100].freeze
  ESTIMATED_FIRST_YEAR_SUBMISSIONS_COUNT_OPTIONS = %w[under_10000 10000_to_100000 over_100000].freeze
  SUBMISSION_DELIVERY_METHOD_OPTIONS = %w[email collate direct_to_service].freeze
  REQUIRED_MOJ_FORMS_FEATURE_OPTIONS = %w[multiple_questions multiple_branches control_visibility save_progress collect_responses hosting_off something_else].freeze

  validates :new_form_reason,
            inclusion: { in: NEW_FORM_REASON_OPTIONS },
            presence: true

  validates :govuk_forms_ruled_out,
            inclusion: { in: [true, false] }, if: -> { new_form_reason == 'building' }

  validates :continue_with_moj_forms,
            inclusion: { in: [true, false] }, unless: -> { govuk_forms_ruled_out? }

  validates :estimated_page_count,
            inclusion: { in: ESTIMATED_PAGE_COUNT_OPTIONS },
            presence: true, if: -> { continue_with_moj_forms? }

  validates :estimated_first_year_submissions_count,
            inclusion: { in: ESTIMATED_FIRST_YEAR_SUBMISSIONS_COUNT_OPTIONS },
            presence: true, if: -> { continue_with_moj_forms? }

  validates :submission_delivery_method,
            inclusion: { in: SUBMISSION_DELIVERY_METHOD_OPTIONS },
            presence: true, if: -> { continue_with_moj_forms? }

  validates :required_moj_forms_features,
            inclusion: { in: REQUIRED_MOJ_FORMS_FEATURE_OPTIONS }
end
