Rails.application.routes.draw do
  root 'pages#home'
  get 'oauth2/callback'
  post 'sign_out' => 'sessions#sign_out'
end
