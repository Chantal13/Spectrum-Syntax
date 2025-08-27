# frozen_string_literal: true

module Jekyll
  module ImageExistsFilter
    PLACEHOLDER = '/assets/tumbling/coming_soon.jpg'

    def ensure_image(input)
      return PLACEHOLDER if input.to_s.empty?

      path = case input
             when Hash
               input['src'] || input[:src]
             else
               input
             end.to_s

      return PLACEHOLDER if path.empty?
      return path if path.start_with?('http://', 'https://')

      site_source = @context.registers[:site].source
      relative = path.sub(%r{^/}, '')
      absolute = File.expand_path(relative, site_source)
      File.exist?(absolute) ? path : PLACEHOLDER
    end
  end
end

Liquid::Template.register_filter(Jekyll::ImageExistsFilter)

