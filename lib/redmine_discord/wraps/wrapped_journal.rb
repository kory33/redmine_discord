module RedmineDiscord
    class WrappedJournal
        def initialize(journal)
            @journal = journal
        end

        def to_notes_field
            notes = @journal.notes
            # then は必要がないので削除
            # rails 前提であれば #present? で代替可能（多分
            # https://qiita.com/somewhatgood@github/items/b74107480ee3821784e6
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
