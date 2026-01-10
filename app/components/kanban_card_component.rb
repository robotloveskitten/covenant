# frozen_string_literal: true

class KanbanCardComponent < ViewComponent::Base
  def initialize(task:)
    @task = task
  end

  private

  attr_reader :task

  def task_path
    helpers.task_path(task)
  end

  def card_data_attributes
    {
      id: task.id,
      kanban_target: "card"
    }
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
