# frozen_string_literal: true

class TaskListItemComponent < ViewComponent::Base
  def initialize(task:)
    @task = task
  end

  private

  attr_reader :task

  def task_path
    helpers.task_path(task)
  end

  def children_count
    task.children.count
  end

  def has_children?
    children_count > 0
  end

  def has_assignee?
    task.assignee.present?
  end

  def has_due_date?
    task.due_date.present?
  end

  def formatted_due_date
    task.due_date.strftime("%b %d")
  end
end
