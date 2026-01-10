class InvitationsController < ApplicationController
  before_action :authenticate_user!, except: [ :accept ]
  before_action :require_organization, except: [ :accept ]
  before_action :require_admin, except: [ :accept ]

  # GET /organization/invitations
  def index
    @invitations = current_organization.invitations.pending.order(created_at: :desc)
  end

  # POST /organization/invitations
  def create
    @invitation = current_organization.invitations.new(invitation_params)
    @invitation.invited_by = current_user

    if @invitation.save
      InvitationMailer.invite(@invitation).deliver_later
      redirect_to organization_path, notice: "Invitation sent to #{@invitation.email}."
    else
      redirect_to organization_path, alert: @invitation.errors.full_messages.join(", ")
    end
  end

  # DELETE /organization/invitations/:id
  def destroy
    @invitation = current_organization.invitations.find(params[:id])
    @invitation.destroy
    redirect_to organization_path, notice: "Invitation cancelled."
  end

  # GET /invitations/:token/accept
  def accept
    @invitation = Invitation.pending.find_by(token: params[:token])

    if @invitation.nil?
      redirect_to root_path, alert: "Invitation not found or already accepted."
      return
    end

    if @invitation.expired?
      redirect_to root_path, alert: "This invitation has expired."
      return
    end

    if user_signed_in?
      # Check if user is already a member
      if current_user.member_of?(@invitation.organization)
        redirect_to root_path, alert: "You are already a member of this organization."
        return
      end

      # Accept the invitation
      @invitation.accept!(current_user)
      session[:current_organization_id] = @invitation.organization_id
      redirect_to root_path, notice: "Welcome to #{@invitation.organization.name}!"
    else
      # Redirect to signup with invitation token
      redirect_to new_user_registration_path(invitation_token: @invitation.token)
    end
  end

  private

  def invitation_params
    params.permit(:email, :role)
  end
end
