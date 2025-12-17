class Service < ApplicationRecord
  has_many :metadata, dependent: :destroy
  has_many :items, dependent: :destroy
  has_one :questionnaire, dependent: :destroy
  validates :name, :created_by, presence: true
  validates :name, uniqueness: true
  accepts_nested_attributes_for :metadata, :questionnaire

  def latest_metadata
    metadata.latest_version
  end
end
