# frozen_string_literal: true

if Rails.env.development?
  Lookbook.configure do |config|
    config.preview_paths = [Rails.root.join("spec/components/previews").to_s]
    config.preview_layout = "component_preview"
  end
end
