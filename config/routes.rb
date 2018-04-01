Rails.application.routes.draw do
  root 'pages#home'
  get 'oauth2/callback'
  post 'sessions#sign_out'
end
