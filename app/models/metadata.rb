class Metadata < ApplicationRecord
  belongs_to :service
  validates :locale, :data, :created_by, presence: true

  scope :by_locale, ->(locale) { where(locale:) }
  scope :latest_version, -> { ordered.first }
  scope :previous_version, -> { ordered.second }
  scope :ordered, -> { order(created_at: :desc) }
  scope :all_versions, -> { select(:id, :created_at) }

  def autocomplete_component_uuids
    autocomplete_components.map(&:uuid)
  end

  private

  def autocomplete_components
    all_components.select(&:autocomplete?)
  end

  def all_components
    all_pages.map(&:components).flatten
  end

  def all_pages
    @all_pages ||= MetadataPresenter::Service.new(data).pages
  end
end
