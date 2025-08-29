# frozen_string_literal: true
require "json"
require "fileutils"

class BidirectionalLinksGenerator < Jekyll::Generator
  def generate(site)
    graph_nodes = []
    graph_edges = []

    notes_coll = site.collections ? site.collections["notes"] : nil
    all_notes  = notes_coll&.docs || []
    all_pages  = site.pages || []
    all_docs   = all_notes + all_pages

    link_extension = site.config["use_html_extension"] ? ".html" : ""

    # Convert [[Wiki-style]] links to <a> with class="internal-link"
    all_docs.each do |current_note|
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

        new_href   = "#{site.baseurl}#{note_potentially_linked_to.url}#{link_extension}"
        anchor_tag = "<a class='internal-link' href='#{new_href}'>\\1</a>"

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
          <span title='Coming Soon™' class='invalid-link'>
            <span class='invalid-link-brackets'>[[</span>
            \\1
            <span class='invalid-link-brackets'>]]</span>
          </span>
        HTML
      )
    end

    # Backlinks + graph
    all_notes.each do |current_note|
      notes_linking_to_current_note = all_notes.filter do |e|
        e.url != current_note.url && e.content.include?(current_note.url)
      end

      nid = note_id_from_note(current_note)

      unless current_note.path.to_s.include?("_notes/index.html") || nid.nil?
        label = current_note.data["title"]
        label = current_note.data["batch"] if label.nil? || label.to_s.strip.empty?
        label = current_note.data["slug"]  if label.nil? || label.to_s.strip.empty?
        label = current_note.basename_without_ext if label.nil? || label.to_s.strip.empty?

        graph_nodes << {
          id:   nid,
          path: "#{site.baseurl}#{current_note.url}#{link_extension}",
          label: label
        }
      end

      current_note.data["backlinks"] = notes_linking_to_current_note

      notes_linking_to_current_note.each do |n|
        sid = note_id_from_note(n)
        tid = nid
        next if sid.nil? || tid.nil?
        graph_edges << { source: sid, target: tid }
      end
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
