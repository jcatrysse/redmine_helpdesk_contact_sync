# frozen_string_literal: true

module RedmineHelpdeskContactSync
  module Patches
    module IssuePatch
      def self.included(base)
        base.include(InstanceMethods)

        base.class_eval do
          before_save :sync_contact, if: :sync_contact?

          validate :contact_synced, if: :must_be_synced?
        end
      end

      module InstanceMethods
        def cf_to_sync
          @cf_to_sync ||= RedmineHelpdeskContactSync.cf_to_sync
        end

        private

        def sync_contact?
          RedmineHelpdeskContactSync.enabled? &&
            new_record? &&
            helpdesk_ticket &&
            cf_to_sync &&
            cf_to_sync_blank?
        end

        def cf_to_sync_blank?
          return false unless cf_to_sync

          if cf_to_sync.multiple?
            cf_to_sync_value.all?(&:blank?)
          else
            cf_to_sync_value.blank?
          end
        end

        def cf_to_sync_value
          custom_field_value(cf_to_sync_id)
        end

        def cf_to_sync_id
          cf_to_sync&.id
        end

        def sync_contact
          self.custom_field_values = { cf_to_sync_id => contact_id }
        end

        def contact_id
          helpdesk_ticket.contact_id
                         .to_s
        end

        def must_be_synced?
          RedmineHelpdeskContactSync.enabled? &&
            project&.module_enabled?(:contacts_helpdesk) &&
            cf_to_sync &&
            (persisted? || !cf_to_sync_blank?) &&
            helpdesk_ticket
        end

        def contact_synced
          errors.add(:base, :must_be_synced, contact: helpdesk_ticket.customer) unless contact_synced?
        end

        def contact_synced?
          if cf_to_sync.multiple?
            cf_to_sync_value.include?(contact_id)
          else
            cf_to_sync_value == contact_id
          end
        end
      end
    end
  end
end

unless Issue.included_modules.include?(RedmineHelpdeskContactSync::Patches::IssuePatch)
  Issue.include(RedmineHelpdeskContactSync::Patches::IssuePatch)
end
