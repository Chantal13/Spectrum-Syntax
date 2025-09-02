#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'json'
require 'open-uri'
require 'uri'

# Find all rock/mineral notes lacking a thumbnail and fetch one from Wikipedia

TITLE_MAP = {
  'Tiger Eye' => "Tiger's eye",
  'Banded Iron Formation' => 'Banded iron formation',
  'Moss Agate' => 'Moss agate',
  'Rose Quartz' => 'Rose quartz',
  'Smoky Quartz' => 'Smoky quartz',
  'Milky Quartz' => 'Milky quartz',
  'Picture Jasper' => 'Picture jasper',
  'Banded Jasper' => 'Jasper',
  'Heliotrope' => 'Heliotrope (mineral)',
  'Coldwater Agate' => 'Agate',
  'Lake Superior Agate' => 'Lake Superior agate',
  'Fire Agate' => 'Fire agate',
  'Limestone' => 'Limestone'
}
Dir.glob('_notes/rockhounding/rocks/**/*.md') do |file|
  content = File.read(file)
  next unless content.start_with?('---')
  fm, body = content.split(/^---\s*$\n/, 3)[1..2]
  data = YAML.safe_load(fm) || {}
  next if data.key?('thumbnail') || data.key?('cover')
  title = data['title']
  next unless title
  base_title = title.split('(').first.strip
  query_title = TITLE_MAP[base_title] || base_title
  encoded = URI.encode_www_form_component(query_title).gsub('+', '%20')
  api_url = "https://en.wikipedia.org/api/rest_v1/page/summary/#{encoded}"
  begin
    json = JSON.parse(URI.open(api_url).read)
    image = json.dig('originalimage', 'source') || json.dig('thumbnail', 'source')
  rescue StandardError => e
    warn "Failed to fetch image for #{title}: #{e.message}"
    next
  end
  next unless image
  data['thumbnail'] = image
  new_fm = YAML.dump(data).gsub(/^---\n?|\n?---$/, '').strip
  File.write(file, "---\n#{new_fm}\n---\n#{body}")
  puts "Added thumbnail for #{file}"
end
