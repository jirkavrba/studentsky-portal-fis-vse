Rails.application.routes.draw do

  root to: 'home#index'

  get '/sign_in', to: 'authentication#login'
  get '/sign_up', to: 'authentication#registration'

  post '/sign_in', to: 'authentication#process_login'
  post '/sign_up', to: 'authentication#process_registration'

  get '/verification/:code', to: 'authentication#verify_email', as: 'verification'
end
