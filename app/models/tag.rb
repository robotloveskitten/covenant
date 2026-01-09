class Tag < ApplicationRecord
  belongs_to :organization, optional: true

  has_many :task_tags, dependent: :destroy
  has_many :tasks, through: :task_tags

  validates :name, presence: true, uniqueness: { scope: :organization_id }
  validates :color, format: { with: /\A#[0-9A-Fa-f]{6}\z/, allow_blank: true }

  # Default colors for tags
  COLORS = %w[#ef4444 #f97316 #eab308 #22c55e #14b8a6 #3b82f6 #8b5cf6 #ec4899].freeze

  before_validation :set_default_color

  def deletable?
    tasks.count <= 1
  end

  private

  def set_default_color
    self.color ||= COLORS.sample
  end
end
