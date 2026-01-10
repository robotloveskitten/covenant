# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskMetadataComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:task) { create(:task, organization: organization, status: "in_progress") }

  describe "status display" do
    it "renders status label" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text("Status")
    end

    it "renders status badge component" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css(".badge.badge-info")
      expect(page).to have_text("In Progress")
    end
  end

  describe "assignee display" do
    context "read-only mode without assignee" do
      it "shows unassigned text" do
        render_inline(described_class.new(task: task, editable: false))
        expect(page).to have_text("Unassigned")
      end
    end

    context "read-only mode with assignee" do
      let(:user) { create(:user) }
      let(:task) { create(:task, organization: organization, assignee: user) }

      it "shows assignee name" do
        render_inline(described_class.new(task: task, editable: false))
        expect(page).to have_text(user.display_name)
      end
    end

    context "editable mode" do
      it "renders assignee combobox" do
        render_inline(described_class.new(task: task, editable: true))
        expect(page).to have_css("[data-controller='combobox']")
      end
    end
  end

  describe "due date display" do
    context "with due date" do
      let(:task) { create(:task, organization: organization, due_date: Date.new(2025, 6, 15)) }

      it "shows due date label" do
        render_inline(described_class.new(task: task))
        expect(page).to have_text("Due")
      end

      it "shows formatted due date" do
        render_inline(described_class.new(task: task))
        expect(page).to have_text("June 15, 2025")
      end
    end

    context "without due date" do
      it "does not show due date section" do
        render_inline(described_class.new(task: task))
        expect(page).not_to have_text("Due")
      end
    end
  end

  describe "tags display" do
    it "renders tags component" do
      render_inline(described_class.new(task: task))
      # TaskTagsComponent is rendered
    end

    context "read-only mode" do
      it "renders non-editable tags" do
        render_inline(described_class.new(task: task, editable: false))
        expect(page).not_to have_css("[data-controller='tag-combobox']")
      end
    end

    context "editable mode" do
      it "renders editable tags" do
        render_inline(described_class.new(task: task, editable: true))
        expect(page).to have_css("[data-controller='tag-combobox']")
      end
    end
  end

  describe "task-field controller" do
    it "includes task-field data controller" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("[data-controller='task-field']")
    end

    it "includes task path URL value" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("[data-task-field-url-value]")
    end
  end
end
