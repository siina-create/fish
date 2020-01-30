Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resource :two_factor_auth, only: [:new, :create, :destroy]
  root to: "home#index"
end
