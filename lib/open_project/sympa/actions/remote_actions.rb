module OpenProject; module Sympa; module Actions; end; end; end

module OpenProject::Sympa::Actions::Remote
  module_function

  def create_list(project)
  	host, command = ssh_host_and_command

    file = File.open("#{Rails.root}/tmp/list_#{project.identifier}.sh", "w+")
    File.chmod(0644, file.path)

    file.print("cat > /tmp/#{project.identifier}.xml <<XML")
    file.print("\n")
    file.print(project.sympa_mailing_list_xml_def.to_xml)
    file.print("\n")
    file.print("XML")
    file.print("\n")
    file.print("#{command} --create_list --robot #{sympa_domain} --input_file /tmp/#{project.identifier}.xml")
    file.print("\n")
    file.flush

    OpenProject::Sympa::Logger.info "Creating mailing list for project #{project.identifier}"

    system "ssh -oStrictHostKeyChecking=no #{host} < #{file.path}"
  end

  def destroy_list(project)
  	host, command = ssh_host_and_command

    OpenProject::Sympa::Logger.info "Destroying mailing list for project #{project.identifier}"

    system "ssh -oStrictHostKeyChecking=no #{host} #{command} --purge_list=#{project.identifier}@#{sympa_domain}"
  end

  def sympa_domain
    Setting.plugin_openproject_sympa['sympa_domain']
  end

  def sympa_path
    Setting.plugin_openproject_sympa['sympa_path']
  end

  def ssh_host_and_command
	  return @ssh_host_and_command if @ssh_host_and_command

	  host, command = split_host_and_command sympa_path

	  if host.blank? || command.blank?
	    raise ArgumentError, "Invalid remote sympa path, expected 'ssh <host> <command>'"
	  end

	  @ssh_host_and_command = [host, command]
	end

  def split_host_and_command(path)
    return [] unless path.start_with?("ssh")

    path = path[path.index(" ")..-1].strip # strip leading 'ssh '
    host = path[0..path.index(" ")].strip
    cmd = path[path.index(" ")..-1].strip

    [host, cmd]
  end
end
