# frozen_string_literal: true

class TypeBadgeComponent < ViewComponent::Base
  TASK_TYPES = %w[strategy initiative epic task].freeze

  def initialize(task_type:, variant: :badge, soft: false, outline: false)
    @task_type = task_type.to_s
    @variant = variant
    @soft = soft
    @outline = outline
  end

  private

  attr_reader :task_type, :variant

  def badge?
    variant == :badge
  end

  def bar?
    variant == :bar
  end

  def soft?
    @soft
  end

  def outline?
    @outline
  end

  def badge_classes
    classes = [ "badge", "badge-sm", badge_color_class ]
    classes << "badge-soft" if soft?
    classes << "badge-outline" if outline?
    classes.join(" ")
  end

  def bar_classes
    "w-1 rounded-full #{bar_color_class}"
  end

  def badge_color_class
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

  def bar_color_class
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

  def label
    task_type.capitalize
  end
end
