# frozen_string_literal: true
require "json"
require "fileutils"
require "set"

class BidirectionalLinksGenerator < Jekyll::Generator
  def generate(site)
    graph_nodes = []
    graph_edges = []
    edge_set = Set.new

    notes_coll = site.collections ? site.collections["notes"] : nil
    all_notes  = notes_coll&.docs || []
    all_pages  = site.pages || []
    all_docs   = all_notes + all_pages

    link_extension = site.config["use_html_extension"] ? ".html" : ""

    note_ids = {}
    all_notes.each do |note|
      nid = note_id_from_note(note)
      note_ids[note] = nid unless nid.nil?
    end

    backlinks_by_target = Hash.new { |h, k| h[k] = Set.new }

    # Convert [[Wiki-style]] links to <a> with class="internal-link"
    all_docs.each do |current_note|
      original_content = current_note.content.to_s.dup
      source_is_note = all_notes.include?(current_note)

      all_docs.each do |note_potentially_linked_to|
        # filename (without ext) pattern: allow "_" or "-" to be typed as space too
        base = File.basename(
          note_potentially_linked_to.basename,
          File.extname(note_potentially_linked_to.basename)
        )
        base_rx = Regexp.escape(base).gsub('\_', '[ _]').gsub('\-', '[ -]')

        # title pattern (if present)
        title_from_data = note_potentially_linked_to.data["title"]
        note_title_regexp_pattern =
          if title_from_data && !title_from_data.to_s.strip.empty?
            Regexp.escape(title_from_data.to_s)
          else
            nil
          end

        # alias patterns (if present) — support [[alias]] and [[alias|label]]
        raw_aliases = note_potentially_linked_to.data["aliases"]
        aliases_arr =
          case raw_aliases
          when String then [raw_aliases]
          when Array then raw_aliases.compact.map(&:to_s)
          else []
          end

        new_href   = "#{site.baseurl}#{note_potentially_linked_to.url}#{link_extension}"
        anchor_tag = "<a class='internal-link' href='#{new_href}'>\\1</a>"

        if source_is_note && all_notes.include?(note_potentially_linked_to) && current_note != note_potentially_linked_to
          sid = note_ids[current_note]
          tid = note_ids[note_potentially_linked_to]
          if sid && tid
            matched = false
            matched ||= original_content.match?(/\[\[(?:#{base_rx})(?:\|.+?)?\]\]/i)
            if !matched && note_title_regexp_pattern
              matched ||= original_content.match?(/\[\[(?:#{note_title_regexp_pattern})(?:\|.+?)?\]\]/i)
            end
            if !matched && !aliases_arr.empty?
              aliases_arr.each do |al|
                next if al.to_s.strip.empty?
                al_rx = Regexp.escape(al.to_s).gsub('\_', '[ _]').gsub('\-', '[ -]')
                if original_content.match?(/\[\[(?:#{al_rx})(?:\|.+?)?\]\]/i)
                  matched = true
                  break
                end
              end
            end

            if matched
              key = "#{sid}->#{tid}"
              unless edge_set.include?(key)
                graph_edges << { source: sid, target: tid }
                edge_set.add(key)
              end
              backlinks_by_target[tid].add(sid)
            end
          end
        end

        # [[filename|label]]
        current_note.content.gsub!(
          /\[\[(?:#{base_rx})\|(.+?)(?=\])\]\]/i,
          anchor_tag
        )

        # [[title|label]]
        if note_title_regexp_pattern
          current_note.content.gsub!(
            /\[\[(?:#{note_title_regexp_pattern})\|(.+?)(?=\])\]\]/i,
            anchor_tag
          )
        end

        # [[title]]
        if note_title_regexp_pattern
          current_note.content.gsub!(
            /\[\[(#{note_title_regexp_pattern})\]\]/i,
            anchor_tag
          )
        end

        # [[alias|label]] and [[alias]]
        aliases_arr.each do |al|
          next if al.to_s.strip.empty?
          al_rx = Regexp.escape(al.to_s).gsub('\_', '[ _]').gsub('\-', '[ -]')
          current_note.content.gsub!(
            /\[\[(?:#{al_rx})\|(.+?)(?=\])\]\]/i,
            anchor_tag
          )
          current_note.content.gsub!(
            /\[\[(#{al_rx})\]\]/i,
            anchor_tag
          )
        end

        # [[filename]]
        current_note.content.gsub!(
          /\[\[(#{base_rx})\]\]/i,
          anchor_tag
        )
      end

      # Remaining [[...]] → invalid-link spans
      current_note.content = current_note.content.gsub(
        /\[\[([^\]]+)\]\]/i,
        <<~HTML.delete("\n")
          <span title='Coming Soon™' class='invalid-link'>\\1</span>
        HTML
      )
    end

    # Backlinks + graph
    all_notes.each do |current_note|
      nid = note_id_from_note(current_note)

      unless current_note.path.to_s.include?("_notes/index.html") || nid.nil?
        label = current_note.data["title"]
        label = current_note.data["batch"] if label.nil? || label.to_s.strip.empty?
        label = current_note.data["slug"]  if label.nil? || label.to_s.strip.empty?
        label = current_note.basename_without_ext if label.nil? || label.to_s.strip.empty?

        # Derive a simple category from the note path: first folder under _notes/
        # Example: _notes/notes/rockhounding/rocks/foo.md => "rockhounding"
        category = begin
          path = current_note.path.to_s
          if path.include?("_notes/")
            after = path.split("_notes/", 2)[1]
            seg = after&.split("/", 2)&.first
            seg && !seg.empty? ? seg : "uncategorized"
          else
            "uncategorized"
          end
        rescue
          "uncategorized"
        end

        # Detect rock class (igneous/sedimentary/metamorphic) from path under rockhounding/rocks
        rock_class = begin
          m = current_note.path.to_s.match(%r{/rocks/(?:category/)?(igneous|sedimentary|metamorphic)(?:/|\.md)})
          m ? m[1] : nil
        rescue
          nil
        end

        graph_nodes << {
          id:   nid,
          path: "#{site.baseurl}#{current_note.url}#{link_extension}",
          label: label,
          category: category,
          rock_class: rock_class,
          layout: current_note.data["layout"],
          date: current_note.data["date"]&.to_s
        }

      end

      source_ids = backlinks_by_target[nid] || Set.new
      current_note.data["backlinks"] = source_ids.map { |sid| all_notes.find { |n| note_ids[n] == sid } }.compact
    end

    # Auto-link notes to their parent folder index page (if that page exists as a node).
    # This reduces standalone nodes in the graph.
    url_to_id = {}
    graph_nodes.each do |node|
      next unless node[:path]
      url_to_id[node[:path]] = node[:id]
    end

    graph_nodes.each do |node|
      next unless node[:path]
      path = node[:path]
      next if path == "/" || path.count("/") < 2
      parent = path.sub(%r{[^/]+/?$}, "")
      parent = "/" if parent.empty?
      parent_id = url_to_id[parent]
      next if parent_id.nil?
      key = "#{node[:id]}->#{parent_id}"
      next if edge_set.include?(key)
      graph_edges << { source: node[:id], target: parent_id }
      edge_set.add(key)
    end

    FileUtils.mkdir_p("_includes")
    File.write("_includes/notes_graph.json", JSON.dump({ edges: graph_edges, nodes: graph_nodes }))
  end

  def note_id_from_note(note)
    # Prefer explicit title; fall back to batch/slug/filename
    title = note.data["title"]
    title = note.data["batch"] if title.nil? || title.to_s.strip.empty?
    title = note.data["slug"]  if title.nil? || title.to_s.strip.empty?
    title = note.basename_without_ext if title.nil? || title.to_s.strip.empty?

    return nil if title.nil? || title.to_s.strip.empty?
    title.to_s.bytes.join
  end
end
