# frozen_string_literal: true

class TableOfContentsComponentPreview < ViewComponent::Preview
  layout "toc_preview"

  # @label With Sample Content
  def with_sample_content
    render TableOfContentsComponent.new(container_selector: ".preview-content")
  end
end
