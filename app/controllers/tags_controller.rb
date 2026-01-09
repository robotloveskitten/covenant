class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: [:update, :destroy]

  def search
    query = params[:q].to_s.strip

    tags = organization_tags
    tags = tags.where("name LIKE ?", "%#{query}%") if query.present?
    tags = tags.order(:name).limit(20)

    render json: tags.map { |t| { id: t.id, name: t.name, color: t.color } }
  end

  def create
    tag = organization_tags.new(tag_params)

    if tag.save
      render json: { id: tag.id, name: tag.name, color: tag.color }, status: :created
    else
      render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @tag.update(tag_params)
      render json: { id: @tag.id, name: @tag.name, color: @tag.color }
    else
      render json: { errors: @tag.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @tag.deletable?
      @tag.destroy
      head :no_content
    else
      render json: { error: "Tag is used by other tasks" }, status: :unprocessable_entity
    end
  end

  private

  def set_tag
    @tag = organization_tags.find(params[:id])
  end

  def organization_tags
    if current_organization
      current_organization.tags
    else
      Tag.none
    end
  end

  def tag_params
    params.require(:tag).permit(:name, :color)
  end
end
