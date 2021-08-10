# frozen_string_literal: true

module RedmineHelpdeskContactSync
  module Patches
    module HelpdeskHelperPatch
      def self.included(base)
        base.include(InstanceMethods)

        base.class_eval do
          alias_method :helpdesk_select_customer_tag_without_hcs, :helpdesk_select_customer_tag
          alias_method :helpdesk_select_customer_tag, :helpdesk_select_customer_tag_with_hcs
        end
      end

      module InstanceMethods
        def helpdesk_select_customer_tag_with_hcs(name, select_values = [], options = {})
          cross_project_contacts = ContactsSetting.cross_project_contacts? || !!options.delete(:cross_project_contacts)
          s = select2_tag(
            name,
            options_for_select(select_values, options[:selected]),
            url: auto_complete_contacts_path(project_id: (cross_project_contacts ? nil : @project), is_company: (options[:is_company] ? '1' : nil), multiaddress: options[:multiaddress]),
            placeholder: '',
            style: options[:style] || 'width: 60%',
            width: options[:width] || '60%',
            include_blank: true,
            format_state: (options[:multiaddress] ? 'formatStateWithMultiaddressHcs' : 'formatStateWithAvatarHcs'), # PATCHED
            format_selection: 'formatSelectionWithEmails',
            allow_clear: !!options[:include_blank]
          )

          if options[:add_contact] && @project.persisted?
            if authorize_for('contacts', 'new')
              s << link_to(
                image_tag('add.png', style: 'vertical-align: middle; margin-left: 5px;'),
                new_project_contact_path(@project, contact_field_name: name, contacts_is_company: !!options[:is_company]),
                remote: true,
                method: 'get',
                title: l(:label_crm_contact_new),
                id: "#{sanitize_to_id(name)}_add_link",
                tabindex: 200
              )
            end

            s << javascript_include_tag('attachments')
          end

          s.html_safe

        end
      end
    end
  end
end

unless HelpdeskHelper.included_modules.include?(RedmineHelpdeskContactSync::Patches::HelpdeskHelperPatch)
  HelpdeskHelper.include(RedmineHelpdeskContactSync::Patches::HelpdeskHelperPatch)
end
