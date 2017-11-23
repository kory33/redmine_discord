require_relative '../embed_objects/embed_field'

module RedmineDiscord
  class WrappedJournal
    def initialize(journal)
      @journal = journal
    end

    def to_notes_field
      notes = @journal.notes

      if notes.present?
        EmbedField.new('Notes', notes, false).to_hash
      end
    end
  end
end
