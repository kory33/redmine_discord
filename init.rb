require 'redmine'
require_dependency 'redmine_discord/listener'

Redmine::Plugin.register :redmine_discord do
  name 'Redmine Discord plugin'
  author 'kory'
  description 'Send notifications to discord channels in a rich embed format.'
  version '0.0.1'
  url 'https://github.com/kory33/redmine_discord'
  author_url 'https://github.com/kory33'

  settings({
    default: {
        webhook_avatar_url: 'https://raw.githubusercontent.com/kory33/redmine_discord/gh-pages/redmine_icon.png',
        webhook_username: 'Redmine Notification'
    },
    partial: 'settings/redmine_discord'
  })
end
