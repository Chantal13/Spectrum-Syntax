#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'date'

ROOT = File.expand_path('..', __dir__)
IMAGE_EXTENSIONS = %w[.png .jpg .jpeg .gif .svg .webp]

# Recursively extract image paths from front matter data
# @param obj [Object] the value to inspect
# @param paths [Array<String>, nil] accumulator for extracted paths
# @return [Array<String>] list of image paths

def extract_image_paths(obj, paths = nil)
  paths ||= []

  case obj
  when String
    if IMAGE_EXTENSIONS.any? { |ext| obj.downcase.end_with?(ext) }
      paths << obj
    end
  when Array
    obj.each { |item| extract_image_paths(item, paths) }
  when Hash
    obj.each_value { |value| extract_image_paths(value, paths) }
  end

  paths
end

missing = {}

Dir.chdir(ROOT) do
  Dir.glob('**/*.{md,markdown}') do |file|
    content = File.read(file)
    next unless content.start_with?('---')

    if content =~ /\A---\s*\n(.*?)\n---\s*/m
      fm_content = Regexp.last_match(1)
      begin
        data = YAML.safe_load(fm_content, permitted_classes: [Date], permitted_symbols: [], aliases: true) || {}
      rescue Psych::Exception => e
        warn "Skipping #{file}: #{e.message}"
        next
      end

      image_paths = extract_image_paths(data)
      image_paths.each do |path|
        next if path.start_with?('http://', 'https://')
        normalized = path.sub(%r{^/}, '')
        absolute = File.expand_path(normalized, ROOT)
        unless File.exist?(absolute)
          (missing[file] ||= []) << path
        end
      end
    end
  end
end

if missing.empty?
  puts 'All referenced assets exist.'
else
  warn 'Missing assets:'
  missing.each do |file, paths|
    paths.each { |p| warn "  #{file}: #{p}" }
  end
  exit 1
end
