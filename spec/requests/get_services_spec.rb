RSpec.describe 'GET /services' do
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
      metadata: [build(:metadata, created_by: 'han')]
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

  context 'when signed in' do
    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
      get '/services', as: :json
    end

    it 'returns success response' do
      expect(response.status).to eq(200)
    end

    it 'returns the total services' do
      expect(response_body['total_services']).to be(3)
    end

    it 'returns all services' do
      expect(response_body['services']).to match_array(
        [
          {
            'service_name' => service_one.name,
            'service_id' => service_one.id,
            'questionnaire' => {
              'id' => instance_of(String),
              'service_id' => service_one.id,
              'new_form_reason' => 'experiment',
              'govuk_forms_ruled_out' => nil,
              'required_moj_forms_features' => nil,
              'govuk_forms_ruled_out_reason' => nil,
              'continue_with_moj_forms' => nil,
              'estimated_page_count' => nil,
              'estimated_first_year_submissions_count' => nil,
              'submission_delivery_method' => nil,
              'created_at' => instance_of(String),
              'updated_at' => instance_of(String)
            }
          },
          {
            'service_name' => service_two.name,
            'service_id' => service_two.id,
            'questionnaire' => nil
          },
          {
            'service_name' => service_three.name,
            'service_id' => service_three.id,
            'questionnaire' => {
              'id' => instance_of(String),
              'service_id' => service_three.id,
              'new_form_reason' => 'building',
              'govuk_forms_ruled_out' => true,
              'required_moj_forms_features' => %w[multiple_questions multiple_branches],
              'govuk_forms_ruled_out_reason' => 'govuk forms ruled out reason text',
              'continue_with_moj_forms' => nil,
              'estimated_page_count' => 'under_20',
              'estimated_first_year_submissions_count' => '10000_to_100000',
              'submission_delivery_method' => 'email',
              'created_at' => instance_of(String),
              'updated_at' => instance_of(String)
            }
          }
        ]
      )
    end
  end

  context 'when paginating' do
    let(:per_page) { 1 }

    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
      get "/services?page=#{page}&per_page=#{per_page}", as: :json
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
              'questionnaire' => {
                'id' => instance_of(String),
                'service_id' => service_one.id,
                'new_form_reason' => 'experiment',
                'govuk_forms_ruled_out' => nil,
                'required_moj_forms_features' => nil,
                'govuk_forms_ruled_out_reason' => nil,
                'continue_with_moj_forms' => nil,
                'estimated_page_count' => nil,
                'estimated_first_year_submissions_count' => nil,
                'submission_delivery_method' => nil,
                'created_at' => instance_of(String),
                'updated_at' => instance_of(String)
              }
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
              'questionnaire' => nil
            }
          ]
        )
      end
    end
  end

  context 'when filtering by name' do
    let(:query) { 'nume' }

    before do
      allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
      get "/services?query=#{query}", as: :json
    end

    it 'returns success response' do
      expect(response.status).to eq(200)
    end

    it 'returns the total services' do
      expect(response_body['total_services']).to be(1)
    end

    it 'returns services matching the name query' do
      expect(response_body['services']).to match_array(
        [
          {
            'service_name' => service_three.name,
            'service_id' => service_three.id,
            'questionnaire' => {
              'id' => instance_of(String),
              'service_id' => service_three.id,
              'new_form_reason' => 'building',
              'govuk_forms_ruled_out' => true,
              'required_moj_forms_features' => %w[multiple_questions multiple_branches],
              'govuk_forms_ruled_out_reason' => 'govuk forms ruled out reason text',
              'continue_with_moj_forms' => nil,
              'estimated_page_count' => 'under_20',
              'estimated_first_year_submissions_count' => '10000_to_100000',
              'submission_delivery_method' => 'email',
              'created_at' => instance_of(String),
              'updated_at' => instance_of(String)
            }
          }

        ]
      )
    end
  end
end
