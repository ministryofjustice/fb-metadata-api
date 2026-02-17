class Service < ApplicationRecord
  has_many :metadata, dependent: :destroy
  has_many :items, dependent: :destroy
  has_one :questionnaire, dependent: :destroy
  validates :name, :created_by, presence: true
  validates :name, uniqueness: true
  accepts_nested_attributes_for :metadata, :questionnaire

  scope :search, lambda { |query|
    return none if query.blank?

    safe_query = "%#{sanitize_sql_like(query)}%"

    name = arel_table[:name]
    casted_id = Arel::Nodes::NamedFunction.new(
      'CAST',
      [arel_table[:id].as('TEXT')]
    )

    where(name.matches(safe_query).or(casted_id.matches(safe_query)))
  }

  def latest_metadata
    metadata.latest_version
  end
end
