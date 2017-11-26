require_relative '../wraps/wrapped_wiki_page'

module RedmineDiscord
  class WikiEditEmbed
    def initialize(context)
      @wrapped_page = WrappedWikiPage.new context[:page]
    end

    def to_embed_array
      [{
           url: @wrapped_page.resolve_absolute_url,
           title: "#{get_title_tag} #{@wrapped_page.to_heading_title}",
           color: get_fields_color,
           fields: [
               @wrapped_page.to_author_field
           ]
       }]
    end

    def get_title_tag
      '[Wiki update]'
    end

    def get_fields_color
      # 0000ff
      255
    end
  end
end