module RedmineDiscord
    class NewIssueEmbed
        def initialize(issue)
            @issue = issue
        end

        def to_embed_array
            # TODO
            return [
                {
                    'title' => 'New issue',
                    'color' => 16711680,
                    'fields' => [
                        {
                            'name' => 'Assignee',
                            'value' => 'Assigned Person',
                            'inline' => true
                        }
                    ]
                }
            ]
        end
    end
end    