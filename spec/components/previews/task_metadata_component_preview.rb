# frozen_string_literal: true

class TaskMetadataComponentPreview < ViewComponent::Preview
  # @label Read-only Basic
  def readonly_basic
    task = find_or_create_preview_task
    render TaskMetadataComponent.new(task: task, editable: false)
  end

  # @label Read-only with Assignee
  def readonly_with_assignee
    task = find_or_create_preview_task_with_assignee
    render TaskMetadataComponent.new(task: task, editable: false)
  end

  # @label Read-only with Due Date
  def readonly_with_due_date
    task = find_or_create_preview_task(due_date: 7.days.from_now)
    render TaskMetadataComponent.new(task: task, editable: false)
  end

  # @label Read-only with Tags
  def readonly_with_tags
    task = find_or_create_preview_task_with_tags
    render TaskMetadataComponent.new(task: task, editable: false)
  end

  # @label Read-only Full
  def readonly_full
    task = find_or_create_full_preview_task
    render TaskMetadataComponent.new(task: task, editable: false)
  end

  # @label Editable Basic
  def editable_basic
    task = find_or_create_preview_task
    render TaskMetadataComponent.new(task: task, editable: true)
  end

  # @label Editable Full
  def editable_full
    task = find_or_create_full_preview_task
    render TaskMetadataComponent.new(task: task, editable: true)
  end

  private

  def preview_organization
    Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
  end

  def find_or_create_preview_task(status: "in_progress", due_date: nil)
    org = preview_organization
    task = Task.find_by(organization: org, title: "Metadata Preview Task")
    if task
      task.update!(status: status, due_date: due_date)
      task
    else
      Task.create!(organization: org, title: "Metadata Preview Task", status: status, due_date: due_date)
    end
  end

  def find_or_create_preview_task_with_assignee
    task = find_or_create_preview_task
    user = User.first
    task.update!(assignee: user) if user
    task
  end

  def find_or_create_preview_task_with_tags
    org = preview_organization
    task = find_or_create_preview_task
    tag = Tag.find_by(organization: org, name: "Preview Tag") ||
          Tag.create!(organization: org, name: "Preview Tag", color: "#3b82f6")
    task.tags << tag unless task.tags.include?(tag)
    task
  end

  def find_or_create_full_preview_task
    task = find_or_create_preview_task(status: "in_progress", due_date: 14.days.from_now)
    user = User.first
    task.update!(assignee: user) if user

    org = preview_organization
    tag = Tag.find_by(organization: org, name: "Full Preview Tag") ||
          Tag.create!(organization: org, name: "Full Preview Tag", color: "#ef4444")
    task.tags << tag unless task.tags.include?(tag)
    task
  end
end
