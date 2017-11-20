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
            }
        end

        def to_assignee_field
            if @issue.assigned_to.present?
                return {
                    'name' => 'Assignee',
                    'value' => "#{@issue.assigned_to.firstname} #{@issue.assigned_to.lastname}",
                    'inline' => true
                }
            end
        end

        def to_due_date_field
            if @issue.due_date
                return {
                    'name' => 'Due Date',
                    'value' => @issue.due_date.to_s,
                    'inline' => true
                }
            end
        end

        def to_estimated_hours_field
            if @issue.estimated_hours
                return {
                    'name' => 'Estimated Hours',
                    'value' => @issue.estimated_hours.to_s,
                    'inline' => true
                }
            end
        end

        def to_priority_field
            return {
                'name' => 'Priority',
                'value' => @issue.priority.name,
                'inline' => true
            }
        end

        def to_heading_title
            return "#{@issue.project.name} - #{@issue.tracker} ##{@issue.id}: #{@issue.subject}"
        end

        def to_description_field
            if @issue.description.present?
                return {
                    'name' => 'Description',
                    'value' => @issue.description,
                    'inline' => false
                }
            end
        end

        def resolve_absolute_url()
            host = Setting.host_name.to_s.chomp('/')
            protocol = Setting.protocol

            return "#{protocol}://#{host}/issues/#{@issue.id}"
        end
    end
end
