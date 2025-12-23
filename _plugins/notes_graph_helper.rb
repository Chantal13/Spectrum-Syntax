require "set"

module Jekyll
  module NotesGraphHelper
    def build_note_tag_graph(docs, max_tags = nil)
      site = @context.registers[:site]
      tags_root = relative_path("/tags/", site)

      tag_nodes = {}
      note_nodes = {}
      tag_edges = Set.new
      note_edges = Set.new

      Array(docs).each do |doc|
        next unless doc.respond_to?(:url)

        note_id = Jekyll::Utils.slugify(doc.url.to_s)
        note_nodes[note_id] ||= {
          "id" => "note-#{note_id}",
          "label" => doc.data["title"] || doc.basename_without_ext,
          "path" => relative_path(doc.url, site),
          "type" => "note"
        }

        Array(doc.data["tags"]).compact.each do |tag|
          tag_name = tag.to_s.downcase
          parent = nil

          parts = tag_name.split("/")
          tag_root = parts.first

          parts.each do |part|
            current = parent ? "#{parent}/#{part}" : part
            slug = Jekyll::Utils.slugify(current)

            node = tag_nodes[slug] ||= {
              "slug" => slug,
              "id" => "tag-#{slug}",
              "label" => "##{part}",
              "full_label" => current,
              "root" => tag_root,
              "count" => 0,
              "path" => "#{tags_root}##{slug}",
              "type" => "tag"
            }
            node["count"] += 1

            if parent
              parent_slug = Jekyll::Utils.slugify(parent)
              tag_edges << [parent_slug, slug]
            end

            parent = current
          end

          tag_slug = Jekyll::Utils.slugify(tag_name)
          note_edges << [tag_slug, note_id]
        end
      end

      max_tag_count = max_tags.to_i
      max_tag_count = nil if max_tag_count <= 0

      sorted_tags = tag_nodes.values.sort_by { |node| [-node["count"], node["label"].downcase] }
      sorted_tags = sorted_tags.first(max_tag_count) if max_tag_count

      allowed_slugs = sorted_tags.map { |node| node["slug"] }.to_set

      filtered_tag_edges = tag_edges
                           .select { |parent, child| allowed_slugs.include?(parent) && allowed_slugs.include?(child) }
                           .map { |parent, child| { source: "tag-#{parent}", target: "tag-#{child}" } }

      filtered_note_edges = note_edges
                            .select { |tag, _| allowed_slugs.include?(tag) }
                            .map { |tag, note_id| { source: "tag-#{tag}", target: "note-#{note_id}" } }

      {
        "tag_nodes" => sorted_tags,
        "note_nodes" => note_nodes.values,
        "tag_edges" => filtered_tag_edges,
        "note_edges" => filtered_note_edges
      }
    end

    private

    def relative_path(path, site)
      normalized = path.to_s
      normalized = "/#{normalized}" unless normalized.start_with?("/")
      "#{site.config["baseurl"]}#{normalized}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::NotesGraphHelper)
