module RedmineDiscord
    class WrappedJournal
        def initialize(journal)
            @journal = journal
        end

        def to_notes_field
            notes = @journal.notes
            if notes == nil || notes == "" then
                return nil
            end

            return {
                'name' => 'Notes',
                'value' => notes,
                'inline' => false
            }
        end
    end
end    