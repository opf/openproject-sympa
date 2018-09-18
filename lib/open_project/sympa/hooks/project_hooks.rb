module OpenProject
  module Sympa
    module Hooks
      class ProjectHooks < Redmine::Hook::ViewListener
        render_on :view_projects_form, partial: 'hooks/projects/sympa'
      end
    end
  end
end
