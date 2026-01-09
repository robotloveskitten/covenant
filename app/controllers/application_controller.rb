class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_organization

  private

  def current_organization
    return @current_organization if defined?(@current_organization)

    @current_organization = if session[:current_organization_id]
      current_user&.organizations&.find_by(id: session[:current_organization_id])
    else
      current_user&.organizations&.first
    end

    # Update session if we found an organization
    session[:current_organization_id] = @current_organization&.id if @current_organization

    @current_organization
  end

  def require_organization
    unless current_organization
      redirect_to root_path, alert: "Please create or join an organization first."
    end
  end

  def require_admin
    unless current_user&.admin_of?(current_organization)
      redirect_to root_path, alert: "You must be an admin to access this page."
    end
  end
end
