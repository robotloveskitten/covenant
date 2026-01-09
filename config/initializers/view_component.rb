# frozen_string_literal: true

Rails.application.config.view_component.tap do |config|
  config.preview_paths = [Rails.root.join("spec/components/previews")]
  config.test_controller = "ApplicationController"
  config.show_previews = Rails.env.development?
end

