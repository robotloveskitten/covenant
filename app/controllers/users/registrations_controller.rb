class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :organization_name, :invitation_token])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_up_path_for(resource)
    root_path
  end

  def build_resource(hash = {})
    super
    # Store invitation token for use after save
    @invitation_token = hash[:invitation_token]
    @organization_name = hash[:organization_name]
  end

  def sign_up(resource_name, resource)
    # Check for invitation token
    if @invitation_token.present?
      invitation = Invitation.pending.find_by(token: @invitation_token)
      if invitation && !invitation.expired?
        invitation.accept!(resource)
        session[:current_organization_id] = invitation.organization_id
      end
    else
      # Create a new organization for this user
      org_name = @organization_name.presence || "#{resource.display_name}'s Organization"
      organization = Organization.create!(name: org_name)
      Membership.create!(user: resource, organization: organization, role: "admin")
      session[:current_organization_id] = organization.id
    end

    super
  end
end
