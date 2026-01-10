# frozen_string_literal: true

class AssigneeComboboxComponentPreview < ViewComponent::Preview
  # @label Without Assignee
  def without_assignee
    task = persisted_task_without_assignee
    render AssigneeComboboxComponent.new(task: task)
  end

  # @label With Assignee
  def with_assignee
    task = persisted_task_with_assignee
    render AssigneeComboboxComponent.new(task: task)
  end

  private

  def preview_organization
    Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
  end

  def persisted_task_without_assignee
    org = preview_organization
    task = Task.where(organization: org, title: "Assignee Combobox Preview Task").first_or_create!(
      organization: org
    )
    task.update!(assignee: nil)
    task
  end

  def persisted_task_with_assignee
    org = preview_organization
    task = Task.where(organization: org, title: "Assigned Task Preview").first_or_create!(
      organization: org
    )
    user = User.first
    task.update!(assignee: user) if user
    task
  end
end
