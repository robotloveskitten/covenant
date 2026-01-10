# frozen_string_literal: true

class BreadcrumbComponent < ViewComponent::Base
  def initialize(task:)
    @task = task
  end

  private

  attr_reader :task

  def tasks_path
    helpers.tasks_path
  end

  def task_path(t)
    helpers.task_path(t)
  end

  def ancestors
    task.ancestors
  end

  def has_ancestors?
    ancestors.any?
  end
end
