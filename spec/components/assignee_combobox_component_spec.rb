# frozen_string_literal: true

require "rails_helper"

RSpec.describe AssigneeComboboxComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:task) { create(:task, organization: organization) }

  it "renders the combobox container with stimulus controller" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-controller='combobox']")
  end

  it "includes the search URL data attribute" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-combobox-url-value]")
  end

  it "includes the placeholder data attribute" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-combobox-placeholder-value='Unassigned']")
  end

  it "renders hidden input for form submission" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("input[type='hidden'][name='task[assignee_id]']", visible: false)
  end

  it "renders hidden input target" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-combobox-target='hiddenInput']", visible: false)
  end

  it "renders toggle button" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-action='click->combobox#toggle']")
  end

  it "renders dropdown target" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-combobox-target='dropdown']", visible: false)
  end

  it "renders search input target" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-combobox-target='input']", visible: false)
  end

  it "renders list target" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[data-combobox-target='list']", visible: false)
  end

  context "without assignee" do
    it "shows unassigned text" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text("Unassigned")
    end

    it "has empty hidden input value" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("input[type='hidden'][value='']", visible: false)
    end
  end

  context "with assignee" do
    let(:user) { create(:user, email: "john@example.com") }
    let(:task) { create(:task, organization: organization, assignee: user) }

    it "shows assignee name" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text(user.display_name)
    end

    it "shows assignee initial in avatar" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text(user.display_name.first.upcase)
    end

    it "has assignee id in hidden input" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("input[type='hidden'][value='#{user.id}']", visible: false)
    end

    it "shows clear button" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("[data-action='click->combobox#clear']")
    end
  end
end
