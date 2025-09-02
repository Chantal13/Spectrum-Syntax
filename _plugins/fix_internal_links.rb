# frozen_string_literal: true
require 'uri'

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  next unless doc.output.is_a?(String)

  html = doc.output.dup

  # Fix mistakenly absolute "https://<section>/..." links -> "/<section>/..."
  %w[games rockhounding tumbling hobbies blog].each do |section|
    html.gsub!(/href=(["'])https?:\/\/#{section}\//i, 'href=\1/' + section + '/')
    # Ensure section links are root-absolute (add leading slash if missing)
    html.gsub!(/href=(["'])#{section}\//i, 'href=\1/' + section + '/')
  end

  # Ensure spaces in internal hrefs are percent-encoded
  html.gsub!(/href=(['"])(\/[^'"#?]*\s[^'"#?]*)(['"#?])/) do
    q1 = Regexp.last_match(1)
    raw = Regexp.last_match(2)
    q2 = Regexp.last_match(3)
    encoded = URI::DEFAULT_PARSER.escape(raw)
    "href=#{q1}#{encoded}#{q2}"
  end

  doc.output = html
end
