class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_organization
  before_action :require_admin

  def show
    @organization = current_organization
    @members = @organization.memberships.includes(:user).order(created_at: :asc)
    @invitations = @organization.invitations.pending.order(created_at: :desc)
  end

  def update
    @organization = current_organization

    if @organization.update(organization_params)
      redirect_to organization_path, notice: "Organization updated successfully."
    else
      @members = @organization.memberships.includes(:user).order(created_at: :asc)
      @invitations = @organization.invitations.pending.order(created_at: :desc)
      render :show, status: :unprocessable_entity
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
