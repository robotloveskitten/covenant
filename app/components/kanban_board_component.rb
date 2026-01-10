# frozen_string_literal: true

class KanbanBoardComponent < ViewComponent::Base
  STATUSES = Task::STATUSES
  STATUS_LABELS = Task::STATUS_LABELS

  def initialize(task:, children:)
    @task = task
    @children = children
  end

  private

  attr_reader :task, :children

  def new_task_path
    helpers.new_task_path(parent_id: task.id, task_type: task.allowed_child_types.first)
  end

  def user_signed_in?
    helpers.user_signed_in?
  end

  def can_add_children?
    user_signed_in? && task.allowed_child_types.any?
  end

  def children_by_status(status)
    children.by_status(status).ordered
  end

  def children_count_by_status(status)
    children.by_status(status).count
  end

  def status_label(status)
    STATUS_LABELS[status]
  end
end
