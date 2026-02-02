FactoryBot.define do
  factory :questionnaire do
    new_form_reason { 'building' }
    govuk_forms_ruled_out { true }
    required_moj_forms_features { %w[multiple_questions multiple_branches] }
    govuk_forms_ruled_out_reason { 'govuk forms ruled out reason text' }
    continue_with_moj_forms { nil }
    estimated_page_count { 'under_20' }
    estimated_first_year_submissions_count { '10000_to_100000' }
    submission_delivery_method { 'email' }
    service

    trait :building do
      new_form_reason { 'building' }
    end

    trait :experiment do
      new_form_reason { 'experiment' }
      govuk_forms_ruled_out { nil }
      required_moj_forms_features { nil }
      govuk_forms_ruled_out_reason { nil }
      continue_with_moj_forms { nil }
      estimated_page_count { nil }
      estimated_first_year_submissions_count { nil }
      submission_delivery_method { nil }
    end
  end

  factory :service do
    name { 'Cowboy Bebop' }
    created_by { 'Fay' }
  end

  factory :metadata do
    data { { configuration: {}, pages: [] } }
    created_by { 'Fay' }
    locale { 'en' }
  end

  factory :items do
    created_by { 'Fay' }
    service_id { SecureRandom.uuid }
    component_id { SecureRandom.uuid }
    data do
      [
        { 'text' => 'jack', 'value' => 'bauer' },
        { 'text' => 'james', 'value' => 'bond' },
        { 'text' => 'jason', 'value' => 'bourne' },
        { 'text' => 'jack', 'value' => 'burton' }
      ]
    end
  end
end
