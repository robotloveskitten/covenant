# frozen_string_literal: true

class AppHeaderComponentPreview < ViewComponent::Preview
  # @label Without Breadcrumbs
  # Basic header with no breadcrumbs (used on task index pages)
  def without_breadcrumbs
    render AppHeaderComponent.new
  end

  # @label With Root Task
  # Header with breadcrumbs for a root-level task
  def with_root_task
    task = find_or_create_preview_task(title: "Root Strategy", task_type: "strategy")
    render AppHeaderComponent.new(task: task)
  end

  # @label With Nested Task
  # Header with breadcrumbs showing task hierarchy
  def with_nested_task
    task = find_or_create_nested_task
    render AppHeaderComponent.new(task: task)
  end

  # @label With Deeply Nested Task
  # Header with maximum depth breadcrumb trail (Strategy > Initiative > Epic > Task)
  def with_deeply_nested_task
    task = find_or_create_deeply_nested_task
    render AppHeaderComponent.new(task: task)
  end

  private

  def preview_organization
    Organization.first || Organization.create!(name: "Preview Organization", slug: "preview-org")
  end

  def find_or_create_preview_task(title:, task_type:, parent: nil)
    org = preview_organization
    task = Task.find_by(organization: org, title: title)
    return task if task

    Task.create!(
      organization: org,
      title: title,
      task_type: task_type,
      parent: parent,
      status: "in_progress"
    )
  end

  def find_or_create_nested_task
    strategy = find_or_create_preview_task(
      title: "Header Preview Strategy",
      task_type: "strategy"
    )
    find_or_create_preview_task(
      title: "Header Preview Initiative",
      task_type: "initiative",
      parent: strategy
    )
  end

  def find_or_create_deeply_nested_task
    strategy = find_or_create_preview_task(
      title: "Deep Header Strategy",
      task_type: "strategy"
    )
    initiative = find_or_create_preview_task(
      title: "Deep Header Initiative",
      task_type: "initiative",
      parent: strategy
    )
    epic = find_or_create_preview_task(
      title: "Deep Header Epic",
      task_type: "epic",
      parent: initiative
    )
    find_or_create_preview_task(
      title: "Deep Header Task",
      task_type: "task",
      parent: epic
    )
  end
end
