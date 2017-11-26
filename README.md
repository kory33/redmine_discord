# Redmine_Discord

This plugin sends webhook notifications to desired Discord channnels
via [Discord's Webhook API](https://discordapp.com/developers/docs/resources/webhook).

### Installation
1. Go to `<Redmine Dir>/plugins` and execute
    ```
    git clone https://github.com/kory33/redmine_discord
    cd ./redmine_discord
    bundle install
    ```
2. Restart Redmine

### Settings Webhook URLs

1. From `Administration > Custom fields`, create a custom field for `Projects`
2. Configure the properties as follow:
  * "Format" to `List`
  * "Name" to `Discord Webhooks`(case-sensitive)
  * Check "Multiple values"
  * Uncheck "Visible" (Recommended)
  * Paste Webhook URLs in "Possible values", one per line
3. Save the custom field
4. Select `Discord Webhooks` in projects' Settings

and you are done!