Rails.application.routes.draw do
  root 'questions#index'
  get 'oauth2/callback'
  post 'sign_out' => 'sessions#sign_out'
  resources :questions, except: :index do
    resources :answers, except: %i[index show]
  end
end
