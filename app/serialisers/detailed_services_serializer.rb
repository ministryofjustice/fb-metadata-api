class DetailedServicesSerializer
  attr_reader :services, :total_services, :params

  def initialize(services, total_services:, params:)
    @services = services
    @total_services = total_services
    @params = params.to_enum.to_h
  end

  def attributes
    all_services = services.map do |service|
      {
        service_id: service.id,
        service_name: service.name,
        service_created_by: service.created_by,
        service_created_at: service.created_at,
        service_updated_at: service.updated_at,
        items: service.items,
        metadata: service.metadata.where(id: @params['services'][service.id]['versions'])
      }
    end
    { services: all_services, total_services: total_services }
  end
end
