# frozen_string_literal: true

class StatusBadgeComponent < ViewComponent::Base
  STATUSES = %w[not_started in_progress completed blocked].freeze

  STATUS_LABELS = {
    "not_started" => "Not Started",
    "in_progress" => "In Progress",
    "completed" => "Completed",
    "blocked" => "Blocked"
  }.freeze

  def initialize(status:)
    @status = status.to_s
  end

  private

  attr_reader :status

  def badge_classes
    "badge badge-sm #{color_class}"
  end

  def color_class
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

  def label
    STATUS_LABELS[status] || status.titleize
  end
end
