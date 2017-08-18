require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

require 'panoptes_admin_constraint'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq', constraints: PanoptesAdminConstraint.new

  get '/', to: 'status#show'

  resource :session
  get '/auth/:provider/callback', to: 'sessions#create'

  post 'kinesis', to: 'kinesis#create'

  resources :workflows do
    resources :subjects, only: [:show]
  end

  get 'workflows/:workflow_id/extractors/:extractor_id/extracts', to: 'extracts#index'
  put 'workflows/:workflow_id/extractors/:extractor_id/extracts', to: 'extracts#update', defaults: { format: :json }
  get 'workflows/:workflow_id/extractors/export', to: 'data_requests#request_extracts'

  get 'workflows/:workflow_id/reducers/:reducer_id/reductions', to: 'reductions#index'
  put 'workflows/:workflow_id/reducers/:reducer_id/reductions', to: 'reductions#update'
  get 'workflows/:workflow_id/reducers/export', to: 'data_requests#request_reductions'

  get 'data_request/:request_id', to: 'data_requests#check_status'
  get 'data_request/:request_id/retrieve', to: 'data_requests#retrieve'
end
