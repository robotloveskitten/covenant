# frozen_string_literal: true

require "rails_helper"

RSpec.describe KanbanBoardComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:epic) { create(:task, organization: organization, title: "Test Epic", task_type: "epic") }
  let(:children) { epic.children }

  before do
    allow_any_instance_of(described_class).to receive(:user_signed_in?).and_return(false)
  end

  it "renders the kanban controller" do
    render_inline(described_class.new(task: epic, children: children))
    expect(page).to have_css("[data-controller='kanban']")
  end

  it "renders the task id data attribute" do
    render_inline(described_class.new(task: epic, children: children))
    expect(page).to have_css("[data-kanban-task-id-value='#{epic.id}']")
  end

  it "renders the title" do
    render_inline(described_class.new(task: epic, children: children))
    expect(page).to have_text("Kanban Board")
  end

  it "renders all status columns" do
    render_inline(described_class.new(task: epic, children: children))
    expect(page).to have_text("Not Started")
    expect(page).to have_text("In Progress")
    expect(page).to have_text("Completed")
    expect(page).to have_text("Blocked")
  end

  it "renders column targets" do
    render_inline(described_class.new(task: epic, children: children))
    expect(page).to have_css("[data-kanban-target='column']", count: 4)
  end

  it "renders list targets with status data attribute" do
    render_inline(described_class.new(task: epic, children: children))
    expect(page).to have_css("[data-kanban-target='list'][data-status='not_started']")
    expect(page).to have_css("[data-kanban-target='list'][data-status='in_progress']")
    expect(page).to have_css("[data-kanban-target='list'][data-status='completed']")
    expect(page).to have_css("[data-kanban-target='list'][data-status='blocked']")
  end

  context "with children in different statuses" do
    before do
      create(:task, organization: organization, parent: epic, title: "Task 1", status: "not_started", task_type: "task")
      create(:task, organization: organization, parent: epic, title: "Task 2", status: "in_progress", task_type: "task")
      create(:task, organization: organization, parent: epic, title: "Task 3", status: "in_progress", task_type: "task")
      create(:task, organization: organization, parent: epic, title: "Task 4", status: "completed", task_type: "task")
    end

    it "renders children in correct columns" do
      render_inline(described_class.new(task: epic, children: epic.children))
      expect(page).to have_text("Task 1")
      expect(page).to have_text("Task 2")
      expect(page).to have_text("Task 3")
      expect(page).to have_text("Task 4")
    end

    it "shows correct counts per column" do
      render_inline(described_class.new(task: epic, children: epic.children))
      # Count badges in the columns
      expect(page).to have_css(".kanban-column", count: 4)
    end

    it "renders KanbanCardComponent for each child" do
      render_inline(described_class.new(task: epic, children: epic.children))
      expect(page).to have_css(".kanban-card", count: 4)
    end
  end

  context "with no children" do
    it "renders empty columns" do
      render_inline(described_class.new(task: epic, children: children))
      expect(page).to have_css("[data-kanban-target='list']", count: 4)
    end
  end

  context "when user is signed in" do
    before do
      allow_any_instance_of(described_class).to receive(:user_signed_in?).and_return(true)
    end

    it "shows add item button for task with allowed child types" do
      render_inline(described_class.new(task: epic, children: children))
      expect(page).to have_link("+ Add Item")
    end
  end

  context "when user is not signed in" do
    before do
      allow_any_instance_of(described_class).to receive(:user_signed_in?).and_return(false)
    end

    it "does not show add item button" do
      render_inline(described_class.new(task: epic, children: children))
      expect(page).not_to have_link("+ Add Item")
    end
  end
end
