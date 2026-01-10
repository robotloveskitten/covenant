# frozen_string_literal: true

class TiptapEditorComponentPreview < ViewComponent::Preview
  # @label Read-only Empty
  def readonly_empty
    task = find_or_create_preview_task(content: nil)
    render TiptapEditorComponent.new(task: task, editable: false)
  end

  # @label Read-only with Content
  def readonly_with_content
    task = find_or_create_preview_task(content: sample_content)
    render TiptapEditorComponent.new(task: task, editable: false)
  end

  # @label Editable Empty
  def editable_empty
    task = find_or_create_preview_task(content: nil)
    render TiptapEditorComponent.new(task: task, editable: true)
  end

  # @label Editable with Content
  def editable_with_content
    task = find_or_create_preview_task(content: sample_content)
    render TiptapEditorComponent.new(task: task, editable: true)
  end

  private

  def preview_organization
    Organization.first || Organization.create!(name: "Preview Org", slug: "preview-org")
  end

  def find_or_create_preview_task(content:)
    org = preview_organization
    task = Task.find_by(organization: org, title: "Tiptap Editor Preview Task")
    if task
      task.update!(content: content)
      task
    else
      Task.create!(organization: org, title: "Tiptap Editor Preview Task", content: content)
    end
  end

  def sample_content
    <<~HTML
      <h2>Sample Document</h2>
      <p>This is a sample document with <strong>bold</strong>, <em>italic</em>, and <u>underlined</u> text.</p>
      <p>You can also add <a href="#">links</a> and <mark>highlighted text</mark>.</p>
      <ul>
        <li>First item</li>
        <li>Second item</li>
        <li>Third item</li>
      </ul>
    HTML
  end
end
