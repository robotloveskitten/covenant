# frozen_string_literal: true

class TaskMetadataComponent < ViewComponent::Base
  def initialize(task:, editable: false)
    @task = task
    @editable = editable
  end

  private

  attr_reader :task

  def editable?
    @editable
  end

  def task_path
    helpers.task_path(task)
  end

  def has_due_date?
    task.due_date.present?
  end

  def formatted_due_date
    task.due_date.strftime("%B %d, %Y")
  end
end
