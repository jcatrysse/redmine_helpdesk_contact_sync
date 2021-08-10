# frozen_string_literal: true

module RedmineHelpdeskContactSync
  module Hooks
    class ViewsLayoutsHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(_context = {})
        javascript_include_tag(:tagged_contact, plugin: 'redmine_helpdesk_contact_sync')
      end
    end
  end
end
