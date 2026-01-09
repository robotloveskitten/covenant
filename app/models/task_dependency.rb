class TaskDependency < ApplicationRecord
  belongs_to :task
  belongs_to :dependency, class_name: 'Task'

  validates :task_id, uniqueness: { scope: :dependency_id }
  validate :no_self_dependency
  validate :no_circular_dependency

  private

  def no_self_dependency
    if task_id == dependency_id
      errors.add(:dependency, "can't be the same as the task")
    end
  end

  def no_circular_dependency
    return unless dependency

    if dependency.dependencies.include?(task)
      errors.add(:dependency, "would create a circular dependency")
    end
  end
end
