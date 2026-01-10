# frozen_string_literal: true

require "rails_helper"

RSpec.describe StatusBadgeComponent, type: :component do
  it "renders not_started status with ghost badge" do
    render_inline(described_class.new(status: "not_started"))
    expect(page).to have_css(".badge.badge-ghost")
    expect(page).to have_text("Not Started")
  end

  it "renders in_progress status with info badge" do
    render_inline(described_class.new(status: "in_progress"))
    expect(page).to have_css(".badge.badge-info")
    expect(page).to have_text("In Progress")
  end

  it "renders completed status with success badge" do
    render_inline(described_class.new(status: "completed"))
    expect(page).to have_css(".badge.badge-success")
    expect(page).to have_text("Completed")
  end

  it "renders blocked status with error badge" do
    render_inline(described_class.new(status: "blocked"))
    expect(page).to have_css(".badge.badge-error")
    expect(page).to have_text("Blocked")
  end

  it "handles symbol input" do
    render_inline(described_class.new(status: :in_progress))
    expect(page).to have_css(".badge.badge-info")
  end

  it "handles unknown status with ghost badge" do
    render_inline(described_class.new(status: "unknown"))
    expect(page).to have_css(".badge.badge-ghost")
  end
end
