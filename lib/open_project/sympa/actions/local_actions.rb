module OpenProject; module Sympa; module Actions; end; end; end

module OpenProject::Sympa::Actions::Local
  module_function

  def execute_command(command)
    Logger.info("  executing #{command}")
    
    if use_ssh?
      execute_remote_command command
    else
      execute_local_command command
    end
  end

  def execute_local_command(command)
    system "sudo #{command} >> #{Logger.path} 2>&1 &"
  end

  def execute_remote_command(command)
    host, _ = ssh_host_and_command

    system "ssh -oStrictHostKeyChecking=no #{get_domain}"
  end

  def sympa_domain
    Setting.plugin_openproject_sympa['sympa_domain']
  end

  def sympa_path
    Setting.plugin_openproject_sympa['sympa_path']
  end

  def create_list(project)
    temp_file = File.open("#{Rails.root}/tmp/list#{project.identifier}", "w+")
    File.chmod(0644, temp_file.path)
    temp_file.print(project.sympa_mailing_list_xml_def.to_xml)
    temp_file.flush
    Logger.info "Creating mailing list for project #{project.identifier}"
    execute_command("#{sympa_path} --create_list --robot #{sympa_domain} --input_file #{temp_file.path}")
  end

  def destroy_list(project)
    Logger.info "Destroying mailing list for project #{project.identifier}"
    execute_command("#{sympa_path} --purge_list=#{project.identifier}@#{sympa_domain}")
  end
end