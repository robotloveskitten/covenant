module TasksHelper
  def task_type_color(task_type)
    case task_type
    when "strategy"
      "badge-accent"
    when "initiative"
      "badge-primary"
    when "epic"
      "badge-secondary"
    when "task"
      "badge-neutral"
    else
      "badge-neutral"
    end
  end

  def task_type_bg_color(task_type)
    case task_type
    when "strategy"
      "bg-accent"
    when "initiative"
      "bg-primary"
    when "epic"
      "bg-secondary"
    when "task"
      "bg-neutral"
    else
      "bg-neutral"
    end
  end

  def status_badge_class(status)
    case status
    when "not_started"
      "badge-ghost"
    when "in_progress"
      "badge-info"
    when "completed"
      "badge-success"
    when "blocked"
      "badge-error"
    else
      "badge-ghost"
    end
  end
end
