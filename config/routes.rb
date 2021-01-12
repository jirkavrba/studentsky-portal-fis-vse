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
end
