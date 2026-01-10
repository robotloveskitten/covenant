# frozen_string_literal: true

class BreadcrumbComponentPreview < ViewComponent::Preview
  # @label Root Level Task
  def root_level
    task = find_or_create_preview_task(title: "Root Strategy", task_type: "strategy")
    render BreadcrumbComponent.new(task: task)
  end

  # @label Nested Task
  def nested
    task = find_or_create_nested_task
    render BreadcrumbComponent.new(task: task)
  end

  # @label Deeply Nested
  def deeply_nested
    task = find_or_create_deeply_nested_task
    render BreadcrumbComponent.new(task: task)
  end

  private

  def preview_organization
    Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
  end

  def find_or_create_preview_task(title:, task_type:, parent: nil)
    org = preview_organization
    task = Task.find_by(organization: org, title: title)
    return task if task

    Task.create!(organization: org, title: title, task_type: task_type, parent: parent)
  end

  def find_or_create_nested_task
    org = preview_organization
    strategy = find_or_create_preview_task(title: "Breadcrumb Strategy", task_type: "strategy")
    find_or_create_preview_task(title: "Breadcrumb Initiative", task_type: "initiative", parent: strategy)
  end

  def find_or_create_deeply_nested_task
    org = preview_organization
    strategy = find_or_create_preview_task(title: "Deep Strategy", task_type: "strategy")
    initiative = find_or_create_preview_task(title: "Deep Initiative", task_type: "initiative", parent: strategy)
    epic = find_or_create_preview_task(title: "Deep Epic", task_type: "epic", parent: initiative)
    find_or_create_preview_task(title: "Deep Task", task_type: "task", parent: epic)
  end
end
