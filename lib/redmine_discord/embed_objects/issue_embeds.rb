module RedmineDiscord
    class NewIssueEmbed
        def initialize(context)
            @context = context
            @controller = context[:controller]
            @issue = context[:issue]
        end

        def to_embed_array
            heading_fields = [
                get_author_field,
                get_assignee_field,
                get_due_date_field,
                get_estimated_hours_field,
                get_priority_field
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
        def get_author_field
            return {
                'name' => 'Author',
                'value' => "#{@issue.author.firstname} #{@issue.author.lastname}",
                'inline' => true
            } rescue nil
        end

        def get_assignee_field
            return {
                'name' => 'Assignee',
                'value' => "#{@issue.assigned_to.firstname} #{@issue.assigned_to.lastname}",
                'inline' => true
            } rescue nil
        end

        def get_due_date_field
            return nil if @issue.due_date == nil
            return {
                'name' => 'Due Date',
                'value' => "#{@issue.due_date}",
                'inline' => true
            }
        end

        def get_estimated_hours_field
            return nil if @issue.estimated_hours == nil
            return {
                'name' => 'Estimated Hours',
                'value' => "#{@issue.estimated_hours}",
                'inline' => true
            }
        end

        def get_priority_field
            return {
                'name' => 'Priority',
                'value' => "#{@issue.priority.name}",
                'inline' => true
            }
        end

        def get_fields_color
            return 65280
        end

        def get_heading_title
            return "[New issue] #{@issue.project.name} - #{@issue.tracker} ##{@issue.id}: #{@issue.subject}"
        end
    end
end    