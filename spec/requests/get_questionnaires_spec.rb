require 'rails_helper'

RSpec.describe 'Questionnaires API', type: :request do
  describe 'GET /questionnaires' do
    let!(:questionnaire_1) { create(:questionnaire, created_at: 3.days.ago, service: create(:service, name: 's1')) }
    let!(:questionnaire_2) { create(:questionnaire, created_at: 2.days.ago, service: create(:service, name: 's2')) }
    let!(:questionnaire_3) { create(:questionnaire, created_at: 1.day.ago, service: create(:service, name: 's3')) }
    let(:response_body) { JSON.parse(response.body) }

    context 'when signed in' do
      before do
        allow_any_instance_of(Fb::Jwt::Auth).to receive(:verify!).and_return(true)
        get '/questionnaires', as: :json
      end

      it 'returns a successful response' do
        get '/questionnaires'

        expect(response).to have_http_status(:ok)
      end

      it 'returns total_questionnaires count' do
        get '/questionnaires'

        expect(response_body['total_questionnaires']).to eq(3)
      end

      it 'returns questionnaires ordered by created_at desc' do
        get '/questionnaires'

        ids = response_body['questionnaires'].map { |q| q['id'] }

        expect(ids.first).to eq(questionnaire_3.id)
        expect(ids.last).to eq(questionnaire_1.id)
      end

      it 'returns serialized questionnaires' do
        get '/questionnaires'

        questionnaire = response_body['questionnaires'].first

        expect(questionnaire).to include(
          'id',
          'service_id',
          'new_form_reason',
          'created_at'
        )
      end

      context 'with pagination params' do
        it 'respects per_page param' do
          get '/questionnaires', params: { per_page: 2 }

          expect(response_body['questionnaires'].size).to eq(2)
          expect(response_body['total_questionnaires']).to eq(3)
        end

        it 'respects page param' do
          get '/questionnaires', params: { per_page: 2, page: 2 }

          expect(response_body['questionnaires'].size).to eq(1)
          expect(response_body['total_questionnaires']).to eq(3)
        end
      end

      context 'when no questionnaires exist' do
        before do
          Questionnaire.delete_all
        end

        it 'returns an empty list with zero total' do
          get '/questionnaires'

          json = JSON.parse(response.body)

          expect(json['total_questionnaires']).to eq(0)
          expect(json['questionnaires']).to eq([])
        end
      end
    end
  end
end
