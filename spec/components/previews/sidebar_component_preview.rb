# frozen_string_literal: true

class SidebarComponentPreview < ViewComponent::Preview
  # @label Basic
  def basic
    task = find_or_create_preview_task
    render SidebarComponent.new(task: task)
  end

  # @label With Versions
  def with_versions
    task = find_or_create_preview_task_with_versions
    render SidebarComponent.new(task: task)
  end

  private

  def preview_organization
    Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
  end

  def find_or_create_preview_task
    org = preview_organization
    Task.find_by(organization: org, title: "Sidebar Preview Task") ||
      Task.create!(organization: org, title: "Sidebar Preview Task")
  end

  def find_or_create_preview_task_with_versions
    task = find_or_create_preview_task
    # Trigger version creation by updating content
    unless task.versions.any?
      task.update!(content: "Version 1 content")
      task.update!(content: "Version 2 content")
    end
    task
  end
end
