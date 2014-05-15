OpenSensor::Application.routes.draw do
  get "welcome/index"

  resources :twitter_credentials do
   collection do
      get 'connect'
      get 'callback'
    end
  end


  resources :element_prototypes


  resources :sensors


  resources :triggers


  resources :widgets

  resources :home

  resources :dashboards do
   collection do
      get 'subscribe'
      post 'webhook'
    end
  end
  
  resources :measures


  resources :feeds do
    member do
      get 'graph'
    end
  end

  resources :devices

  authenticated :user do
    root :to => 'users#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users



end
