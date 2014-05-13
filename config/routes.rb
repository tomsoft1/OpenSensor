OpenSensor::Application.routes.draw do
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
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users



end
