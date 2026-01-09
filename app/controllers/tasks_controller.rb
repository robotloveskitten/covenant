class TasksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :kanban]
  before_action :set_task, only: [:show, :edit, :update, :destroy, :kanban, :reorder_children]

  def index
    @tasks = Task.root_tasks.ordered.includes(:assignee, :tags, :children)
  end

  def show
    @children = @task.children.ordered.includes(:assignee, :tags)
  end

  def kanban
    @children = @task.children.ordered.includes(:assignee, :tags)
    render :kanban
  end

  def new
    @task = Task.new(parent_id: params[:parent_id])
    @task.task_type = params[:task_type] if params[:task_type].present?
    @task.creator = current_user
  end

  def create
    @task = Task.new(task_params)
    @task.creator = current_user

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render json: { success: true } }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @task.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    parent = @task.parent
    @task.destroy

    redirect_to parent || tasks_path, notice: 'Task was successfully deleted.'
  end

  def reorder_children
    params[:child_ids].each_with_index do |id, index|
      Task.where(id: id, parent_id: @task.id).update_all(position: index)
    end

    head :ok
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :title,
      :content,
      :task_type,
      :status,
      :default_view,
      :due_date,
      :position,
      :parent_id,
      :assignee_id,
      tag_ids: [],
      dependency_ids: []
    )
  end
end
