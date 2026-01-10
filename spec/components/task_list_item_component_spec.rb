# frozen_string_literal: true

require "rails_helper"

RSpec.describe TaskListItemComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:task) { create(:task, organization: organization, title: "Test Task", task_type: "epic", status: "in_progress") }

  it "renders task title" do
    render_inline(described_class.new(task: task))
    expect(page).to have_text("Test Task")
  end

  it "renders task type" do
    render_inline(described_class.new(task: task))
    expect(page).to have_text("epic")
  end

  it "renders type badge bar" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css(".bg-secondary") # epic color
  end

  it "renders status badge" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css(".badge.badge-info")
    expect(page).to have_text("In Progress")
  end

  it "links to the task" do
    render_inline(described_class.new(task: task))
    expect(page).to have_link(href: "/tasks/#{task.id}")
  end

  context "with assignee" do
    let(:user) { create(:user) }
    let(:task) { create(:task, organization: organization, assignee: user) }

    it "renders assignee name" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text(user.display_name)
    end
  end

  context "without assignee" do
    it "does not render assignee section" do
      render_inline(described_class.new(task: task))
      expect(page).not_to have_css(".text-xs", text: "Unassigned")
    end
  end

  context "with due date" do
    let(:task) { create(:task, organization: organization, due_date: Date.new(2025, 6, 15)) }

    it "renders formatted due date" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text("Jun 15")
    end
  end

  context "without due date" do
    it "does not render due date section" do
      render_inline(described_class.new(task: task))
      # Should not have any date-like text in the last section
    end
  end

  context "with children" do
    let(:task) { create(:task, organization: organization, task_type: "epic") }

    before do
      create(:task, organization: organization, parent: task, task_type: "task")
      create(:task, organization: organization, parent: task, task_type: "task")
    end

    it "renders children count" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text("2 items")
    end
  end

  context "without children" do
    it "does not render children count" do
      render_inline(described_class.new(task: task))
      expect(page).not_to have_text("items")
    end
  end
end
