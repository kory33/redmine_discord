module RedmineDiscord
  class EmbedObjects::EmbedField
    def initialize(name, value, inline)
      @name = name
      @value = value
      @inline = inline
    end

    def to_hash
      {
          name: @name,
          value: @value,
          inline: @inline
      }
    end
  end
end