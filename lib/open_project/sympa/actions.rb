require 'open_project/sympa/logger'
require 'open_project/sympa/actions/local_actions'
require 'open_project/sympa/actions/remote_actions'

module OpenProject
  module Sympa
    module Actions
      class << self
        def remote?
          Setting.plugin_openproject_sympa['sympa_path'].start_with? "ssh "
        end

        def enabled?
          !disabled?
        end

        def disabled?
          String(ENV["DISABLE_SYMPA_LIST_SYNC"]) == "true"
        end

        def delegate_to
          if remote?
            OpenProject::Sympa::Actions::Remote
          else
            OpenProject::Sympa::Actions::Local
          end
        end

        def create_list(project)
          return if disabled?

          delegate_to.create_list project
        end

        def destroy_list(project)
          return if disabled?

          delegate_to.destroy_list project
        end
      end
    end
  end
end
