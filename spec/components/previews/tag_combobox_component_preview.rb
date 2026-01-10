# frozen_string_literal: true

# @label Tag Combobox Component
class TagComboboxComponentPreview < ViewComponent::Preview
  # @label Default (no tags selected)
  def default
    task = persisted_task_without_tags
    render TagComboboxComponent.new(task: task)
  end

  # @label With selected tags
  def with_tags
    task = task_with_tags
    render TagComboboxComponent.new(task: task)
  end

  private

  def persisted_task_without_tags
    org = Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
    task = Task.where(organization: org, title: "Combobox Preview Task").first_or_create!(
      organization: org
    )
    task.tags.clear
    task
  end

  def task_with_tags
    org = Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
    task = Task.where(organization: org, title: "Combobox Preview Task").first_or_create!(
      organization: org
    )

    if task.tags.empty?
      tag1 = find_or_create_tag(org, "Bug", "#ef4444")
      tag2 = find_or_create_tag(org, "Feature", "#22c55e")
      task.tags = [ tag1, tag2 ]
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
