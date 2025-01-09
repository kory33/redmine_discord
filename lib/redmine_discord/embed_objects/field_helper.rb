require_relative 'embed_field'

module RedmineDiscord
  module EmbedObjects::FieldHelper
    def self.get_separator_field
      EmbedObjects::EmbedField.new('---------------------------', "\u200b", false).to_hash
    end
  end
end