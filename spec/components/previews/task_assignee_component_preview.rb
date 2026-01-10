# frozen_string_literal: true

class TaskAssigneeComponentPreview < ViewComponent::Preview
  # @label Read-only with no assignee
  def readonly_no_assignee
    task = persisted_task_without_assignee
    render TaskAssigneeComponent.new(task: task, editable: false)
  end

  # @label Read-only with assignee
  def readonly_with_assignee
    task = persisted_task_with_assignee
    render TaskAssigneeComponent.new(task: task, editable: false)
  end

  # @label Editable with no assignee
  def editable_no_assignee
    task = persisted_task_without_assignee
    render TaskAssigneeComponent.new(task: task, editable: true)
  end

  # @label Editable with assignee
  def editable_with_assignee
    task = persisted_task_with_assignee
    render TaskAssigneeComponent.new(task: task, editable: true)
  end

  private

  def preview_organization
    Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
  end

  def persisted_task_without_assignee
    org = preview_organization
    task = Task.where(organization: org, title: "Task Assignee Preview").first_or_create!(
      organization: org
    )
    task.update!(assignee: nil)
    task
  end

  def persisted_task_with_assignee
    org = preview_organization
    task = Task.where(organization: org, title: "Assigned Task Assignee Preview").first_or_create!(
      organization: org
    )
    user = User.first
    task.update!(assignee: user) if user
    task
  end
end
