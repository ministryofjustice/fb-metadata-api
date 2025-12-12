class ApplicationController < ActionController::API
  NOT_FOUND_EXCEPTIONS = [
    ActiveRecord::RecordNotFound,
    MetadataVersionNotFound
  ].freeze
  rescue_from(*NOT_FOUND_EXCEPTIONS) do |exception|
    Sentry.capture_exception(exception)
    render json: ErrorsSerializer.new(
      message: exception.message
    ).attributes, status: :not_found
  end

  FB_JWT_EXCEPTIONS = [
    Fb::Jwt::Auth::TokenNotPresentError,
    Fb::Jwt::Auth::TokenNotValidError,
    Fb::Jwt::Auth::IssuerNotPresentError,
    Fb::Jwt::Auth::NamespaceNotPresentError,
    Fb::Jwt::Auth::TokenExpiredError
  ].freeze
  rescue_from(*FB_JWT_EXCEPTIONS) do |exception|
    Sentry.capture_exception(exception)
    render json: ErrorsSerializer.new(
      message: exception.message
    ).attributes, status: :forbidden
  end

  before_action AuthenticateApplication

  def not_found
    render json: ErrorsSerializer.new(
      message: "No route matches #{request.method} '#{request.path}'"
    ).attributes, status: :not_found
  end

  def service
    @service ||= Service.find(params[:service_id])
  end

  private

  def service_params
    params.permit(:metadata, :questionnaire)
    attributes = params[:metadata]
    questionnaire = params[:questionnaire]

    return empty_service_params unless attributes

    service_obj = {
      name: attributes[:service_name],
      created_by: attributes[:created_by],
      metadata_attributes: [metadata_attributes(attributes)]
    }

    service_obj.merge!(questionnaire_attributes: questionnaire_attributes(questionnaire)) if questionnaire.present?
    service_obj
  end

  def metadata_attributes(attributes)
    {
      data: attributes,
      created_by: attributes[:created_by],
      locale: attributes[:locale] || 'en'
    }
  end

  def questionnaire_attributes(questionnaire)
    return {} if questionnaire.blank?

    (Questionnaire.attribute_names - %w[id service_id created_at updated_at]).index_with { |key| questionnaire[key] }
  end

  def empty_service_params
    {
      name: nil,
      created_by: nil,
      metadata_attributes: [{}],
      questionnaire_attributes: {}
    }
  end
end
