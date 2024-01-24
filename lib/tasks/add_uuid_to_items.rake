desc "
Add UUIDs to items in latest metadata
Usage
rake add_uuid_to_items
"
task add_uuid_to_items: :environment do |_t, _args|
  ActiveRecord::Base.logger = Logger.new($stdout)

  Service.all.find_each do |service|
    latest_metadata = service.latest_metadata
    data = latest_metadata.try(:data)

    next if data.blank?

    data['pages'].each do |page|
      Array(page['components']).each do |component|
        Array(component['items']).each do |item|
          if item['_uuid'].blank?
            item['_uuid'] = SecureRandom.uuid
          end
        end
      end
    end

    service.metadata.create!(
      data:,
      locale: latest_metadata.locale,
      created_by: latest_metadata.created_by
    )
  end
end
