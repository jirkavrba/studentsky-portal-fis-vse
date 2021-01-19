# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  get '/sign_in', to: 'authentication#login'
  get '/sign_up', to: 'authentication#registration'

  post '/sign_in', to: 'authentication#process_login'
  post '/sign_up', to: 'authentication#process_registration'

  get '/sign_out', to: 'authentication#logout', as: 'logout'

  get '/verification/new', to: 'authentication#new_verification_email', as: 'new_verification'
  post '/verification/new', to: 'authentication#process_new_verification_email'

  get '/verification/:code', to: 'authentication#verify_email', as: 'verification'

  get '/reset_password', to: 'authentication#new_password_reset_request'
  post '/reset_password', to: 'authentication#process_password_reset_request'

  get '/reset_password/:code', to: 'authentication#process_password_reset', as: 'password_reset'

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

  resources :users

  scope '/admin' do
    resources :api_tokens, only: %i[index new destroy]
    resources :subjects, except: %i[show]
    resources :discord_servers, except: %i[show]
  end
end
