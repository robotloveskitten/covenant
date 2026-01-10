# frozen_string_literal: true

class StatusBadgeComponentPreview < ViewComponent::Preview
  # @label Not Started
  def not_started
    render StatusBadgeComponent.new(status: "not_started")
  end

  # @label In Progress
  def in_progress
    render StatusBadgeComponent.new(status: "in_progress")
  end

  # @label Completed
  def completed
    render StatusBadgeComponent.new(status: "completed")
  end

  # @label Blocked
  def blocked
    render StatusBadgeComponent.new(status: "blocked")
  end
end
