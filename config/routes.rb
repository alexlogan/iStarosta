Rails.application.routes.draw do

  resources :students do
    resources :medical_certificates
  end

  resources :lessons


  get 'lessons/:lesson_id/logs' => 'logs#index', as: :lesson_logs

  post 'lessons/:lesson_id/logs' => 'logs#create'

  get 'lessons/:lesson_id/logs/new' => 'logs#new', as: :new_lesson_log

  get 'lessons/:lesson_id/logs/:date/edit' => 'logs#edit', as: :edit_lesson_log

  get 'lessons/:lesson_id/logs/:date' => 'logs#show', as: :show_lesson_log

  patch 'lessons/:lesson_id/logs/:date' => 'logs#update', as: :update_lesson_log

  delete 'lessons/:lesson_id/logs/:date' => 'logs#destroy', as: :destroy_lesson_log

  root 'lessons#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
