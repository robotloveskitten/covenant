# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskTagsComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:task) { create(:task, organization: organization) }
  let(:tag) { create(:tag, name: "Important", color: "#ef4444", organization: organization) }

  describe "read-only mode" do
    it "renders 'No tags' when task has no tags" do
      render_inline(described_class.new(task: task, editable: false))

      expect(page).to have_text("No tags")
    end

    it "renders tag badges when task has tags" do
      task.tags << tag

      render_inline(described_class.new(task: task, editable: false))

      expect(page).to have_text("Important")
      expect(page).to have_css(".badge")
    end

    it "does not render the combobox" do
      render_inline(described_class.new(task: task, editable: false))

      expect(page).not_to have_css("[data-controller='tag-combobox']")
    end
  end

  describe "editable mode" do
    it "renders the tag combobox component" do
      render_inline(described_class.new(task: task, editable: true))

      expect(page).to have_css("[data-controller='tag-combobox']")
    end

    it "shows 'Type to search or create...' placeholder when no tags" do
      render_inline(described_class.new(task: task, editable: true))

      expect(page).to have_text("Type to search or create...")
    end

    it "shows existing tags in the combobox" do
      task.tags << tag

      render_inline(described_class.new(task: task, editable: true))

      expect(page).to have_text("Important")
    end
  end
end
