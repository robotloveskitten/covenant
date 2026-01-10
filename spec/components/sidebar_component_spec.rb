# frozen_string_literal: true

require "rails_helper"

RSpec.describe SidebarComponent, type: :component do
  let(:organization) { create(:organization) }
  let(:task) { create(:task, organization: organization) }

  it "renders aside element" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("aside")
  end

  it "renders tabs container" do
    render_inline(described_class.new(task: task))
    expect(page).to have_css("[role='tablist']")
  end

  describe "Comments tab" do
    it "renders Comments tab" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("[aria-label='Comments']")
    end

    it "shows coming soon message" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text("Comments coming soon...")
    end

    it "is checked by default" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("[aria-label='Comments'][checked]")
    end
  end

  describe "Files tab" do
    it "renders Files tab" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("[aria-label='Files']")
    end

    it "shows coming soon message" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text("File attachments coming soon...")
    end
  end

  describe "History tab" do
    it "renders History tab" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("[aria-label='History']")
    end

    it "renders link to version history" do
      render_inline(described_class.new(task: task))
      expect(page).to have_link(href: "/tasks/#{task.id}/versions")
      expect(page).to have_text("View version history")
    end

    context "with versions" do
      before do
        task.update!(title: "Updated Title")
        task.update!(content: "Some content")
      end

      it "shows correct version count" do
        render_inline(described_class.new(task: task))
        expect(page).to have_text("View version history (#{task.versions.count})")
      end
    end
  end
end
