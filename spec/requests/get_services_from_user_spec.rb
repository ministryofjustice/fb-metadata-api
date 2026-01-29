RSpec.describe 'GET /services/users/:user_id' do
  let(:response_body) { JSON.parse(response.body) }
  let!(:service_one) do
    create(
      :service,
      name: 'Service 1',
      created_by: 'greedo',
      metadata: [build(:metadata, created_by: 'greedo')]
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
      name: 'Service 3',
      created_by: 'greedo',
      metadata: [build(:metadata, created_by: 'greedo')],
      questionnaire: build(:questionnaire, :experiment)
    )
  end

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
  end

  context 'when there are services which the user contributed to' do
    before do
      get '/services/users/greedo', as: :json
    end

    it 'returns success response' do
      expect(response.status).to be(200)
    end

    it 'returns services that user contributed to' do
      expect(response_body['services']).to match_array(
        [
          {
            'service_name' => service_one.name,
            'service_id' => service_one.id,
            'questionnaire' => nil
          },
          {
            'service_name' => service_three.name,
            'service_id' => service_three.id,
            'questionnaire' => {
              'id' => instance_of(String),
              'service_id' => service_three.id,
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

  context 'when there are no services which the user contributed to' do
    before do
      get '/services/users/jabba', as: :json
    end

    it 'returns success response' do
      expect(response.status).to be(200)
    end

    it 'returns empty services' do
      expect(response_body).to eq({ 'services' => [] })
    end
  end
end
