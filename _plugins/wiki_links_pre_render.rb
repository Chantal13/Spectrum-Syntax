# frozen_string_literal: true

Jekyll::Hooks.register [:notes, :pages], :pre_render do |doc|
  site = doc.site
  all_notes  = site.collections && site.collections['notes'] ? site.collections['notes'].docs : []
  all_pages  = site.pages || []
  all_docs   = all_notes + all_pages

  link_extension = site.config['use_html_extension'] ? '.html' : ''

  all_docs.each do |target|
    base = File.basename(target.basename, File.extname(target.basename))
    base_rx = Regexp.escape(base).gsub('\_', '[ _]').gsub('\-', '[ -]')

    title = target.data['title']
    title_rx = title && !title.to_s.strip.empty? ? Regexp.escape(title.to_s) : nil

    raw_aliases = target.data['aliases']
    aliases = case raw_aliases
              when String then [raw_aliases]
              when Array then raw_aliases.compact.map(&:to_s)
              else []
              end

    href   = "#{site.baseurl}#{target.url}#{link_extension}"
    anchor = "<a class='internal-link' href='#{href}'>\\1</a>"

    # [[filename|label]]
    doc.content = doc.content.gsub(/\[\[(?:#{base_rx})\|(.+?)(?=\])\]\]/i, anchor)
    # [[title|label]]
    if title_rx
      doc.content = doc.content.gsub(/\[\[(?:#{title_rx})\|(.+?)(?=\])\]\]/i, anchor)
    end
    # [[title]]
    if title_rx
      doc.content = doc.content.gsub(/\[\[(#{title_rx})\]\]/i, anchor)
    end
    # [[alias|label]] and [[alias]]
    aliases.each do |al|
      next if al.to_s.strip.empty?
      al_rx = Regexp.escape(al.to_s).gsub('\_', '[ _]').gsub('\-', '[ -]')
      doc.content = doc.content.gsub(/\[\[(?:#{al_rx})\|(.+?)(?=\])\]\]/i, anchor)
      doc.content = doc.content.gsub(/\[\[(#{al_rx})\]\]/i, anchor)
    end
    # [[filename]]
    doc.content = doc.content.gsub(/\[\[(#{base_rx})\]\]/i, anchor)
  end

  # Any leftover unknown wikilinks -> invalid span (prevents raw markup leaking)
  doc.content = doc.content.gsub(/\[\[([^\]]+)\]\]/i, "<span title='Coming Soon™' class='invalid-link'>\\1<\/span>")
end
