module TasksHelper
  def task_type_color(task_type)
    case task_type
    when 'strategy'
      'bg-purple-500'
    when 'initiative'
      'bg-blue-500'
    when 'epic'
      'bg-teal-500'
    when 'task'
      'bg-gray-400'
    else
      'bg-gray-300'
    end
  end

  def status_badge_class(status)
    case status
    when 'not_started'
      'badge-ghost'
    when 'in_progress'
      'badge-info'
    when 'completed'
      'badge-success'
    when 'blocked'
      'badge-error'
    else
      'badge-ghost'
    end
  end
end
