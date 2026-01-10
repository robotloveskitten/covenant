# frozen_string_literal: true

class AssigneeComboboxComponent < ViewComponent::Base
  def initialize(task:)
    @task = task
  end

  private

  attr_reader :task

  def users_search_path
    helpers.users_search_path
  end

  def task_path
    helpers.task_path(task)
  end

  def has_assignee?
    task.assignee.present?
  end

  def assignee_initial
    task.assignee&.display_name&.first&.upcase
  end
end
