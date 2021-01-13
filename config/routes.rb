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

  resources :users, only: [:index, :show, :destroy]

  get '/users/ban/:id', to: 'users#ban', as: 'ban'
  get '/users/unban/:id', to: 'users#unban', as: 'unban'

  get '/discord/verification_code', to: 'discord_verifications#show_code'

  scope '/api/' do
    get '/discord/info/:discord_id', to: 'discord_verifications#info'
    get '/discord/complete_verification/:code', to: 'discord_verifications#check_verification'
  end
end
