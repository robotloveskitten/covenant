# frozen_string_literal: true

class TaskListItemComponentPreview < ViewComponent::Preview
  # @label Basic Task
  def basic
    task = find_or_create_preview_task(title: "Basic Task", task_type: "task")
    render TaskListItemComponent.new(task: task)
  end

  # @label Epic with Children
  def epic_with_children
    task = find_or_create_preview_task(title: "Feature Epic", task_type: "epic")
    ensure_children(task, 3)
    render TaskListItemComponent.new(task: task)
  end

  # @label Strategy
  def strategy
    task = find_or_create_preview_task(title: "Q1 Strategy", task_type: "strategy")
    render TaskListItemComponent.new(task: task)
  end

  # @label Initiative In Progress
  def initiative_in_progress
    task = find_or_create_preview_task(title: "Improve Performance", task_type: "initiative", status: "in_progress")
    render TaskListItemComponent.new(task: task)
  end

  # @label Completed Task
  def completed
    task = find_or_create_preview_task(title: "Completed Work", task_type: "task", status: "completed")
    render TaskListItemComponent.new(task: task)
  end

  # @label Blocked Task
  def blocked
    task = find_or_create_preview_task(title: "Blocked Work", task_type: "task", status: "blocked")
    render TaskListItemComponent.new(task: task)
  end

  # @label With Assignee
  def with_assignee
    task = find_or_create_preview_task(title: "Assigned Task", task_type: "task")
    assign_to_first_user(task)
    render TaskListItemComponent.new(task: task)
  end

  # @label With Due Date
  def with_due_date
    task = find_or_create_preview_task(title: "Task with Deadline", task_type: "task", due_date: 7.days.from_now)
    render TaskListItemComponent.new(task: task)
  end

  private

  def preview_organization
    Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
  end

  def find_or_create_preview_task(title:, task_type:, status: "not_started", due_date: nil)
    org = preview_organization
    task = Task.find_by(organization: org, title: title)
    if task
      task.update!(task_type: task_type, status: status, due_date: due_date)
      task
    else
      Task.create!(organization: org, title: title, task_type: task_type, status: status, due_date: due_date)
    end
  end

  def ensure_children(task, count)
    existing = task.children.count
    return if existing >= count

    (count - existing).times do |i|
      Task.create!(
        organization: task.organization,
        parent: task,
        title: "Child Task #{existing + i + 1}",
        task_type: "task"
      )
    end
  end

  def assign_to_first_user(task)
    user = User.first
    task.update!(assignee: user) if user
  end
end
