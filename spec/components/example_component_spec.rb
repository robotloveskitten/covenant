# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExampleComponent, type: :component do
  it "renders the title" do
    render_inline(described_class.new(title: "Test Title"))

    expect(page).to have_text("Test Title")
  end

  it "renders with default variant classes" do
    render_inline(described_class.new(title: "Default"))

    expect(page).to have_css(".bg-gray-100")
  end

  it "renders primary variant" do
    render_inline(described_class.new(title: "Primary", variant: :primary))

    expect(page).to have_css(".bg-blue-500")
  end

  it "renders success variant" do
    render_inline(described_class.new(title: "Success", variant: :success))

    expect(page).to have_css(".bg-green-500")
  end

  it "renders danger variant" do
    render_inline(described_class.new(title: "Danger", variant: :danger))

    expect(page).to have_css(".bg-red-500")
  end

  it "renders content block" do
    render_inline(described_class.new(title: "With Content")) do
      "Additional content"
    end

    expect(page).to have_text("Additional content")
  end
end
