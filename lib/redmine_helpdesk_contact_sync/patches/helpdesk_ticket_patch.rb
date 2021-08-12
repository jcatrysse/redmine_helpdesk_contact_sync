# frozen_string_literal: true

module RedmineHelpdeskContactSync
  module Patches
    module HelpdeskTicketPatch
      def self.included(base)
        base.include(InstanceMethods)

        base.class_eval do
          after_commit :sync_contact, on: :update, if: :must_be_synced?
        end
      end

      module InstanceMethods
        private

        def must_be_synced?
          RedmineHelpdeskContactSync.enabled? &&
            contact_id_previously_changed? &&
            cf_to_sync
        end

        def cf_to_sync
          @cf_to_sync ||= issue.cf_to_sync
        end

        def sync_contact
          duplicated_cv = cv_to_sync_with_value(contact_id)
          duplicated_cv&.destroy!
          cv_to_sync = cv_to_sync_with_value(contact_id_previous_change[0])
          cv_to_sync&.update_columns(value: contact_id)
        end

        def cv_to_sync_with_value(id)
          issue.custom_values.find_by(
            custom_field_id: cf_to_sync.id,
            value:           id.to_s
          )
        end
      end
    end
  end
end

unless HelpdeskTicket.included_modules.include?(RedmineHelpdeskContactSync::Patches::HelpdeskTicketPatch)
  HelpdeskTicket.include(RedmineHelpdeskContactSync::Patches::HelpdeskTicketPatch)
end
