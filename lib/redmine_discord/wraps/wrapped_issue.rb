module RedmineDiscord
    class WrappedIssue
        def initialize(issue)
            @issue = issue
        end

        def to_author_field
            # 例外をつぶしていたのを削除
            # nil 参照防止？
            # ぼっち演算子で対応
            return {
                'name' => 'Author',
                'value' => "#{@issue&.author&.firstname} #{@issue&.author&.lastname}",
                'inline' => true
            }
        end

        def to_assignee_field
            return {
                'name' => 'Assignee',
                'value' => "#{@issue&.assigned_to&.firstname} #{@issue&.assigned_to&.lastname}",
                'inline' => true
            }
        end

        def to_due_date_field
            # if 式で対応
            # then がなければ if 式は nil を返すので
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
            # rails 前提であれば #present? で代替可能（多分
            # https://qiita.com/somewhatgood@github/items/b74107480ee3821784e6
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
