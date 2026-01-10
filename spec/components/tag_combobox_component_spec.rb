# frozen_string_literal: true

require "rails_helper"

RSpec.describe TagComboboxComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:task) { create(:task, organization: organization) }
  let(:tag) { create(:tag, name: "Bug", color: "#ef4444", organization: organization) }

  it "renders the combobox container with stimulus controller" do
    render_inline(described_class.new(task: task))

    expect(page).to have_css("[data-controller='tag-combobox']")
  end

  it "includes the search URL data attribute" do
    render_inline(described_class.new(task: task))

    expect(page).to have_css("[data-tag-combobox-url-value]")
  end

  it "includes the create URL data attribute" do
    render_inline(described_class.new(task: task))

    expect(page).to have_css("[data-tag-combobox-create-url-value]")
  end

  it "includes the task URL data attribute" do
    render_inline(described_class.new(task: task))

    expect(page).to have_css("[data-tag-combobox-task-url-value]")
  end

  it "shows placeholder when no tags selected" do
    render_inline(described_class.new(task: task))

    expect(page).to have_text("Type to search or create...")
  end

  it "renders selected tags" do
    task.tags << tag

    render_inline(described_class.new(task: task))

    expect(page).to have_text("Bug")
  end

  it "includes hidden inputs for selected tags" do
    task.tags << tag

    render_inline(described_class.new(task: task))

    expect(page).to have_css("input[type='hidden'][name='task[tag_ids][]'][value='#{tag.id}']", visible: false)
  end

  it "includes the dropdown search input" do
    render_inline(described_class.new(task: task))

    expect(page).to have_css("[data-tag-combobox-target='input']")
  end

  it "includes the colors in data attribute" do
    render_inline(described_class.new(task: task))

    expect(page).to have_css("[data-tag-combobox-colors-value]")
  end
end
