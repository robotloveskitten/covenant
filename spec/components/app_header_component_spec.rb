# frozen_string_literal: true

require "rails_helper"

RSpec.describe AppHeaderComponent, type: :component do
  let(:organization) { create(:organization, name: "Test Org") }
  let(:user) { create(:user, name: "John Doe") }
  let(:task) { create(:task, organization: organization, title: "Current Task") }

  before do
    # Create a membership so user.admin_of? works
    create(:membership, user: user, organization: organization, role: "admin")

    # Stub the controller helper methods
    allow_any_instance_of(described_class).to receive(:current_user).and_return(user)
    allow_any_instance_of(described_class).to receive(:current_organization).and_return(organization)
    allow_any_instance_of(described_class).to receive(:user_signed_in?).and_return(true)
  end

  describe "basic rendering without task" do
    it "renders header element" do
      render_inline(described_class.new)
      expect(page).to have_css("header")
    end

    it "renders app name link" do
      render_inline(described_class.new)
      expect(page).to have_link("Covenant")
    end

    it "renders organization name" do
      render_inline(described_class.new)
      expect(page).to have_text("Test Org")
    end

    it "renders user display name" do
      render_inline(described_class.new)
      expect(page).to have_text("John Doe")
    end

    it "does not render breadcrumbs" do
      render_inline(described_class.new)
      expect(page).not_to have_css("nav ol")
    end

    it "renders user dropdown menu items" do
      render_inline(described_class.new)
      expect(page).to have_link("Settings")
      expect(page).to have_link("Organization")
      expect(page).to have_link("Sign out")
    end
  end

  describe "rendering with task" do
    it "renders breadcrumbs navigation" do
      render_inline(described_class.new(task: task))
      expect(page).to have_css("nav")
    end

    it "renders home link in breadcrumbs" do
      render_inline(described_class.new(task: task))
      expect(page).to have_link("Home")
    end

    it "renders current task title in breadcrumbs" do
      render_inline(described_class.new(task: task))
      expect(page).to have_text("Current Task")
    end

    it "still renders app name and organization" do
      render_inline(described_class.new(task: task))
      expect(page).to have_link("Covenant")
      expect(page).to have_text("Test Org")
    end
  end

  describe "rendering with nested tasks" do
    let(:strategy) { create(:task, organization: organization, title: "Strategy", task_type: "strategy") }
    let(:initiative) { create(:task, organization: organization, title: "Initiative", task_type: "initiative", parent: strategy) }
    let(:nested_task) { create(:task, organization: organization, title: "Nested Task", task_type: "epic", parent: initiative) }

    it "renders all ancestor links" do
      render_inline(described_class.new(task: nested_task))
      expect(page).to have_link("Strategy")
      expect(page).to have_link("Initiative")
    end

    it "renders current task title without link" do
      render_inline(described_class.new(task: nested_task))
      expect(page).to have_text("Nested Task")
      expect(page).not_to have_link("Nested Task")
    end
  end

  describe "when user is not signed in" do
    before do
      allow_any_instance_of(described_class).to receive(:user_signed_in?).and_return(false)
      allow_any_instance_of(described_class).to receive(:current_user).and_return(nil)
    end

    it "renders sign in link" do
      render_inline(described_class.new)
      expect(page).to have_link("Sign in")
    end

    it "does not render user dropdown" do
      render_inline(described_class.new)
      expect(page).not_to have_css(".dropdown")
    end
  end

  describe "organization link visibility" do
    context "when user is not admin" do
      before do
        # Remove admin membership
        Membership.destroy_all
        create(:membership, user: user, organization: organization, role: "member")
      end

      it "does not render organization link" do
        render_inline(described_class.new)
        expect(page).not_to have_link("Organization")
      end

      it "still renders settings and sign out" do
        render_inline(described_class.new)
        expect(page).to have_link("Settings")
        expect(page).to have_link("Sign out")
      end
    end
  end
end
