class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Task associations
  has_many :assigned_tasks, class_name: 'Task', foreign_key: 'assignee_id', dependent: :nullify
  has_many :created_tasks, class_name: 'Task', foreign_key: 'creator_id', dependent: :nullify

  # Display name or email
  def display_name
    name.presence || email.split('@').first
  end
end
