class ServicesSerializer
  attr_reader :services, :total_services

  def initialize(services, total_services: nil)
    @services = services
    @total_services = total_services
  end

  def attributes
    all_services = services.map do |service|
      {
        service_id: service.id,
        service_name: service.name,
        questionnaire: service.questionnaire
      }
    end
    response = { services: all_services }

    response.tap do
      response[:total_services] = total_services if total_services.present?
    end
  end
end
