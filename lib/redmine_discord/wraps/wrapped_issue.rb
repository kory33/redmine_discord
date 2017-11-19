module RedmineDiscord
    class WrappedIssue
        def initialize(issue)
            @issue = issue
        end

        def to_author_field
            return {
                'name' => 'Author',
                'value' => "#{@issue.author.firstname} #{@issue.author.lastname}",
                'inline' => true
            } rescue nil
        end

        def to_assignee_field
            return {
                'name' => 'Assignee',
                'value' => "#{@issue.assigned_to.firstname} #{@issue.assigned_to.lastname}",
                'inline' => true
            } rescue nil
        end

        def to_due_date_field
            return nil if @issue.due_date == nil
            return {
                'name' => 'Due Date',
                'value' => "#{@issue.due_date}",
                'inline' => true
            }
        end

        def to_estimated_hours_field
            return nil if @issue.estimated_hours == nil
            return {
                'name' => 'Estimated Hours',
                'value' => "#{@issue.estimated_hours}",
                'inline' => true
            }
        end

        def to_priority_field
            return {
                'name' => 'Priority',
                'value' => "#{@issue.priority.name}",
                'inline' => true
            }
        end

        def to_heading_title
            return "#{@issue.project.name} - #{@issue.tracker} ##{@issue.id}: #{@issue.subject}"
        end

        def to_description_field
            return nil if @issue.description == nil || @issue.description == ""

            return {
                'name' => 'Description',
                'value' => @issue.description,
                'inline' => false
            }
        end

        def resolve_absolute_url()
            host = Setting.host_name.to_s.chomp('/')
            protocol = Setting.protocol

            return "#{protocol}://#{host}/issues/#{@issue.id}"
        end
    end
end