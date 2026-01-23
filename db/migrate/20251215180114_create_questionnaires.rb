class CreateQuestionnaires < ActiveRecord::Migration[7.2]
  def change
    enable_extension 'pgcrypto'
    create_table :questionnaires, id: :uuid, default: 'gen_random_uuid()' do |t|
      t.string :new_form_reason, null: false
      t.boolean :govuk_forms_ruled_out
      t.jsonb :required_moj_forms_features
      t.text :govuk_forms_ruled_out_reason
      t.boolean :continue_with_moj_forms
      t.string :estimated_page_count
      t.string :estimated_first_year_submissions_count
      t.string :submission_delivery_method
      t.references :service, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
