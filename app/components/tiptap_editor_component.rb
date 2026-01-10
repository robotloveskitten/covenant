# frozen_string_literal: true

class TiptapEditorComponent < ViewComponent::Base
  def initialize(task:, editable: false)
    @task = task
    @editable = editable
  end

  private

  attr_reader :task

  def editable?
    @editable
  end

  def has_content?
    task.content.present?
  end

  def sanitized_content
    helpers.sanitize_tiptap_content(task.content)
  end
end
