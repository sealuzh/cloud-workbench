CloudBenchmarking::Application.routes.draw do
  resources :benchmark_definitions do
    resources :benchmark_executions, only: [:index, :new, :create], context: :benchmark_definition
    resources :metric_definitions, only: [:new, :create], context: :benchmark_definition
    resources :benchmark_schedules, only: [:new, :create ]
    post 'clone', on: :member
  end
  resources :benchmark_executions, except: [:new, :create] do
    member do
      get 'prepare_log'
      get 'release_resources_log'
    end
  end
  resources :metric_definitions, except: [:index, :new, :create]
  resources :benchmark_schedules, only: [:edit, :update ]

  resources :metric_observations, only: [:new, :create]
  resources :nominal_metric_observations, only: [:show]
  resources :ordered_metric_observations, only: [:show]

  resources :virtual_machine_instances do
    member do
      put 'benchmark_completed'
      put 'postprocessing_completed'
    end
  end
  resources :cloud_providers


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'benchmark_definitions#index'

  get '/dashboard', to: redirect('/benchmark_definitions#index')


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
