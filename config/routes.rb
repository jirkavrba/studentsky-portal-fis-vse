Rails.application.routes.draw do

  resources :subjects
  resources :discord_servers
  root to: 'home#index'

  get '/sign_in', to: 'authentication#login'
  get '/sign_up', to: 'authentication#registration'

  post '/sign_in', to: 'authentication#process_login'
  post '/sign_up', to: 'authentication#process_registration'

  get '/sign_out', to: 'authentication#logout', as: 'logout'

  get '/verification/new', to: 'authentication#new_verification_email', as: 'new_verification'
  post '/verification/new', to: 'authentication#process_new_verification_email'

  get '/verification/:code', to: 'authentication#verify_email', as: 'verification'

  get '/users/ban/:id', to: 'users#ban', as: 'ban'
  get '/users/unban/:id', to: 'users#unban', as: 'unban'

  get '/discord/', to: 'discord#index', as: 'discord'
  get '/discord/verification', to: 'discord#show_code', as: 'discord_verification'

  scope '/api' do
    post '/discord/complete_verification/:code/:discord_id',
         to: 'discord#complete',
         as: 'complete_discord_verification',
         format: :json

    get '/discord/check_verification/:discord_id',
        to: 'discord#check',
        as: 'check_discord_verification',
        format: :json
  end

  resources :users, only: [:index, :show, :destroy]
  resources :api_tokens, only: [:index, :new, :destroy]
end
