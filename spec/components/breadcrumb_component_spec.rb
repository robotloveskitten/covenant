# frozen_string_literal: true

require "rails_helper"

RSpec.describe BreadcrumbComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:task) { create(:task, organization: organization, title: "Current Task") }

  it "renders home link" do
    render_inline(described_class.new(task: task))
    expect(page).to have_link("Home", href: "/tasks")
  end

  it "renders current task title" do
    render_inline(described_class.new(task: task))
    expect(page).to have_text("Current Task")
  end

  it "renders nav element" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("nav")
  end

  it "renders separators" do
    render_inline(described_class.new(task: task))
    expect(page).to have_text("/")
  end

  context "with ancestors" do
    let(:strategy) { create(:task, organization: organization, title: "Strategy", task_type: "strategy") }
    let(:initiative) { create(:task, organization: organization, title: "Initiative", task_type: "initiative", parent: strategy) }
    let(:epic) { create(:task, organization: organization, title: "Epic", task_type: "epic", parent: initiative) }
    let(:task) { create(:task, organization: organization, title: "Current Task", task_type: "task", parent: epic) }

    it "renders all ancestor links" do
      render_inline(described_class.new(task: task))
      expect(page).to have_link("Strategy", href: "/tasks/#{strategy.id}")
      expect(page).to have_link("Initiative", href: "/tasks/#{initiative.id}")
      expect(page).to have_link("Epic", href: "/tasks/#{epic.id}")
    end

    it "renders ancestors in order" do
      render_inline(described_class.new(task: task))
      # The breadcrumb should show: Home / Strategy / Initiative / Epic / Current Task
      html = page.native.inner_html
      strategy_pos = html.index("Strategy")
      initiative_pos = html.index("Initiative")
      epic_pos = html.index("Epic")
      current_pos = html.index("Current Task")

      expect(strategy_pos).to be < initiative_pos
      expect(initiative_pos).to be < epic_pos
      expect(epic_pos).to be < current_pos
    end

    it "current task is not a link" do
      render_inline(described_class.new(task: task))
      expect(page).not_to have_link("Current Task")
      expect(page).to have_css("span", text: "Current Task")
    end
  end

  context "without ancestors" do
    let(:task) { create(:task, organization: organization, title: "Root Task", task_type: "strategy") }

    it "renders only home and current task" do
      render_inline(described_class.new(task: task))
      expect(page).to have_link("Home")
      expect(page).to have_text("Root Task")
    end
  end
end
