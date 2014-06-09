OpenSensor::Application.routes.draw do
  resources :flows
  resources :flow_power_daily_sum, controller: 'flows', type: 'Flow' 
  resources :flow_avg,             controller: 'flows', type: 'Flow' 


  resources :elements


  resources :actions


  get "welcome/index"

  resources :twitter_credentials do
   collection do
      get 'connect'
      get 'callback'
    end
  end


  resources :element_prototypes


  resources :sensors do
    member do
      delete 'drop'
    end
  end

  resources :triggers


  resources :widgets

  resources :home

  resources :dashboards do
    member do
      post 'positions'
    end
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
