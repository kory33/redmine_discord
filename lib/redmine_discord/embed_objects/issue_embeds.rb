require_relative '../wraps/wrapped_issue'
require_relative '../wraps/wrapped_journal'

module RedmineDiscord
    class NewIssueEmbed
        def initialize(context)
            @wrapped_issue = WrappedIssue.new context[:issue]
        end

        def to_embed_array
            # prepare fields in heading
			# #compact で nil 要素を削除
            fields = [
                @wrapped_issue.to_author_field,
                @wrapped_issue.to_assignee_field,
                @wrapped_issue.to_due_date_field,
                @wrapped_issue.to_estimated_hours_field,
                @wrapped_issue.to_priority_field,
            ].compact

            description_field = @wrapped_issue.to_description_field

            # then は必要がない
            if description_field != nil
                fields.push get_separator_field
                fields.push description_field
            end

            # 例外を潰すのはよくないので例外を対応したいなら
            # #resolve_absolute_url メソッド内で行うべき
            heading_url = @wrapped_issue.resolve_absolute_url

            return [{
                'url' => heading_url,
                'title' => "[New issue] #{@wrapped_issue.to_heading_title}",
                'color' => get_fields_color,
                'fields' => fields
            }]
        end

    private
        def get_fields_color
            return 65280
        end

        def get_separator_field
            return {
                'name' => '---------------------------',
                'value' => "\u200b",
                'inline' => false
            }
        end
    end

    class IssueEditEmbed
        def initialize(context)
            @wrapped_issue = WrappedIssue.new context[:issue]
            @wrapped_journal = WrappedJournal.new context[:journal]
        end

        def to_embed_array
            # prepare fields in heading embed
			# #compact で nil 要素を削除
            fields = [
                # TODO add property diff field
            ].compact

            # 後置 if を使って一行に
            notes_field = @wrapped_journal.to_notes_field
            fields.push notes_filed if notes_filed
            # notes_field 変数すら定義したくないならこういう書き方も
#           @wrapped_journal.to_notes_field.tap { |it| fields.push it if it }

            # 例外を潰すのはよくないので例外を対応したいなら
            # #resolve_absolute_url メソッド内で行うべき
            heading_url = @wrapped_issue.resolve_absolute_url

            return [{
                'url' => heading_url,
                'title' => "[Issue update] #{@wrapped_issue.to_heading_title}",
                'color' => get_fields_color,
                'fields' => fields
            }]
        end

    private
        def get_fields_color
            return 16752640
        end
    end
end
