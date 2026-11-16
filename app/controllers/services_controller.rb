class ServicesController < MetadataController
  skip_before_action MetadataPresenter::ValidateSchema, only: [:published_metadata]

  SERVICE_EXISTS = 'Name has already been taken'.freeze

  def index
    all_services = scoped_services.order(name: :asc)
    services = all_services.page(page).per(per_page)

    render json: ServicesSerializer.new(services, total_services: all_services.count).attributes
  end

  def published_metadata
    service_ids = params[:services].keys
    all_services = Service.includes(:items, :metadata).where(id: service_ids)
    services = all_services.page(page).per(per_page)

    render json: DetailedServicesSerializer.new(services, total_services: all_services.count, params: params).attributes
  end

  def create
    service = Service.new(service_params)

    if service.save
      metadata = service.latest_metadata

      render(
        json: MetadataSerialiser.new(service, metadata).attributes,
        status: :created
      )
    else
      if service.errors.full_messages.include?(SERVICE_EXISTS)
        Rails.logger.info("Service with #{service.name} already exists")
      end

      render json:
        ErrorsSerializer.new(
          message: service.errors.full_messages
        ).attributes, status: :unprocessable_entity
    end
  end

  def services_for_user
    services = Service.where(created_by: params[:user_id]).order(name: :asc)

    render json: ServicesSerializer.new(services).attributes, status: :ok
  end

  def destroy
    service_id = params[:id]
    if Service.where(id: service_id).empty?
      head :bad_request
    else
      Service.find(service_id).destroy!
      head :ok
    end
  end

  private

  def scoped_services
    if query.present?
      Service.search(query)
    else
      Service.includes(:questionnaire)
    end
  end

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 20
  end

  def query
    params[:query] || ''
  end
end
