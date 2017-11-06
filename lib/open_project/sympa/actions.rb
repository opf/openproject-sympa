require 'open_project/sympa/logger'

module OpenProject
  module Sympa
    module Actions
      def self.execute_command(command)
        Logger.info("  executing #{command}")
        system "sudo #{command} >> #{Logger.path} 2>&1 &"
      end

      def self.get_sympa_path
        Setting.plugin_openproject_sympa['sympa_path']
      end

      def self.get_domain
        Setting.plugin_openproject_sympa['sympa_domain']
      end

      def self.create_list(project)
        if true
          Rails.logger.error "Mailing list management temporarily disabled"
          return
        end

        temp_file = File.open("#{Rails.root}/tmp/list#{project.identifier}", "w+")
        File.chmod(0644, temp_file.path)
        temp_file.print(project.sympa_mailing_list_xml_def)
        temp_file.flush
        Logger.info "Creating mailing list for project #{project.identifier}"
        execute_command("#{get_sympa_path} --create_list --robot #{get_domain} --input_file #{temp_file.path}")
      end

      def self.destroy_list(project)
        if true
          Rails.logger.error "Mailing list management temporarily disabled"
          return
        end

        Logger.info "Destroying mailing list for project #{project.identifier}"
        execute_command("#{get_sympa_path} --purge_list=#{project.identifier}@#{get_domain}")
      end
    end
  end
end
