# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "jekyll", "~> 4.4"

# Use the modern converter (3.x) and pin deps to stable builds
gem "jekyll-sass-converter", "~> 3.0"
gem "sass-embedded", "~> 1.71.1"
gem "google-protobuf", "~> 3.25.3"
gem "bigdecimal", "~> 3.1.8"
gem "jekyll-last-modified-at", "~> 1.3"
gem "webrick", "~> 1.9"
gem "nokogiri"
gem "json", ">= 2.9.2"

bundle lock --normalize-platforms
git add Gemfile.lock
git commit -m "Normalize platforms in Gemfile.lock"
