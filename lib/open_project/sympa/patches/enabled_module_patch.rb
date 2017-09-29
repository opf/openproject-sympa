require 'open_project/sympa/actions'

module OpenProject
  module Sympa
    module Patches
      module EnabledModulePatch
        def self.included(base)
          base.send(:include, InstanceMethods)
          base.class_eval do
            unloadable # Send unloadable so it will not be unloaded in development

            after_create :sympa_enable_module
            before_destroy :sympa_disable_module
          end
        end

        module InstanceMethods
          def is_a_sympa_module?
            return (self.name == 'sympa_mailing_list' ? true : false)
          end

          def sympa_enable_module
            self.reload
            if(project && self.is_a_sympa_module?)
              OpenProject::Sympa::Logger.info("EnabledModule: Project #{project.identifier} needs a new mailing list. We must registers all its users, too.")
              OpenProject::Sympa::Actions.create_list(project)
            end
          end

          def sympa_disable_module
            if(project && self.is_a_sympa_module?)
              OpenProject::Sympa::Logger.info("EnabledModule: Project #{project.identifier} doesn't need a mailing list any more")
              OpenProject::Sympa::Actions.destroy_list(project)
            end
          end
        end
      end
    end
  end
end
