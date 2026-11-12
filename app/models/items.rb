class Items < ApplicationRecord
  belongs_to :service
  validates :data, :created_by, :component_id, presence: true

  scope :latest_version, -> { ordered.first }
  scope :ordered, -> { order(created_at: :desc) }
end
