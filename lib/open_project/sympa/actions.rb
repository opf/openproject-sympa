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

        def delegate_to
          if remote?
            OpenProject::Sympa::Actions::Remote
          else
            OpenProject::Sympa::Actions::Local
          end
        end
      end

      delegate :create_list, to: delegate_to
      delegate :destroy_list, to: delegate_to
    end
  end
end
