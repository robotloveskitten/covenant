class UsersController < ApplicationController
  def search
    query = params[:q].to_s.strip
    
    users = if query.present?
      User.where("name LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%")
    else
      User.all
    end
    
    # TODO: Scope to current account when Account model is added
    # users = users.where(account: current_user.account) if current_user
    
    users = users.limit(10)
    
    render json: users.map { |u| { id: u.id, name: u.display_name, email: u.email } }
  end
end
