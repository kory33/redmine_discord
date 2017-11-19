require 'json'
require 'httpclient'

module RedmineDiscord
    class DiscordWebhookDispatcher
        def dispatch(embed_object, project)
            webhook_body = construct_webhook_body embed_object
            target_urls = fetch_webhook_targets project

            http_client = HTTPClient.new default_header: {
                'User-Agent' => 'Redmine-Discord-Plugin',
                'Content-Type' => 'application/json'
            }

			http_client.ssl_config.cert_store.set_default_paths
            http_client.ssl_config.ssl_version = :auto

            Thread.new do
                target_urls.each do |url|
                    response = http_client.post url, webhook_body.to_json
                    puts "Posted to #{url}"
                    puts " posted data : #{webhook_body.to_json}"
                    puts " response status : #{response.status}"
                    puts " response body : #{response.body}"
                end
            end
        end
    
    private
        def construct_webhook_body(embed_object)
            return {
                'username' => Setting.plugin_redmine_discord['webhook_username'],
                'avatar_url' => Setting.plugin_redmine_discord['webhook_avatar_url'],
                'embeds' => embed_object.to_embed_array
            }
        end

        def fetch_webhook_targets(project)
            return [] if project.blank?

            field = ProjectCustomField.find_by_name("Discord Webhooks")
            return project.custom_field_value(field) rescue []
        end
    end
end