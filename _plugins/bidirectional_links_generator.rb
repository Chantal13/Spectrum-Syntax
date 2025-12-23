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

    link_candidates = {}

    all_docs.each do |doc|
      base = File.basename(doc.basename, File.extname(doc.basename))
      title_from_data = doc.data["title"]
      raw_aliases = doc.data["aliases"]
      aliases_arr =
        case raw_aliases
        when String then [raw_aliases]
        when Array then raw_aliases.compact.map(&:to_s)
        else []
        end

      candidates = [{ value: base, flexible: true }]
      candidates << { value: title_from_data, flexible: false } if title_from_data && !title_from_data.to_s.strip.empty?
      candidates.concat(aliases_arr.map { |al| { value: al, flexible: true } })

      candidates.each do |candidate|
        normalized = normalize_link_text(candidate[:value])
        next if normalized.empty? || link_candidates.key?(normalized)

        link_candidates[normalized] = {
          href: "#{site.baseurl}#{doc.url}#{link_extension}",
          target_id: note_ids[doc],
          pattern: candidate_pattern(candidate[:value], flexible: candidate[:flexible])
        }
      end
    end

    pattern_union = link_candidates.values.map { |data| "(?:#{data[:pattern]})" }.join("|")
    combined_regex = pattern_union.empty? ? nil : /\[\[(#{pattern_union})(?:\|([^\]]+?))?\]\]/i

    # Convert [[Wiki-style]] links to <a> with class="internal-link"
    all_docs.each do |current_note|
      source_is_note = all_notes.include?(current_note)
      matched_targets = Set.new

      if combined_regex
        current_note.content = current_note.content.to_s.gsub(combined_regex) do
          matched_text = Regexp.last_match(1)
          label = Regexp.last_match(2) || matched_text
          target = link_candidates[normalize_link_text(matched_text)]

          matched_targets.add(target[:target_id]) if target && target[:target_id]
          "<a class='internal-link' href='#{target[:href]}'>#{label}</a>"
        end
      end

      if source_is_note
        sid = note_ids[current_note]
        matched_targets.each do |tid|
          next if tid.nil? || sid.nil? || tid == sid

          key = "#{sid}->#{tid}"
          unless edge_set.include?(key)
            graph_edges << { source: sid, target: tid }
            edge_set.add(key)
          end
          backlinks_by_target[tid].add(sid)
        end
      end

      # Remaining [[...]] → invalid-link spans
      current_note.content = current_note.content.gsub(/\[\[([^\]]+)\]\]/i) do
        "<span title='Coming Soon™' class='invalid-link'>#{Regexp.last_match(1)}</span>"
      end
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

    graph_path = site.config["notes_graph_path"] || "_includes/notes_graph.json"
    source_root = site.respond_to?(:source) && site.source ? site.source : Dir.pwd
    graph_abs = graph_path.start_with?("/") ? graph_path : File.expand_path(graph_path, source_root)

    FileUtils.mkdir_p(File.dirname(graph_abs))
    File.write(graph_abs, JSON.dump({ edges: graph_edges, nodes: graph_nodes }))
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

  private

  def normalize_link_text(text)
    text.to_s.downcase.gsub(/[ _-]+/, " ").strip
  end

  def candidate_pattern(text, flexible: false)
    pattern = Regexp.escape(text.to_s)
    return pattern unless flexible

    pattern.gsub("\\_", "[ _]").gsub("\\-", "[ -]")
  end
end
