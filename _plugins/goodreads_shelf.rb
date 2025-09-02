require 'open-uri'
require 'rexml/document'

# Fetches Goodreads shelf RSS feeds at build time and exposes them via site.data
class GoodreadsShelfGenerator < Jekyll::Generator
  safe true
  priority :low

  def generate(site)
    cfg = site.config.fetch('goodreads', {})
    shelves = cfg.fetch('shelves', [])
    return if shelves.empty?

    site.data['goodreads'] ||= {}

    shelves.each do |shelf|
      name = shelf['name'] || 'default'
      url  = shelf['rss']
      next unless url && !url.empty?

      begin
        xml = URI.open(url, read_timeout: 15).read
        items = parse_items(xml)
        site.data['goodreads'][name] = items
        Jekyll.logger.info("Goodreads:", "Loaded #{items.length} items for '#{name}' shelf")
      rescue => e
        Jekyll.logger.warn("Goodreads:", "Failed to load '#{name}' shelf: #{e.class} #{e.message}")
        site.data['goodreads'][name] ||= []
      end
    end
  end

  private

  def text_of(el)
    el&.text&.to_s&.strip
  end

  def parse_items(xml)
    doc = REXML::Document.new(xml)
    items = []
    REXML::XPath.each(doc, '/rss/channel/item') do |item|
      def t(item, path)
        el = REXML::XPath.first(item, path)
        el&.text&.to_s&.strip
      end

      title  = t(item, 'title')
      guid   = t(item, 'guid')
      link   = t(item, 'link')
      author = t(item, 'author_name') || t(item, 'book_author')
      book_id = t(item, 'book_id')
      pub_date = t(item, 'pubDate')
      avg = t(item, 'average_rating')
      my  = t(item, 'user_rating')
      shelves = t(item, 'user_shelves')
      desc_html = t(item, 'book_description')

      img_small = t(item, 'book_small_image_url')
      img_med   = t(item, 'book_medium_image_url') || t(item, 'book_image_url')
      img_large = t(item, 'book_large_image_url') || img_med || img_small

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

