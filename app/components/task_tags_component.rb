# frozen_string_literal: true

class TaskTagsComponent < ViewComponent::Base
  def initialize(task:, editable: false)
    @task = task
    @editable = editable
  end

  private

  attr_reader :task

  def editable?
    @editable
  end

  def tags
    task.tags
  end

  def has_tags?
    tags.any?
  end
end
