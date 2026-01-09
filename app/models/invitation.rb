class Invitation < ApplicationRecord
  belongs_to :organization
  belongs_to :invited_by, class_name: "User"

  ROLES = %w[admin member].freeze

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :organization_id, message: "has already been invited" }
  validates :token, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES }

  scope :pending, -> { where(accepted_at: nil) }
  scope :accepted, -> { where.not(accepted_at: nil) }

  before_validation :generate_token, on: :create

  def pending?
    accepted_at.nil?
  end

  def accepted?
    accepted_at.present?
  end

  def accept!(user)
    transaction do
      organization.memberships.create!(user: user, role: role)
      update!(accepted_at: Time.current)
    end
  end

  def expired?
    created_at < 7.days.ago
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end
end
