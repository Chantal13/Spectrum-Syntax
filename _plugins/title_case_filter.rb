# frozen_string_literal: true

module Jekyll
  module TitleCaseFilter
    SMALL_WORDS = %w[a an and as at but by for if in of on or the to vs v via].freeze

    def title_case(input)
      return input if input.nil?
      str = input.to_s.tr('_', ' ').tr('-', ' ').strip
      words = str.split(/(\s+)/) # keep spaces as tokens to preserve spacing
      words.map!.with_index do |tok, idx|
        # leave whitespace tokens untouched
        next tok if tok =~ /^\s+$/

        w = tok.downcase
        if idx > 0 && idx < words.length - 1 && SMALL_WORDS.include?(w)
          w
        else
          # capitalize first character, keep rest as-is lowercased
          w[0] ? w[0].upcase + w[1..] : w
        end
      end
      words.join
    rescue
      input
    end
  end
end

Liquid::Template.register_filter(Jekyll::TitleCaseFilter)

