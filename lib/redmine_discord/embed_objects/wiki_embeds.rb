require_relative 'field_helper'
require_relative '../wraps/wrapped_wiki_page'

module RedmineDiscord
  module EmbedObjects::WikiEmbeds
    class WikiEditEmbed
      def initialize(context)
        @wrapped_page = Wraps::WrappedWikiPage.new context[:page]
      end

      def to_embed_array
        [{
            url: @wrapped_page.resolve_absolute_url,
            title: "#{get_title_tag} #{@wrapped_page.to_heading_title}",
            color: get_fields_color,
            fields: get_embed_fields
        }]
      end

      def get_title_tag
        '[Wiki update]'
      end

      def get_fields_color
        # 0000ff
        255
      end

      def get_embed_fields
        [@wrapped_page.to_author_field]
      end
    end

    class WikiNewEmbed < WikiEditEmbed
      def get_title_tag
        '[New wiki page]'
      end

      def get_fields_color
        # 00ffff
        65535
      end

      def get_embed_fields
        [
            @wrapped_page.to_author_field,
            EmbedObjects::FieldHelper::get_separator_field,
            @wrapped_page.to_text_field
        ]
      end
    end
  end
end