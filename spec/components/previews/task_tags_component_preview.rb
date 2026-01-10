# frozen_string_literal: true

# @label Task Tags Component
class TaskTagsComponentPreview < ViewComponent::Preview
  # @label Read-only with no tags
  def readonly_no_tags
    task = Task.new(title: "Sample Task")
    render TaskTagsComponent.new(task: task, editable: false)
  end

  # @label Read-only with tags
  def readonly_with_tags
    task = task_with_tags
    render TaskTagsComponent.new(task: task, editable: false)
  end

  # @label Editable with no tags
  def editable_no_tags
    task = persisted_task_without_tags
    render TaskTagsComponent.new(task: task, editable: true)
  end

  # @label Editable with tags
  def editable_with_tags
    task = task_with_tags
    render TaskTagsComponent.new(task: task, editable: true)
  end

  private

  def persisted_task
    org = Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
    Task.where(organization: org).first || Task.create!(
      title: "Preview Task",
      organization: org
    )
  end

  def persisted_task_without_tags
    task = persisted_task
    task.tags.clear
    task
  end

  def task_with_tags
    task = persisted_task
    org = task.organization

    # Ensure we have some tags
    if task.tags.empty?
      tag1 = find_or_create_tag(org, "Bug", "#ef4444")
      tag2 = find_or_create_tag(org, "Feature", "#22c55e")
      tag3 = find_or_create_tag(org, "Urgent", "#f97316")
      task.tags = [ tag1, tag2, tag3 ]
    end

    task
  end

  def find_or_create_tag(org, name, color)
    tag = Tag.find_or_initialize_by(name: name, organization: org)
    tag.color = color
    tag.save!
    tag
  end
end
