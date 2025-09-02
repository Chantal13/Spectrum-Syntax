require 'cgi'

module Jekyll
  module UrlDecodeFilter
    def url_decode(input)
      return input if input.nil?
      CGI.unescape(input.to_s)
    rescue
      input
    end
  end
end

Liquid::Template.register_filter(Jekyll::UrlDecodeFilter)

