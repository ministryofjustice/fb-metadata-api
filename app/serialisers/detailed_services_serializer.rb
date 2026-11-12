class DetailedServicesSerializer < ServicesSerializer
  def attributes
    all_services = services.map do |service|
      {
        service_id: service.id,
        service_name: service.name,
        items: service.items,
        metadata: service.metadata
      }
    end
    response = { services: all_services }

    response.tap do
      response[:total_services] = total_services if total_services.present?
    end
  end
end
