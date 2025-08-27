# frozen_string_literal: true

# Provides a Liquid filter to ensure that an image file exists.
# Returns a placeholder image when the given path is missing.
module Jekyll
  module ImageExistsFilter
    PLACEHOLDER = "/assets/tumbling/coming_soon.jpg"

    def ensure_image(path)
      return PLACEHOLDER if path.nil? || path.empty?

      site_source = @context.registers[:site].source
      cleaned = path.start_with?("/") ? path : "/#{path}"
      full_path = File.join(site_source, cleaned)

      File.exist?(full_path) ? cleaned : PLACEHOLDER
    end
  end
end

Liquid::Template.register_filter(Jekyll::ImageExistsFilter)

