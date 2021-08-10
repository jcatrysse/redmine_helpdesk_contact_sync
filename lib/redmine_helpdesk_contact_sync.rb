# frozen_string_literal: true

require 'redmine_helpdesk_contact_sync/patches/issue_patch'
require 'redmine_helpdesk_contact_sync/patches/helpdesk_ticket_patch'
require 'redmine_helpdesk_contact_sync/patches/contacts_helper_patch'
require 'redmine_helpdesk_contact_sync/patches/helpdesk_helper_patch'

require 'redmine_helpdesk_contact_sync/hooks/view_layouts_hook'

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
