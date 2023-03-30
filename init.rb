# frozen_string_literal: true

Redmine::Plugin.register :redmine_helpdesk_contact_sync do
  name 'HD Contact Sync'
  author 'RedmineUP'
  description 'Allows to sync chosen Contact Custom Field with Helpdesk Contact'
  version '0.0.6'
  url 'https://www.redmineup.com'
  author_url 'mailto:support@redmineup.com'

  settings default: { enabled: '', cf_id: nil },
           partial: 'settings/hcs/general'
end

if Rails.configuration.respond_to?(:autoloader) && Rails.configuration.autoloader == :zeitwerk
  Rails.autoloaders.each { |loader| loader.ignore(File.dirname(__FILE__) + '/lib') }
end
require File.dirname(__FILE__) + '/lib/redmine_helpdesk_contact_sync'

