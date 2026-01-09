# frozen_string_literal: true

# @label Example Component
class ExampleComponentPreview < ViewComponent::Preview
  # @label Default
  def default
    render ExampleComponent.new(title: "Default Example")
  end

  # @label Primary Variant
  def primary
    render ExampleComponent.new(title: "Primary Example", variant: :primary)
  end

  # @label Success Variant
  def success
    render ExampleComponent.new(title: "Success Example", variant: :success)
  end

  # @label Danger Variant
  def danger
    render ExampleComponent.new(title: "Danger Example", variant: :danger)
  end

  # @label With Content
  def with_content
    render ExampleComponent.new(title: "With Content", variant: :primary) do
      "This is some additional content inside the component."
    end
  end
end
