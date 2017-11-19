require_relative '../wraps/wrapped_issue'

module RedmineDiscord
    class NewIssueEmbed
        def initialize(context)
            @context = context
            @controller = context[:controller]
            @issue = context[:issue]
            @wrapped_issue = WrappedIssue.new @issue
        end

        def to_embed_array
            heading_fields = [
                @wrapped_issue.to_author_field,
                @wrapped_issue.to_assignee_field,
                @wrapped_issue.to_due_date_field,
                @wrapped_issue.to_estimated_hours_field,
                @wrapped_issue.to_priority_field
            ].select {|field| field != nil}

            return [
                {
                    'title' => get_heading_title,
                    'color' => get_fields_color,
                    'fields' => heading_fields
                }
            ]
        end
    
    private
        def get_fields_color
            return 65280
        end

        def get_heading_title
            return "[New issue] #{@issue.project.name} - #{@issue.tracker} ##{@issue.id}: #{@issue.subject}"
        end
    end
end    