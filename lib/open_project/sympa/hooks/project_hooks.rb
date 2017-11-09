module OpenProject
  module Sympa
    module Hooks
      class ProjectHooks < Redmine::Hook::ViewListener
        # :project
        # :form
        def view_projects_form(context={})
          content = context[:form].text_area(
            :sympa_info, :rows => 5, :class => 'wiki-edit',
            :container_class => "-wide"
          )

          content_tag(:div, content, class: "form--field") +
            wikitoolbar_for('project_sympa_info')
        end
      end
    end
  end
end
