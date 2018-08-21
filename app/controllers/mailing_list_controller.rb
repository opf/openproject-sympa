class MailingListController < ApplicationController
  unloadable

  before_action :find_project, :authorize, :only => [:show]

  def show

  end

  private

  def find_project
    # @project variable must be set before calling the authorize filter
    @sympa_address = "sympa@#{Setting.plugin_openproject_sympa['sympa_domain']}"

    @project = Project.find(params[:project_id])
  end
end
