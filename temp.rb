$ rake routes
                      users GET    /users(.:format)                  users#index
                            POST   /users(.:format)                  users#create
                   new_user GET    /users/new(.:format)              users#new
                  edit_user GET    /users/:id/edit(.:format)         users#edit
                       user GET    /users/:id(.:format)              users#show
                            PUT    /users/:id(.:format)              users#update
                            DELETE /users/:id(.:format)              users#destroy
                     events GET    /events(.:format)                 events#index
                            POST   /events(.:format)                 events#create
                  new_event GET    /events/new(.:format)             events#new
                 edit_event GET    /events/:id/edit(.:format)        events#edit
                      event GET    /events/:id(.:format)             events#show
                            PUT    /events/:id(.:format)             events#update
                            DELETE /events/:id(.:format)             events#destroy
        new_account_session GET    /accounts/sign_in(.:format)       devise/sessions#new
            account_session POST   /accounts/sign_in(.:format)       devise/sessions#create
    destroy_account_session DELETE /accounts/sign_out(.:format)      devise/sessions#destroy
           account_password POST   /accounts/password(.:format)      devise/passwords#create
       new_account_password GET    /accounts/password/new(.:format)  devise/passwords#new
      edit_account_password GET    /accounts/password/edit(.:format) devise/passwords#edit
                            PUT    /accounts/password(.:format)      devise/passwords#update
cancel_account_registration GET    /accounts/cancel(.:format)        registrations#cancel
       account_registration POST   /accounts(.:format)               registrations#create
   new_account_registration GET    /accounts/sign_up(.:format)       registrations#new
  edit_account_registration GET    /accounts/edit(.:format)          registrations#edit
                            PUT    /accounts(.:format)               registrations#update
                            DELETE /accounts(.:format)               registrations#destroy
$

