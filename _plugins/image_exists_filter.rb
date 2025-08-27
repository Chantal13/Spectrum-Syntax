# frozen_string_literal: true

module Jekyll
  module ImageExistsFilter
    PLACEHOLDER = '/assets/tumbling/coming_soon.jpg'

    def ensure_image(input)
      path = case input
             when Hash
               input['src'] || input[:src]
             else
               input
             end

      return PLACEHOLDER unless path.is_a?(String) && !path.empty?
      return path if path.start_with?('http://', 'https://')

      site_source = @context.registers[:site].source
      relative = path.sub(%r{^/}, '')
      absolute = File.expand_path(relative, site_source)
      File.exist?(absolute) ? path : PLACEHOLDER
    end
  end
end

Liquid::Template.register_filter(Jekyll::ImageExistsFilter)

