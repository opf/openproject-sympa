OpenProject::Application.routes.draw do
  get '/projects/:project_id/mailing_list', to: 'mailing_list#show', as: 'mailing_list'
end
