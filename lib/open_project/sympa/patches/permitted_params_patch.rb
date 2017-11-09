module OpenProject
  module Sympa
    module Patches
      module PermittedParamsPatch
        def self.included(base) # :nodoc:
          base.prepend InstanceMethods
        end

        module InstanceMethods
          def project
            p = super

            project_params = params.require(:project)

            p[:sympa_info] = project_params[:sympa_info] if project_params[:sympa_info]

            p
          end
        end
      end
    end
  end
end
