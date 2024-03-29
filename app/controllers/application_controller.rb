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
    params.permit(:metadata)
    attributes = params[:metadata]

    if attributes
      {
        name: attributes[:service_name],
        created_by: attributes[:created_by],
        metadata_attributes: [{
          data: attributes,
          created_by: attributes[:created_by],
          locale: attributes[:locale] || 'en'
        }]
      }
    else
      {
        name: nil,
        created_by: nil,
        metadata_attributes: [{}]
      }
    end
  end
end
