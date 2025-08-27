# frozen_string_literal: true

module Jekyll
  module ImageExistsFilter
    PLACEHOLDER = '/assets/tumbling/coming_soon.jpg'

    # Returns the image path if it exists, otherwise returns a placeholder.
    # Accepts a raw path String, an HTML tag String, or a Hash containing :src or 'src'.
    def image_exists(input)
      path = case input
             when Hash
               input['src'] || input[:src]
             when String
               if input.lstrip.start_with?('<')
                 input[/src\s*=\s*['"]([^'"]+)['"]/i, 1]
               else
                 input
               end
             else
               input.to_s
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
