# Prevent load-order problems in case openproject-plugins is listed after a plugin in the Gemfile
# or not at all
require 'open_project/plugins'

module OpenProject
  module Sympa
    class Engine < ::Rails::Engine
      engine_name :openproject_sympa

      include OpenProject::Plugins::ActsAsOpEngine

      class << self
        def settings
          {
            partial: 'settings/sympa',
            default: {
              'sympa_roles' => [],
              'sympa_domain' => 'yourdomain.com',
              'sympa_archive_url' => 'http://localhost/wws/arc/',
              'sympa_path' => '/home/sympa/bin/sympa.pl',
              'sympa_log' => "#{Rails.root}/log/sympa.log",
              'sympa_list_type' => 'discussion_list'
            }
          }
        end
      end

      register(
        'openproject-sympa',
        author_url: 'https://openproject.org',
        requires_openproject: '>= 6.0.0',
        settings: settings
      ) do
        #project_module ensures that only the projects that have them 'active' will show them
        project_module :sympa_mailing_list do
          #declares that our "show" from MailingList controller is public
          permission(:view_mailing_lists, {:mailing_list => [:show]}, :public => true)
        end

        #Creates an entry on the project menu for displaying the mailing list
        menu :project_menu,
             :mailing_list,
             { :controller => 'mailing_list', :action => 'show' },
             :caption => 'Mailing List',
             :icon => 'icon2 icon-mail1',
             :after => :activity,
             :param => :project_id,
             :icon => 'icon2 icon-mail1'
      end

      patches [
        :Project,
        :EnabledModule,
        :PermittedParams
      ]

      initializer 'sympa.register_hooks' do
        require 'open_project/sympa/hooks/project_hooks'
      end
    end
  end
end
