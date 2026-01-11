# frozen_string_literal: true

require "rails_helper"

RSpec.describe TableOfContentsComponent, type: :component do
  it "renders the ToC container" do
    render_inline(described_class.new)
    expect(page).to have_css("[data-controller='toc']")
  end

  it "renders the entries list" do
    render_inline(described_class.new)
    expect(page).to have_css("[data-toc-target='entries']")
  end

  it "renders the abstract entries list" do
    render_inline(described_class.new)
    expect(page).to have_css("[data-toc-target='abstract']")
  end

  it "sets custom container selector" do
    render_inline(described_class.new(container_selector: "#custom-content"))
    expect(page).to have_css("[data-toc-container-value='#custom-content']")
  end

  it "uses default container selector" do
    render_inline(described_class.new)
    expect(page).to have_css("[data-toc-container-value='.tiptap-editor']")
  end

  it "hides entries list by default" do
    render_inline(described_class.new)
    expect(page).to have_css("[data-toc-target='entries'].hidden")
  end
end
