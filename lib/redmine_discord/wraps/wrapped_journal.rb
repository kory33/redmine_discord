require_relative '../embed_objects/embed_field'

module RedmineDiscord
  class Wraps::WrappedJournal
    def initialize(journal)
      @journal = journal
    end

    def to_notes_field
      notes = @journal.notes

      if notes.present?
        block_notes = "```#{notes.to_s.gsub(/`/, "\u200b`")}```"
        EmbedObjects::EmbedField.new('Notes', block_notes, false).to_hash
      end
    end

    def to_editor_field
      EmbedObjects::EmbedField.new('Edited by', "`#{@journal.event_author}`", false).to_hash
    end
  end
end
