module RedmineDiscord
  class WrappedJournal
    def initialize(journal)
      @journal = journal
    end

    def to_notes_field
      notes = @journal.notes

      if notes.present?
        return {
          'name' => 'Notes',
          'value' => notes,
          'inline' => false
        }
      end
    end
  end
end
