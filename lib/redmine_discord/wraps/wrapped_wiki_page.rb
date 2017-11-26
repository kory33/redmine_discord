require_relative '../embed_objects/issue_embeds'

module RedmineDiscord
  class WrappedWikiPage
    def initialize(wiki_page)
      @wiki_page = wiki_page
      @content = wiki_page.content
    end

    def resolve_absolute_url
      host = Setting.host_name.to_s.chomp('/')
      protocol = Setting.protocol

      "#{protocol}://#{host}/projects/#{@wiki_page.project}/wiki/#{@wiki_page.title}"
    end

    def to_heading_title
      "#{@wiki_page.project} - #{@wiki_page.title}"
    end

    def to_author_field
      EmbedField.new 'author', @content.author.to_s, true
    end
  end
end