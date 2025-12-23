# frozen_string_literal: true

Jekyll::Hooks.register [:notes], :pre_render do |doc|
  path = doc.path.to_s
  next unless path.include?("_notes/notes/rockhounding/rocks/")

  content = doc.content.to_s

  # Compute parent title/url heuristically from path
  parent_title = nil
  parent_url   = nil

  if path.include?('/rocks/igneous/')
    parent_title = 'Igneous Rocks'
    parent_url   = '/rockhounding/rocks/igneous/'
  elsif path.include?('/rocks/metamorphic/')
    parent_title = 'Metamorphic Rocks'
    parent_url   = '/rockhounding/rocks/metamorphic/'
  elsif path.include?('/rocks/sedimentary/')
    parent_title = 'Sedimentary Rocks'
    parent_url   = '/rockhounding/rocks/sedimentary/'
  elsif path.include?('/rocks/minerals/')
    # Minerals: if nested under a base mineral folder, use that; else use Rocks & Minerals index
    rel = path.split('/rocks/minerals/', 2)[1]
    if rel && rel.include?('/')
      base = rel.split('/', 2)[0]
      parent_title = base.tr('-', ' ').split.map(&:capitalize).join(' ')
      parent_url   = "/rockhounding/rocks/minerals/#{base}/"
    else
      parent_title = 'Rocks & Minerals'
      parent_url   = '/rockhounding/rocks/'
    end
  end

  # Inject Parent: [[...]] line if missing
  if parent_title && !content.include?('Parent: [[')
    # place after first plain-text summary line following rock-card include
    inc_idx = content.index('{% include rock-card.html rock=page %}')
    if inc_idx
      line_start = content.index("\n", inc_idx)
      if line_start
        tail = content[line_start+1..-1]
        lines = tail.lines
        i = 0
        # skip blank lines
        i += 1 while i < lines.length && lines[i].strip.empty?
        # skip Liquid/HTML/meta lines
        def plain_text?(s)
          s2 = s.lstrip
          return false if s2.start_with?('{%', '{{', '{-', '<')
          return true
        end
        i += 1 while i < lines.length && !plain_text?(lines[i])
        # if none found, fall back to first non-empty (single adjustment)
        i = 0 if i >= lines.length
        # compute insertion point and ensure blank lines around
        insert_at = content.length - tail.length + lines[0...i+1].join.length
        insertion = "\n\nParent: [[#{parent_title}]]\n\n"
        content = content.dup.insert(insert_at, insertion)
      end
    end
  end

  # Ensure parent metadata present for breadcrumbs (do not overwrite explicit)
  data = doc.data
  data['parent_title'] ||= parent_title if parent_title
  data['parent_url']   ||= parent_url   if parent_url

  # Add a lightweight Related: list if missing (first few siblings in folder)
  if !content.include?('Related: [[')
    primary_dir = begin
      if path.include?('/rocks/minerals/')
        sub = path.split('/rocks/minerals/', 2)[1]
        if sub && sub.include?('/')
          File.dirname(path) + '/'
        else
          File.join(doc.site.source, '_notes/notes/rockhounding/rocks/minerals/', File.basename(path, '.*'), '/')
        end
      elsif path.include?('/rocks/igneous/')
        File.join(doc.site.source, '_notes/notes/rockhounding/rocks/igneous/')
      elsif path.include?('/rocks/metamorphic/')
        File.join(doc.site.source, '_notes/notes/rockhounding/rocks/metamorphic/')
      elsif path.include?('/rocks/sedimentary/')
        File.join(doc.site.source, '_notes/notes/rockhounding/rocks/sedimentary/')
      else
        File.dirname(path) + '/'
      end
    end

    siblings = (doc.site.collections['notes']&.docs || []).select do |n|
      n.path != path && n.path.start_with?(primary_dir) && File.basename(n.path) != 'index.md'
    end
    titles = siblings.sort_by { |n| (n.data['title'] || n.basename_without_ext).to_s.downcase }
                     .first(4)
                     .map { |n| n.data['title'] || n.basename_without_ext }
    if !titles.empty?
      content = content.rstrip + "\n\nRelated: " + titles.map { |t| "[[#{t}]]" }.join(', ') + "\n\n"
    end
  end

  doc.content = content
end
