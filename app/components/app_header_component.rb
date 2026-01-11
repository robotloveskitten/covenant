# frozen_string_literal: true

class AppHeaderComponent < ViewComponent::Base
  def initialize(task: nil)
    @task = task
  end

  private

  attr_reader :task

  def show_breadcrumbs?
    task.present?
  end

  def current_user
    helpers.current_user
  end

  def current_organization
    helpers.current_organization
  end

  def user_signed_in?
    helpers.user_signed_in?
  end

  def root_path
    helpers.root_path
  end

  def tasks_path
    helpers.tasks_path
  end

  def task_path(t)
    helpers.task_path(t)
  end

  def settings_path
    helpers.settings_path
  end

  def organization_path
    helpers.organization_path
  end

  def new_user_session_path
    helpers.new_user_session_path
  end

  def destroy_user_session_path
    helpers.destroy_user_session_path
  end

  def ancestors
    task&.ancestors || []
  end
end
