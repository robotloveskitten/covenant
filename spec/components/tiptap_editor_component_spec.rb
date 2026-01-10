# frozen_string_literal: true

require "rails_helper"

RSpec.describe TiptapEditorComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:task) { create(:task, organization: organization) }

  it "renders the tiptap controller" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-controller='tiptap']")
  end

  it "includes task id data attribute" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-tiptap-task-id-value='#{task.id}']")
  end

  it "renders editor target" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-tiptap-target='editor']")
  end

  describe "read-only mode (default)" do
    it "sets editable to false" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("[data-tiptap-editable-value='false']")
    end

    it "does not render bubble menu" do
      render_inline(described_class.new(task: task))
      expect(page).not_to have_css("[data-tiptap-target='bubbleMenu']")
    end
  end

  describe "editable mode" do
    it "sets editable to true" do
      render_inline(described_class.new(task: task, editable: true))
      expect(page).to have_css("[data-tiptap-editable-value='true']")
    end

    it "renders bubble menu" do
      render_inline(described_class.new(task: task, editable: true))
      expect(page).to have_css("[data-tiptap-target='bubbleMenu']")
    end

    it "renders formatting buttons" do
      render_inline(described_class.new(task: task, editable: true))
      expect(page).to have_css("[data-action='click->tiptap#toggleBold']")
      expect(page).to have_css("[data-action='click->tiptap#toggleItalic']")
      expect(page).to have_css("[data-action='click->tiptap#toggleUnderline']")
      expect(page).to have_css("[data-action='click->tiptap#toggleStrike']")
    end

    it "renders link and highlight buttons" do
      render_inline(described_class.new(task: task, editable: true))
      expect(page).to have_css("[data-action='click->tiptap#setLink']")
      expect(page).to have_css("[data-action='click->tiptap#toggleHighlight']")
    end
  end

  describe "content display" do
    context "with content" do
      let(:task) { create(:task, organization: organization, content: "<p>Test content</p>") }

      it "renders the content" do
        render_inline(described_class.new(task: task))
        expect(page).to have_text("Test content")
      end

      it "does not show placeholder" do
        render_inline(described_class.new(task: task))
        expect(page).not_to have_text("Click to add content...")
      end
    end

    context "without content" do
      let(:task) { create(:task, organization: organization, content: nil) }

      it "shows placeholder text" do
        render_inline(described_class.new(task: task))
        expect(page).to have_text("Click to add content...")
      end
    end
  end
end
