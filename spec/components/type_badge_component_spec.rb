# frozen_string_literal: true

require "rails_helper"

RSpec.describe TypeBadgeComponent, type: :component do
  describe "badge variant" do
    it "renders a badge for strategy type" do
      render_inline(described_class.new(task_type: "strategy"))
      expect(page).to have_css(".badge.badge-accent")
      expect(page).to have_text("Strategy")
    end

    it "renders a badge for initiative type" do
      render_inline(described_class.new(task_type: "initiative"))
      expect(page).to have_css(".badge.badge-primary")
      expect(page).to have_text("Initiative")
    end

    it "renders a badge for epic type" do
      render_inline(described_class.new(task_type: "epic"))
      expect(page).to have_css(".badge.badge-secondary")
      expect(page).to have_text("Epic")
    end

    it "renders a badge for task type" do
      render_inline(described_class.new(task_type: "task"))
      expect(page).to have_css(".badge.badge-neutral")
      expect(page).to have_text("Task")
    end

    it "defaults to badge variant" do
      render_inline(described_class.new(task_type: "epic"))
      expect(page).to have_css(".badge")
    end
  end

  describe "bar variant" do
    it "renders a colored bar for strategy type" do
      render_inline(described_class.new(task_type: "strategy", variant: :bar))
      expect(page).to have_css(".bg-accent")
      expect(page).to have_css(".w-1.rounded-full")
    end

    it "renders a colored bar for initiative type" do
      render_inline(described_class.new(task_type: "initiative", variant: :bar))
      expect(page).to have_css(".bg-primary")
    end

    it "renders a colored bar for epic type" do
      render_inline(described_class.new(task_type: "epic", variant: :bar))
      expect(page).to have_css(".bg-secondary")
    end

    it "renders a colored bar for task type" do
      render_inline(described_class.new(task_type: "task", variant: :bar))
      expect(page).to have_css(".bg-neutral")
    end

    it "does not render text label in bar variant" do
      render_inline(described_class.new(task_type: "epic", variant: :bar))
      expect(page).not_to have_text("Epic")
    end
  end

  describe "with symbol task type" do
    it "handles symbol input" do
      render_inline(described_class.new(task_type: :epic))
      expect(page).to have_css(".badge.badge-secondary")
    end
  end
end
