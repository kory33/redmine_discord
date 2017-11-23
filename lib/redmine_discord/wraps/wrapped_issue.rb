require_relative '../embed_objects/issue_embeds'

module RedmineDiscord
  class WrappedIssue
    def initialize(issue)
      @issue = issue
    end

    def to_author_field
      EmbedField.new('Author', "#{@issue.author.firstname} #{@issue.author.lastname}", true).to_hash
    end

    def to_assignee_field
      if @issue.assigned_to.present?
        EmbedField.new('Assignee',
                       "#{@issue.assigned_to.firstname} #{@issue.assigned_to.lastname}",
                       true).to_hash
      end
    end

    def to_due_date_field
      if @issue.due_date
        EmbedField.new('Due Date', @issue.due_date.to_s, true).to_hash
      end
    end

    def to_estimated_hours_field
      if @issue.estimated_hours
        EmbedField.new('Estimated Hours', @issue.estimated_hours.to_s, true).to_hash
      end
    end

    def to_priority_field
      EmbedField.new('Priority', @issue.priority.name, true).to_hash
    end

    def to_heading_title
      "#{@issue.project.name} - #{@issue.tracker} ##{@issue.id}: #{@issue.subject}"
    end

    def to_description_field
      if @issue.description.present?
        EmbedField.new('Description', @issue.description, false).to_hash
      end
    end

    def resolve_absolute_url
      url_of @issue.id
    end

    def get_separator_field
      EmbedField.new('---------------------------', "\u200b", false).to_hash
    end

    def to_diff_fields
      @issue.attributes.keys.map{|key| get_diff_field_for key}.compact
    end

    private

    def get_diff_field_for(attribute_name)
      new_value = value_for attribute_name
      old_value = old_value_for attribute_name

      attribute_root_name = attribute_name.chomp '_id'

      case attribute_root_name
        when 'description'
          # TODO implement diff for description
          nil
        when 'parent'
          new_value, old_value = [new_value, old_value].map do |issue|
            issue.blank? ? '`None`' : "[##{issue.id}](#{url_of issue.id})"
          end
          EmbedField.new(attribute_root_name, "#{old_value} => #{new_value}", true).to_hash
        else
          embed_value = "`#{old_value || 'None'}` => `#{new_value || 'None'}`"
          EmbedField.new(attribute_root_name, embed_value, true).to_hash
      end unless new_value == old_value
    end

    def value_for(attribute_name)
      if attribute_name == 'root_id'
        @issue.root_id
      else
        @issue.send attribute_name.chomp('_id')
      end
    end

    def old_value_for(attribute_name)
      attribute_root_name = attribute_name.chomp('_id')

      if attribute_root_name == attribute_name
        return @issue.send(attribute_name + '_was')
      end

      if Issue.method_defined? "#{attribute_root_name}_was".to_sym
        return @issue.send(attribute_root_name + '_was')
      end

      old_id = @issue.send(attribute_root_name + '_id_was')

      case attribute_root_name
        when 'project'
          Project.find(old_id)
        when 'category'
          IssueCategory.find(old_id)
        when 'priority'
          IssuePriority.find(old_id)
        when 'fixed_version'
          Version.find(old_id)
        when 'parent'
          Issue.find(old_id)
        when 'author'
          @issue.author
        when 'root'
          @issue.root_id
        else
          puts "unknown attribute name given : #{attribute_root_name}"
          @issue.send(attribute_root_name)
      end rescue nil
    end

    def url_of(issue_id)
      host = Setting.host_name.to_s.chomp('/')
      protocol = Setting.protocol

      "#{protocol}://#{host}/issues/#{issue_id}"
    end
  end
end
