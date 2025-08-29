require 'minitest/autorun'
require 'ostruct'
require 'liquid'
require_relative '../_plugins/image_exists_filter'

class ImageExistsFilterTest < Minitest::Test

  def setup
    @filter = Object.new.extend(Jekyll::ImageExistsFilter)
    site = OpenStruct.new(source: File.expand_path('..', __dir__))
    context = OpenStruct.new(registers: { site: site })
    @filter.instance_variable_set(:@context, context)
  end

  def test_remote_url_is_returned
    url = 'https://example.com/image.jpg'
    assert_equal url, @filter.image_exists(url)
  end

  def test_missing_local_file_returns_nil
    path = '/assets/missing.jpg'
    assert_nil @filter.image_exists(path)
  end

  def test_existing_local_file_returns_same_path
    path = '/assets/image.jpg'
    assert_equal path, @filter.image_exists(path)
  end

  def test_html_tag_with_src_uses_path
    tag = { 'src' => '/assets/image.jpg' }
    assert_equal '/assets/image.jpg', @filter.image_exists(tag)
  end
end
