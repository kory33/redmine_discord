require 'redmine'

Redmine::Plugin.register :redmine_discord do
  name 'Redmine Discord plugin'
  author 'kory'
  description 'Send notifications to discord channels in a rich embed format.'
  version '0.0.2'
  url 'https://github.com/kory33/redmine_discord'
  author_url 'https://github.com/kory33'

  settings({
    default: {
        'webhook_avatar_url' => 'https://raw.githubusercontent.com/kory33/redmine_discord/gh-pages/redmine_icon.png',
        'webhook_username' => 'Redmine Notification'
    },
    partial: 'settings/redmine_discord'
  })
end

if Rails.configuration.respond_to?(:autoloader) && Rails.configuration.autoloader == :zeitwerk
  Rails.autoloaders.each { |loader| loader.ignore(File.dirname(__FILE__) + '/lib') }
end
require File.dirname(__FILE__) + '/lib/redmine_discord'
