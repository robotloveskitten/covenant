# frozen_string_literal: true

class SidebarComponent < ViewComponent::Base
  def initialize(task:)
    @task = task
  end

  private

  attr_reader :task

  def task_versions_path
    helpers.task_versions_path(task)
  end

  def versions_count
    task.versions.count
  end
end
