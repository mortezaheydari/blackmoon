Blackmoon::Application.routes.draw do

  root :to => 'pages#home'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

    resources :users do
        member do
            get 'offering_management'
        end
    end

    resources :events do
      member do
        get 'like'
        get 'like_cards'
      end
    end

    resources :venues do
      member do
        get 'like'
        get 'like_cards'
      end
    end

    resources :group_trainings do
      member do
        get 'like'
        get 'like_cards'
      end
    end

    resources :personal_trainers do
      member do
        get 'like'
        get 'like_cards'
      end
    end

    resources :teams do
      member do
        get 'like'
        get 'like_cards'
      end
    end

    resources :games do
      member do
        get 'like'
        get 'like_cards'
      end
    end

    resources :relationships, only: [ :create, :destroy ]


    resources :offering_sessions do
        member do
            get 'release'
            get 'destroy_collective'
        end
    end

    # resources :offering_individual_participations
    post 'offering_individual_participations/create'
    post 'offering_individual_participations/destroy'

    # resources :offering_individual_participations
    post 'offering_team_participations/create'
    post 'offering_team_participations/destroy'



    # resources :offering_administrations_controller
    post 'offering_administrations/create'
    post 'offering_administrations/destroy'


    post 'act_administrations/create'
    post 'act_administrations/destroy'


    post 'act_memberships/create'
    post 'act_memberships/destroy'

    match 'notification' => 'pages#notification', as: :notification

    devise_for :accounts, :controllers => {:registrations => "registrations"}
  ActiveAdmin.routes(self)

    get 'pages/offering_management'

    resources :activities

    resources :notifications # TODO: line might not be required 

    resources :album_photos

    resources :invitations

    post 'logos/update'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
