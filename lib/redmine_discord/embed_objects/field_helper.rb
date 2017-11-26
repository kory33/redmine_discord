module RedmineDiscord
  def self.get_separator_field
    EmbedField.new('---------------------------', "\u200b", false).to_hash
  end
end