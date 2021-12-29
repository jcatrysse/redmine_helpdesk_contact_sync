# frozen_string_literal: true

Redmine::Plugin.register :redmine_helpdesk_contact_sync do
  name 'HD Contact Sync'
  author 'RedmineUP'
  description 'Allows to sync chosen Contact Custom Field with Helpdesk Contact'
  version '0.0.5.1'
  url 'https://www.redmineup.com'
  author_url 'mailto:support@redmineup.com'

  settings default: { enabled: '', cf_id: nil },
           partial: 'settings/hcs/general'
end

Rails.configuration.to_prepare do
  require 'redmine_helpdesk_contact_sync'
end
