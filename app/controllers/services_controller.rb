class ServicesController < MetadataController
  SERVICE_EXISTS = 'Name has already been taken'.freeze

  def index
    services = Service.order(name: :asc)

    if name_query.present?
      services = services.where(Service.arel_table[:name].matches("%#{Service.sanitize_sql_like(name_query)}%"))
    end

    total_services = services.count
    services = services.page(page).per(per_page)

    render json: ServicesSerializer.new(services, total_services:).attributes
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

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 20
  end

  def name_query
    params[:name_query] || ''
  end
end
