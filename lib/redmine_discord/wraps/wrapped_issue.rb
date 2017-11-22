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

        def get_separator_field
            return {
                'name' => '---------------------------',
                'value' => "\u200b",
                'inline' => false
            }
        end

        def to_diff_fields
            attribute_diffs = @issue.attributes.keys.map {|attrib_key|
                get_diff attrib_key
            }.compact

            return attribute_diffs.map {|attribute|
                {
                    name: attribute[:name],
                    value: "`#{attribute[:old_value]}` => `#{attribute[:new_value]}`",
                    inline: true
                }
            }
        end

    private
        def get_diff(attribute_name)
            attribute_root_name = attribute_name.chomp('_id')

            new_value, old_value =
                if attribute_name == attribute_root_name
                    [@issue.send(attribute_name), @issue.send(attribute_name + '_was')]
                else
                    diff_for_id_attribute attribute_root_name
                end

            return {
                name: attribute_root_name,
                new_value: new_value || 'nil',
                old_value: old_value || 'nil'
            } unless new_value == old_value
        end

        def diff_for_id_attribute(attribute_root_name)
            if Issue.method_defined? "#{attribute_root_name}_was".to_sym
                return [@issue.send(attribute_root_name), @issue.send(attribute_root_name + '_was')]
            end

            puts "unknown attribute name given : #{attribute_root_name}"
            [nil, nil]
        end
    end
end
