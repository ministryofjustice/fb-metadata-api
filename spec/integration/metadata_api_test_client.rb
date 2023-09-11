class MetadataApiTestClient
  include HTTParty
  base_uri 'metadata-app:3000'
  attr_reader :headers

  def initialize
    @headers = {
      Accept: 'application/json',
      'Content-Type': 'application/json'
    }
  end

  def create_service(body:, authorisation_headers:)
    self.class.post('/services', **{ headers: headers.merge(authorisation_headers), body: })
  end

  def get_version(service_id:, version_id:, authorisation_headers:)
    self.class.get(
      "/services/#{service_id}/versions/#{version_id}",
      headers: headers.merge(authorisation_headers)
    )
  end

  def new_version(service_id:, body:, authorisation_headers:)
    self.class.post(
      "/services/#{service_id}/versions",
      {
        body:,
        headers: headers.merge(authorisation_headers)
      }
    )
  end

  def all_versions(service_id:, authorisation_headers:)
    self.class.get(
      "/services/#{service_id}/versions",
      headers: headers.merge(authorisation_headers)
    )
  end

  def get_latest_version(service_id:, authorisation_headers:)
    self.class.get(
      "/services/#{service_id}/versions/latest",
      headers: headers.merge(authorisation_headers)
    )
  end

  def get_services_for_user(user_id:, authorisation_headers:)
    self.class.get(
      "/services/users/#{user_id}",
      headers: headers.merge(authorisation_headers)
    )
  end

  def get_items_for_service(service_id:, authorisation_headers:)
    self.class.get(
      "/services/#{service_id}/items/all",
      headers: headers.merge(authorisation_headers)
    )
  end

  def create_items(service_id:, component_id:, body:, authorisation_headers:)
    self.class.post(
      "/services/#{service_id}/components/#{component_id}/items/all",
      {
        body:,
        headers: headers.merge(authorisation_headers)
      }
    )
  end

  def get_items_for_component(service_id:, component_id:, authorisation_headers:)
    self.class.get(
      "/services/#{service_id}/components/#{component_id}/items",
      {
        headers: headers.merge(authorisation_headers)
      }
    )
  end

  def delete_service(service_id, authorisation_headers:)
    self.class.delete("/services/#{service_id}", headers: headers.merge(authorisation_headers))
  end
end
