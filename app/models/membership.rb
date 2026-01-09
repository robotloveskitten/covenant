class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  ROLES = %w[admin member].freeze

  validates :role, presence: true, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :organization_id }

  scope :admins, -> { where(role: "admin") }
  scope :members, -> { where(role: "member") }

  def admin?
    role == "admin"
  end

  def member?
    role == "member"
  end
end
