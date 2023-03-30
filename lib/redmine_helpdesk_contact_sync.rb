# frozen_string_literal: true
if Rails.configuration.respond_to?(:autoloader) && Rails.configuration.autoloader == :zeitwerk
  Rails.autoloaders.each { |loader| loader.ignore(File.dirname(__FILE__) + '/redmine_helpdesk_contact_sync/patches') }
  Rails.autoloaders.each { |loader| loader.ignore(File.dirname(__FILE__) + '/redmine_helpdesk_contact_sync/hooks') }
end

require File.dirname(__FILE__) + '/redmine_helpdesk_contact_sync/patches/issue_patch'
require File.dirname(__FILE__) + '/redmine_helpdesk_contact_sync/patches/helpdesk_ticket_patch'
require File.dirname(__FILE__) + '/redmine_helpdesk_contact_sync/patches/contacts_helper_patch'
require File.dirname(__FILE__) + '/redmine_helpdesk_contact_sync/patches/helpdesk_helper_patch'
require File.dirname(__FILE__) + '/redmine_helpdesk_contact_sync/hooks/view_layouts_hook'

module RedmineHelpdeskContactSync
  def self.enabled?
    Setting.plugin_redmine_helpdesk_contact_sync['enabled'].present?
  end

  def self.cf_to_sync
    CustomField.find_by(
      id: Setting.plugin_redmine_helpdesk_contact_sync['cf_id']
    )
  end
end
