module OpenProject; module Sympa; module Actions; end; end; end

module OpenProject::Sympa::Actions::Remote
  module_function

  def create_list(project)
  	host, command = ssh_host_and_command

    temp_file = File.open("#{Rails.root}/tmp/list#{project.identifier}", "w+")
    File.chmod(0644, temp_file.path)
    temp_file.print("cat > /tmp/#{project.identifier}.xml <<XML")
    temp_file.print(project.sympa_mailing_list_xml_def.to_xml)
    temp_file.print("XML")
    temp_file.print("#{command} --create_list --robot #{sympa_domain} --input_file /tmp/#{project.identifier}.xml")
    temp_file.flush

    Logger.info "Creating mailing list for project #{project.identifier}"

    system "ssh -oStrictHostKeyChecking=no #{host} < #{temp_file.path}"
  end

  def destroy_list(project)
  	host, command = ssh_host_and_command

    Logger.info "Destroying mailing list for project #{project.identifier}"

    system "ssh -oStrictHostKeyChecking=no #{command} --purge_list=#{project.identifier}@#{sympa_domain}"
  end

  def sympa_domain
    Setting.plugin_openproject_sympa['sympa_domain']
  end

  def ssh_host_and_command
	  return @ssh_host_and_command if @ssh_host_and_command

	  ssh, host, command = get_sympa_path.split(" ").map(&:strip)

	  if ssh != 'ssh' && host.blank? || command.blank?
	    raise ArgumentError, "Invalid remote sympa path, expected 'ssh <host> <command>'"
	  end

	  @ssh_host_and_command = [host, command]
	end
end
