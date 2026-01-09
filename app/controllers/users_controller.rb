class UsersController < ApplicationController
  before_action :authenticate_user!

  def search
    query = params[:q].to_s.strip

    users = organization_users
    users = users.where("name LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%") if query.present?
    users = users.limit(10)

    render json: users.map { |u| { id: u.id, name: u.display_name, email: u.email } }
  end

  private

  def organization_users
    if current_organization
      current_organization.users
    else
      User.none
    end
  end
end
