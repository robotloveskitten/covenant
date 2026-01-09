class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Virtual attributes for registration
  attr_accessor :organization_name, :invitation_token

  # Organization associations
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :sent_invitations, class_name: "Invitation", foreign_key: "invited_by_id", dependent: :nullify

  # Task associations
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assignee_id", dependent: :nullify
  has_many :created_tasks, class_name: "Task", foreign_key: "creator_id", dependent: :nullify

  # Display name or email
  def display_name
    name.presence || email.split("@").first
  end

  def admin_of?(organization)
    memberships.exists?(organization: organization, role: "admin")
  end

  def member_of?(organization)
    memberships.exists?(organization: organization)
  end
end
