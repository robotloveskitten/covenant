# frozen_string_literal: true

class TagComboboxComponent < ViewComponent::Base
  def initialize(task:)
    @task = task
  end

  private

  attr_reader :task

  def tags_search_path
    helpers.tags_search_path
  end

  def tags_path
    helpers.tags_path
  end

  def task_path
    helpers.task_path(task)
  end

  def selected_tags_json
    task.tags.map { |t| { id: t.id, name: t.name, color: t.color } }.to_json
  end

  def colors_json
    Tag::COLORS.to_json
  end
end
