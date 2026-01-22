RSpec.describe 'POST /services', type: :request do
  include_examples 'application authentication' do
    let(:action) do
      post '/services', params:, as: :json
    end
  end
  let(:response_body) { JSON.parse(response.body) }
  let(:service) do
    JSON.parse(
      File.read(fixtures_directory.join('service.json'))
    ).deep_symbolize_keys
  end

  let(:questionnaire_attributes) do
    FactoryBot.attributes_for(:questionnaire).merge!(service: build(:service))
  end

  before do
    allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
    post '/services', params:, as: :json
  end

  context 'when valid attributes' do
    let(:params) { { metadata: service } }

    it 'returns created status' do
      expect(response.status).to be(201)
    end

    it 'returns service representation' do
      expect(response_body.deep_symbolize_keys).to include(service)
    end

    it 'returns service id' do
      expect(
        Service.exists?(response_body['service_id'])
      ).to be_truthy
    end

    it 'returns version id' do
      expect(
        Metadata.exists?(response_body['version_id'])
      ).to be_truthy
    end

    context 'when valid metadata with questionnaire' do
      context 'when empty questionnaire' do
        let(:params) { { metadata: service, questionnaire: {} } }

        it 'returns created status' do
          expect(response.status).to be(201)
        end

        it 'doesnt creates a questionnaire' do
          expect(Questionnaire.count).to eq(0)
        end
      end

      context 'when nil questionnaire' do
        let(:params) { { metadata: service, questionnaire: nil } }

        it 'returns created status' do
          expect(response.status).to be(201)
        end

        it 'doesnt creates a questionnaire' do
          expect(Questionnaire.count).to eq(0)
        end
      end

      context 'when valid questionnaire' do
        let(:params) { { metadata: service, questionnaire: questionnaire_attributes } }
        subject(:questionnaire) { Questionnaire.new(questionnaire_attributes) }

        it 'returns created status' do
          expect(response.status).to be(201)
        end

        it 'creates a questionnaire' do
          expect(Questionnaire.count).to eq(1)
        end

        context '#inclusion' do
          context 'when new_form_reason is `building`' do
            let(:params) { { metadata: service, questionnaire: questionnaire_attributes.merge!(new_form_reason: 'building') } }

            it 'returns valid' do
              expect(questionnaire).to be_valid
            end
          end
          context 'when new_form_reason is `reason_not_supported`' do
            let(:params) { { metadata: service, questionnaire: questionnaire_attributes.merge!(new_form_reason: 'reason_not_supported') } }

            it 'returns invalid' do
              expect(questionnaire).to be_invalid
            end
          end

          context 'when estimated_page_count is `20_to_50`' do
            let(:params) { { metadata: service, questionnaire: questionnaire_attributes.merge!(estimated_page_count: '20_to_50') } }

            it 'returns valid' do
              expect(questionnaire).to be_valid
            end
          end
          context 'when estimated_page_count is `unsupported`' do
            let(:params) { { metadata: service, questionnaire: questionnaire_attributes.merge!(estimated_page_count: 'unsupported') } }

            it 'returns invalid' do
              expect(questionnaire).to be_invalid
            end
          end

          context 'when estimated_first_year_submissions_count is `10000_to_100000`' do
            let(:params) { { metadata: service, questionnaire: questionnaire_attributes.merge!(estimated_first_year_submissions_count: '10000_to_100000') } }

            it 'returns valid' do
              expect(questionnaire).to be_valid
            end
          end
          context 'when estimated_first_year_submissions_count is `unsupported`' do
            let(:params) { { metadata: service, questionnaire: questionnaire_attributes.merge!(estimated_first_year_submissions_count: 'unsupported') } }

            it 'returns invalid' do
              expect(questionnaire).to be_invalid
            end
          end

          context 'when submission_delivery_method is `collate`' do
            let(:params) { { metadata: service, questionnaire: questionnaire_attributes.merge!(submission_delivery_method: 'collate') } }

            it 'returns valid' do
              expect(questionnaire).to be_valid
            end
          end
          context 'when submission_delivery_method is `unsupported`' do
            let(:params) { { metadata: service, questionnaire: questionnaire_attributes.merge!(submission_delivery_method: 'unsupported') } }

            it 'returns invalid' do
              expect(questionnaire).to be_invalid
            end
          end

          context 'when required_moj_forms_features is `multiple_branches`' do
            let(:params) { { metadata: service, questionnaire: questionnaire_attributes.merge!(required_moj_forms_features: 'multiple_branches') } }

            it 'returns valid' do
              expect(questionnaire).to be_valid
            end
          end

          context 'when required_moj_forms_features is `unsupported`' do
            let(:params) { { metadata: service, questionnaire: questionnaire_attributes.merge!(required_moj_forms_features: 'unsupported') } }

            it 'returns invalid' do
              expect(questionnaire).to be_invalid
            end
          end
        end
      end
    end
  end

  context 'when a locale is in the metadata' do
    let(:params) { { metadata: service.merge(locale: 'cy') } }

    it 'should set the locale correctly' do
      expect(response_body['locale']).to eq('cy')
    end
  end

  context 'when invalid attributes' do
    let(:params) { {} }

    it 'returns unprocessable entity' do
      expect(response.status).to be(422)
    end

    it 'returns error message' do
      expect(
        response_body['message']
      ).to match_array(
        ["The property '#/' did not contain a required property of 'metadata'"]
      )
    end
  end

  context 'when form name already exists' do
    let(:params) { { metadata: service } }
    before do
      post '/services', params:, as: :json
    end

    it 'returns unprocessable entity' do
      expect(response.status).to be(422)
    end

    it 'returns an error message' do
      expect(
        response_body['message']
      ).to match_array(
        ['Name has already been taken']
      )
    end
  end

  context 'when no locale is in the metadata' do
    let(:params) { { metadata: service.reject { |k, _| k == :locale } } }

    it 'returns unprocessable entity' do
      expect(response.status).to be(422)
    end

    it 'returns an error message' do
      expect(
        response_body['message']
      ).to match_array(
        ["The property '#/metadata' did not contain a required property of 'locale'"]
      )
    end
  end

  context 'catching any other route' do
    let(:params) { {} }
    before do
      post '/anything', params:, as: :json
    end

    it 'returns not found' do
      expect(response.status).to be(404)
    end

    it 'returns an error message' do
      expect(
        response_body['message']
      ).to match_array(
        ["No route matches POST '/anything'"]
      )
    end
  end
end
