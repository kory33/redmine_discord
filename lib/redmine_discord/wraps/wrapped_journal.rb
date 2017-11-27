require_relative '../embed_objects/embed_field'

module RedmineDiscord
  class WrappedJournal
    def initialize(journal)
      @journal = journal
    end

    def to_notes_field
      notes = @journal.notes

      if notes.present?
        block_notes = "```#{notes.to_s.gsub(/`/, "\u200b`")}```"
        EmbedField.new('Notes', block_notes, false).to_hash
      end
    end
  end
end
