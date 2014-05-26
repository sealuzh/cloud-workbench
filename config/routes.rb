CloudBenchmarking::Application.routes.draw do
  devise_for :users
  root 'dashboards#show'
  get 'dashboard' => 'dashboards#show'

  # Exceptions
  %w( 404 422 500 ).each do |code|
    get code, :to => 'errors#show', :code => code
  end

  # Resources
  resources :benchmark_definitions do
    resources :benchmark_executions, only: [:index, :new, :create], context: :benchmark_definition
    resources :metric_definitions, only: [:new, :create], context: :benchmark_definition
    resources :benchmark_schedules, only: [:new, :create ]
    post :clone, on: :member
  end
  resources :benchmark_schedules, only: [:index, :edit, :update ] do
    member do
      patch :activate
      patch :deactivate
    end
  end
  resources :benchmark_executions, only: [:show, :index, :destroy] do
    member do
      get :prepare_log
      get :release_resources_log
    end
  end
  resources :metric_definitions, only: [:show, :edit, :destroy]

  resources :metric_observations, only: [:create, :index] do
    collection { post :import }
  end
  resources :nominal_metric_observations, only: [:destroy]
  resources :ordered_metric_observations, only: [:destroy]

  resources :virtual_machine_instances do
    # Used from benchmark helper client on VMs
    collection do
      post :complete_benchmark
      post :complete_postprocessing
    end
  end
end
