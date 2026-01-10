# frozen_string_literal: true

class TaskAssigneeComponent < ViewComponent::Base
  def initialize(task:, editable: false)
    @task = task
    @editable = editable
  end

  private

  attr_reader :task

  def editable?
    @editable
  end

  def assignee
    task.assignee
  end

  def has_assignee?
    assignee.present?
  end

  def assignee_initial
    assignee&.display_name&.first&.upcase
  end
end
