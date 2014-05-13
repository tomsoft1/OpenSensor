OpenSensor::Application.routes.draw do
  resources :element_prototypes


  resources :sensors


  resources :triggers


  resources :widgets


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
