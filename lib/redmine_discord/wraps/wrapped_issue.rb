require_relative '../embed_objects/issue_embeds'

module RedmineDiscord
  class WrappedIssue
    def initialize(issue)
      @issue = issue
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

    def to_creation_information_fields
      display_attributes = ['author_id', 'assigned_to_id', 'priority_id', 'due_date',
                            'status_id', 'done_ratio', 'estimated_hours',
                            'category_id', 'fixed_version_id', 'parent_id']

      display_attributes.map {|attribute_name|
        value = value_for attribute_name rescue nil

        if attribute_name == 'parent_id'
          value = value.blank? ? nil : "[##{value.id}](#{url_of value.id})"
        else
          value = value.blank? ? nil : "`#{value}`"
        end

        EmbedField.new(attribute_name, value, true).to_hash if value
      }
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
            issue.blank? ? '`N/A`' : "[##{issue.id}](#{url_of issue.id})"
          end
          EmbedField.new(attribute_root_name, "#{old_value} => #{new_value}", true).to_hash
        else
          embed_value = "`#{old_value || 'N/A'}` => `#{new_value || 'N/A'}`"
          EmbedField.new(attribute_root_name, embed_value, true).to_hash
      end unless new_value == old_value
    end

    def value_for(attribute_name)
      if attribute_name == 'root_id'
        @issue.root_id
      elsif attribute_name == 'parent_id'
        Issue.find(@issue.parent_issue_id)
      else
        @issue.send attribute_name.chomp('_id')
      end
    end

    def old_value_for(attribute_name)
      attribute_root_name = attribute_name.chomp('_id')

      if attribute_root_name == attribute_name
        return @issue.send(attribute_name + '_was')
      end

      if attribute_root_name == 'assigned_to'
        return User.find(@issue.assigned_to_id_was) rescue nil
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

  def self.get_separator_field
    EmbedField.new('---------------------------', "\u200b", false).to_hash
  end
end
