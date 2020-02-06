Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  
  resource :two_factor_auth, only: [:new, :create, :destroy]
  resource :home, only: [:show, :create,:edit,:update]
  get "home/fishing" => "homes#fishing"
  post "home/fishing" => "homes#fishing"

  post "home/fish_create" => "homes#fish_create"

  get "home/fishing_otp" => "homes#fishing_otp"
  post "home/fishing_otp" => "homes#fishing_otp"

  patch "home/fishing_otp_create" => "homes#fishing_otp_create"
 
  get  "home/fishing_return" => "homes#fishing_return"
  post "home/fishing_return" => "homes#fishing_return"

  get "users" => "homes#index"
  root to: "homes#index"
end
