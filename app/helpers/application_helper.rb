module ApplicationHelper
  # Allowed HTML tags for Tiptap editor content
  TIPTAP_ALLOWED_TAGS = %w[
    p br
    h1 h2 h3 h4 h5 h6
    ul ol li
    strong em u s strike del
    a
    blockquote
    code pre
    mark
    hr
    span div
  ].freeze

  # Allowed HTML attributes for Tiptap editor content
  TIPTAP_ALLOWED_ATTRIBUTES = %w[
    href target rel
    class style
    data-type data-id
  ].freeze

  # Sanitizes HTML content from Tiptap editor, allowing rich text elements
  def sanitize_tiptap_content(content)
    return "" if content.blank?

    sanitize(content, tags: TIPTAP_ALLOWED_TAGS, attributes: TIPTAP_ALLOWED_ATTRIBUTES)
  end
end
