# frozen_string_literal: true

class TableOfContentsComponent < ViewComponent::Base
  def initialize(container_selector: ".tiptap-editor")
    @container_selector = container_selector
  end

  private

  attr_reader :container_selector
end
