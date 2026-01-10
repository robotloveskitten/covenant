# frozen_string_literal: true

class TypeBadgeComponentPreview < ViewComponent::Preview
  # @label Strategy Badge
  def strategy_badge
    render TypeBadgeComponent.new(task_type: "strategy")
  end

  # @label Initiative Badge
  def initiative_badge
    render TypeBadgeComponent.new(task_type: "initiative")
  end

  # @label Epic Badge
  def epic_badge
    render TypeBadgeComponent.new(task_type: "epic")
  end

  # @label Task Badge
  def task_badge
    render TypeBadgeComponent.new(task_type: "task")
  end

  # @label Strategy Bar
  def strategy_bar
    render TypeBadgeComponent.new(task_type: "strategy", variant: :bar)
  end

  # @label Initiative Bar
  def initiative_bar
    render TypeBadgeComponent.new(task_type: "initiative", variant: :bar)
  end

  # @label Epic Bar
  def epic_bar
    render TypeBadgeComponent.new(task_type: "epic", variant: :bar)
  end

  # @label Task Bar
  def task_bar
    render TypeBadgeComponent.new(task_type: "task", variant: :bar)
  end
end
