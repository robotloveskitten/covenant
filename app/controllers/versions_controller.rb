class VersionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task
  before_action :set_version, only: [ :show, :restore ]

  def index
    @versions = @task.versions.ordered.includes(:user)
  end

  def show
  end

  def restore
    @task.restore_from_version!(@version)
    redirect_to @task, notice: "Restored to version #{@version.version_number}."
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def set_version
    @version = @task.versions.find(params[:id])
  end
end
