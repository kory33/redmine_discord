require_relative 'embed_objects/issue_embeds'
require_relative 'embed_objects/wiki_embeds'
require_relative 'dispatcher'

module RedmineDiscord
  class EventListener < Redmine::Hook::Listener
    def initialize
      @dispatcher = DiscordWebhookDispatcher.new
    end

    def controller_issues_new_after_save(context={})
      issue = context[:issue]
      return if issue.is_private?

      project = issue.project
      embed_object = NewIssueEmbed.new context

      @dispatcher.dispatch embed_object, project
    end

    def controller_issues_edit_before_save(context={})
      issue = context[:issue]
      journal = context[:journal]

      return if issue.is_private? || journal.private_notes? || issue.invalid?

      project = issue.project
      embed_object = if issue.closed?
        IssueCloseEmbed.new context
      else
        IssueEditEmbed.new context
      end

      @dispatcher.dispatch embed_object, project
    end

    def controller_wiki_edit_after_save(context={})
      wiki_page = context[:page]
      project = wiki_page.project

      embed_object = if wiki_page.content.version == 1
        WikiNewEmbed.new context
      else
        WikiEditEmbed.new context
      end

      @dispatcher.dispatch embed_object, project
    end
  end
end
