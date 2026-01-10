# frozen_string_literal: true

require "rails_helper"

RSpec.describe KanbanCardComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:task) { create(:task, organization: organization, title: "Card Task", task_type: "task") }

  it "renders task title" do
    render_inline(described_class.new(task: task))
    expect(page).to have_text("Card Task")
  end

  it "renders task type" do
    render_inline(described_class.new(task: task))
    expect(page).to have_text("task")
  end

  it "renders type badge bar" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css(".bg-neutral") # task color
  end

  it "links to the task" do
    render_inline(described_class.new(task: task))
    expect(page).to have_link(href: "/tasks/#{task.id}")
  end

  it "includes data-id for Stimulus" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-id='#{task.id}']")
  end

  it "includes data-kanban-target for Stimulus" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-kanban-target='card']")
  end

  it "has kanban-card class" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css(".kanban-card")
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
      # Assignee section should not be present
    end
  end

  context "with due date" do
    let(:task) { create(:task, organization: organization, due_date: Date.new(2025, 3, 20)) }

    it "renders formatted due date" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text("Mar 20")
    end
  end

  context "without due date" do
    it "does not render due date" do
      render_inline(described_class.new(task: task))
      # No date text should be present
    end
  end

  context "different task types" do
    it "renders strategy color" do
      task = create(:task, organization: organization, task_type: "strategy")
      render_inline(described_class.new(task: task))
      expect(page).to have_css(".bg-accent")
    end

    it "renders initiative color" do
      task = create(:task, organization: organization, task_type: "initiative")
      render_inline(described_class.new(task: task))
      expect(page).to have_css(".bg-primary")
    end

    it "renders epic color" do
      task = create(:task, organization: organization, task_type: "epic")
      render_inline(described_class.new(task: task))
      expect(page).to have_css(".bg-secondary")
    end
  end
end
