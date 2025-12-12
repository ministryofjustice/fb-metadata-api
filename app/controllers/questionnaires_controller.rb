class QuestionnairesController < ApplicationController
  def index
    all_questionnaires = Questionnaire.order(created_at: :desc)
    questionnaires = all_questionnaires.page(page).per(per_page)

    render json: {
      total_questionnaires: all_questionnaires.count,
      questionnaires:
    }
  end

  private

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 20
  end
end
