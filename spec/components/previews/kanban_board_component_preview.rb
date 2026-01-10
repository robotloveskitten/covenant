# frozen_string_literal: true

class KanbanBoardComponentPreview < ViewComponent::Preview
  # @label Empty Board
  def empty
    epic = find_or_create_preview_epic
    clear_children(epic)
    render KanbanBoardComponent.new(task: epic, children: epic.children)
  end

  # @label With Tasks in Different Statuses
  def with_tasks
    epic = find_or_create_preview_epic
    ensure_children_in_all_statuses(epic)
    render KanbanBoardComponent.new(task: epic, children: epic.children)
  end

  # @label Many Tasks
  def many_tasks
    epic = find_or_create_preview_epic_with_many_tasks
    render KanbanBoardComponent.new(task: epic, children: epic.children)
  end

  private

  def preview_organization
    Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
  end

  def find_or_create_preview_epic
    org = preview_organization
    Task.find_by(organization: org, title: "Kanban Board Preview Epic") ||
      Task.create!(organization: org, title: "Kanban Board Preview Epic", task_type: "epic")
  end

  def find_or_create_preview_epic_with_many_tasks
    org = preview_organization
    epic = Task.find_by(organization: org, title: "Kanban Many Tasks Epic") ||
           Task.create!(organization: org, title: "Kanban Many Tasks Epic", task_type: "epic")
    ensure_many_children(epic)
    epic
  end

  def clear_children(epic)
    epic.children.destroy_all
  end

  def ensure_children_in_all_statuses(epic)
    statuses = %w[not_started in_progress completed blocked]
    statuses.each_with_index do |status, i|
      Task.find_by(organization: epic.organization, title: "Preview Task #{i + 1}") ||
        Task.create!(
          organization: epic.organization,
          parent: epic,
          title: "Preview Task #{i + 1}",
          task_type: "task",
          status: status
        )
    end
  end

  def ensure_many_children(epic)
    12.times do |i|
      status = %w[not_started in_progress completed blocked][i % 4]
      Task.find_by(organization: epic.organization, title: "Many Task #{i + 1}") ||
        Task.create!(
          organization: epic.organization,
          parent: epic,
          title: "Many Task #{i + 1}",
          task_type: "task",
          status: status
        )
    end
  end
end
