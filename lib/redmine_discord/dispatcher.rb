module RedmineDiscord
    class DiscordWebhookDispatcher
        def initialize(settings)
            @settings = settings
        end

        def dispatch(embed_object, project)
            webhook_body = {
                'username' => @settings['webhook_username'],
                'avatar_url' => @settings['webhook_avatar_url'],
                'embeds' => embed_object.to_embed_array
            }.to_json

            targets = fetch_webhook_targets project

            targets.each do |url_string|
                puts "sending to #{url_string}"
                # TODO actually post webhook
            end
        end
    
    private
        def fetch_webhook_targets(project)
            return [] if project.blank?

            field = ProjectCustomField.find_by_name("Discord Webhooks")
            return project.custom_field_value(field) rescue []
        end
    end
end