require 'open-uri'
require 'rexml/document'
require 'digest'
require 'fileutils'
require 'pathname'

# Fetches Goodreads shelf RSS feeds at build time and exposes them via site.data
class GoodreadsShelfGenerator < Jekyll::Generator
  safe true
  priority :low

  def generate(site)
    cfg = site.config.fetch('goodreads', {})
    shelves = cfg.fetch('shelves', [])
    return if shelves.empty?

    cache_dir = cfg.fetch('cache_dir', '.jekyll-cache/goodreads')
    cache_ttl = cfg.fetch('cache_ttl', 6 * 60 * 60).to_i
    cache_ttl = 0 if cache_ttl.negative?

    site.data['goodreads'] ||= {}

    shelves.each do |shelf|
      name = shelf['name'] || 'default'
      url  = shelf['rss']
      next unless url && !url.empty?

      begin
        cache_path = cache_file_path(site, cache_dir, url)
        xml = fetch_xml(url, cache_path, cache_ttl)
        if xml.nil? || xml.strip.empty?
          Jekyll.logger.warn("Goodreads:", "Empty feed for '#{name}' shelf")
          site.data['goodreads'][name] ||= []
          next
        end
        items = parse_items(xml)
        site.data['goodreads'][name] = items
        Jekyll.logger.info("Goodreads:", "Loaded #{items.length} items for '#{name}' shelf")
      rescue StandardError => e
        Jekyll.logger.warn("Goodreads:", "Failed to load '#{name}' shelf: #{e.class} #{e.message}")
        site.data['goodreads'][name] ||= []
      end
    end
  end

  private

  def text_of(el)
    el&.text&.to_s&.strip
  end

  def cache_file_path(site, cache_dir, url)
    dir = if Pathname.new(cache_dir).absolute?
            cache_dir
          else
            File.join(site.source, cache_dir)
          end
    File.join(dir, "#{Digest::SHA256.hexdigest(url)}.xml")
  end

  def read_cache(path, ttl)
    return nil unless File.exist?(path)
    return nil if ttl.positive? && (Time.now - File.mtime(path)) > ttl

    File.read(path)
  end

  def fetch_xml(url, cache_path, ttl)
    cached = read_cache(cache_path, ttl)
    return cached if cached

    xml = URI.open(url, read_timeout: 15).read
    FileUtils.mkdir_p(File.dirname(cache_path))
    File.write(cache_path, xml)
    xml
  rescue StandardError => e
    return nil unless File.exist?(cache_path)

    Jekyll.logger.warn("Goodreads:", "Fetch failed, using stale cache: #{e.class} #{e.message}")
    File.read(cache_path)
  end

  def text_at(item, path)
    text_of(REXML::XPath.first(item, path))
  end

  def parse_items(xml)
    doc = REXML::Document.new(xml)
    items = []
    REXML::XPath.each(doc, '/rss/channel/item') do |item|
      title  = text_at(item, 'title')
      guid   = text_at(item, 'guid')
      link   = text_at(item, 'link')
      author = text_at(item, 'author_name') || text_at(item, 'book_author')
      book_id = text_at(item, 'book_id')
      pub_date = text_at(item, 'pubDate')
      avg = text_at(item, 'average_rating')
      my  = text_at(item, 'user_rating')
      shelves = text_at(item, 'user_shelves')
      desc_html = text_at(item, 'book_description')

      img_small = text_at(item, 'book_small_image_url')
      img_med   = text_at(item, 'book_medium_image_url') || text_at(item, 'book_image_url')
      img_large = text_at(item, 'book_large_image_url') || img_med || img_small

      items << {
        'guid' => guid,
        'book_id' => book_id,
        'title' => title,
        'author' => author,
        'link' => link,
        'pub_date' => pub_date,
        'average_rating' => (avg && avg != '0') ? avg.to_f : nil,
        'my_rating' => (my && my != '0') ? my.to_i : nil,
        'shelves' => shelves,
        'description_html' => desc_html,
        'image' => {
          'small' => img_small,
          'medium' => img_med,
          'large' => img_large
        }
      }
    end
    items
  end
end
