require 'minitest/autorun'
require 'json'
require 'ostruct'
require 'jekyll'
require_relative '../_plugins/bidirectional_links_generator'

class BidirectionalLinksGeneratorTest < Minitest::Test
  class FakeDoc
    attr_accessor :content
    attr_reader :basename, :url, :data, :path, :basename_without_ext

    def initialize(basename:, url:, content:, data:, path:)
      @basename = basename
      @url = url
      @content = content
      @data = data
      @path = path
      @basename_without_ext = File.basename(basename, File.extname(basename))
    end
  end

  def setup
    @generator = BidirectionalLinksGenerator.new
  end

  def test_replaces_links_and_generates_backlinks_for_aliases_and_titles
    alpha = build_doc(
      basename: 'alpha.md',
      url: '/alpha',
      content: 'Link to [[Beta Alias]] and [[Gamma Title|custom label]] plus [[Unknown Target]].',
      data: { 'title' => 'Alpha' }
    )

    beta = build_doc(
      basename: 'beta-file.md',
      url: '/beta',
      content: '',
      data: { 'title' => 'Beta File', 'aliases' => ['Beta Alias'] }
    )

    gamma = build_doc(
      basename: 'gamma.md',
      url: '/gamma',
      content: '',
      data: { 'title' => 'Gamma Title' }
    )

    site = OpenStruct.new(
      baseurl: '',
      config: {},
      pages: [],
      collections: { 'notes' => OpenStruct.new(docs: [alpha, beta, gamma]) }
    )

    @generator.generate(site)

    assert_includes alpha.content, "<a class='internal-link' href='/beta'>Beta Alias</a>"
    assert_includes alpha.content, "<a class='internal-link' href='/gamma'>custom label</a>"
    assert_includes alpha.content, "<span title='Coming Soon™' class='invalid-link'>Unknown Target</span>"

    assert_equal [alpha], beta.data['backlinks']
    assert_equal [alpha], gamma.data['backlinks']

    graph = JSON.parse(File.read('_includes/notes_graph.json'))
    alpha_id = @generator.note_id_from_note(alpha)
    beta_id = @generator.note_id_from_note(beta)
    gamma_id = @generator.note_id_from_note(gamma)

    assert_includes graph['edges'], { 'source' => alpha_id, 'target' => beta_id }
    assert_includes graph['edges'], { 'source' => alpha_id, 'target' => gamma_id }
  end

  private

  def build_doc(basename:, url:, content:, data: {}, path: nil)
    FakeDoc.new(
      basename: basename,
      url: url,
      content: content,
      data: data,
      path: path || "_notes/#{basename}"
    )
  end
end
