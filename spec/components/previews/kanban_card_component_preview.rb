# frozen_string_literal: true

class KanbanCardComponentPreview < ViewComponent::Preview
  # @label Basic Task
  def basic
    task = find_or_create_preview_task(title: "Basic Task Card", task_type: "task")
    render KanbanCardComponent.new(task: task)
  end

  # @label Epic
  def epic
    task = find_or_create_preview_task(title: "Epic Card", task_type: "epic")
    render KanbanCardComponent.new(task: task)
  end

  # @label Initiative
  def initiative
    task = find_or_create_preview_task(title: "Initiative Card", task_type: "initiative")
    render KanbanCardComponent.new(task: task)
  end

  # @label Strategy
  def strategy
    task = find_or_create_preview_task(title: "Strategy Card", task_type: "strategy")
    render KanbanCardComponent.new(task: task)
  end

  # @label With Assignee
  def with_assignee
    task = find_or_create_preview_task(title: "Assigned Card", task_type: "task")
    assign_to_first_user(task)
    render KanbanCardComponent.new(task: task)
  end

  # @label With Due Date
  def with_due_date
    task = find_or_create_preview_task(title: "Task with Deadline", task_type: "task", due_date: 3.days.from_now)
    render KanbanCardComponent.new(task: task)
  end

  # @label Full Card
  def full
    task = find_or_create_preview_task(title: "Complete Card Example", task_type: "epic", due_date: 5.days.from_now)
    assign_to_first_user(task)
    render KanbanCardComponent.new(task: task)
  end

  private

  def preview_organization
    Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
  end

  def find_or_create_preview_task(title:, task_type:, due_date: nil)
    org = preview_organization
    task = Task.find_by(organization: org, title: title)
    if task
      task.update!(task_type: task_type, due_date: due_date)
      task
    else
      Task.create!(organization: org, title: title, task_type: task_type, due_date: due_date)
    end
  end

  def assign_to_first_user(task)
    user = User.first
    task.update!(assignee: user) if user
  end
end
