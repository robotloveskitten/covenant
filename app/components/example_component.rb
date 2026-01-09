# frozen_string_literal: true

class ExampleComponent < ViewComponent::Base
  def initialize(title:, variant: :default)
    @title = title
    @variant = variant
  end

  private

  attr_reader :title, :variant

  def variant_classes
    case variant
    when :primary
      "bg-blue-500 text-white"
    when :success
      "bg-green-500 text-white"
    when :danger
      "bg-red-500 text-white"
    else
      "bg-gray-100 text-gray-800"
    end
  end
end
