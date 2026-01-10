# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskAssigneeComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:task) { create(:task, organization: organization) }

  describe "read-only mode" do
    it "renders 'Unassigned' when task has no assignee" do
      render_inline(described_class.new(task: task, editable: false))
      expect(page).to have_text("Unassigned")
    end

    it "renders assignee name when task has assignee" do
      user = create(:user)
      task.update!(assignee: user)
      render_inline(described_class.new(task: task, editable: false))
      expect(page).to have_text(user.display_name)
    end

    it "renders assignee initial in avatar" do
      user = create(:user)
      task.update!(assignee: user)
      render_inline(described_class.new(task: task, editable: false))
      expect(page).to have_text(user.display_name.first.upcase)
    end

    it "renders label" do
      render_inline(described_class.new(task: task, editable: false))
      expect(page).to have_text("Assignee")
    end

    it "does not render the combobox" do
      render_inline(described_class.new(task: task, editable: false))
      expect(page).not_to have_css("[data-controller='combobox']")
    end
  end

  describe "editable mode" do
    it "renders the assignee combobox component" do
      render_inline(described_class.new(task: task, editable: true))
      expect(page).to have_css("[data-controller='combobox']")
    end

    it "does not render static label" do
      render_inline(described_class.new(task: task, editable: true))
      # In editable mode, the combobox handles the display
      expect(page).not_to have_css("span", text: "Assignee")
    end
  end

  describe "default editable value" do
    it "defaults to read-only" do
      render_inline(described_class.new(task: task))
      expect(page).not_to have_css("[data-controller='combobox']")
    end
  end
end
