class ApplicationController < ActionController::Base
  protect_from_forgery

## Creating Guest account using:
## http://stackoverflow.com/questions/6391883/how-to-create-a-guest-user-in-rails-3-devise
    def current_account
      super || guest_account
    end

    private

        def guest_account
         Account.find(session[:guest_account_id].nil? ? session[:guest_account_id] = create_guest_account.id : session[:guest_account_id])
        end

        def create_guest_account
          u = Account.create(:email => "guest_#{Time.now.to_i}#{rand(99)}@example.com")
          u.save(:validate => false)
          u.create_user(:name => "name")
          u
        end
##
end
