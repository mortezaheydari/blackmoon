ActiveAdmin.register Account do
  filter :email

  index do 
    column :email
	column "user name", :user
	column "full name" do |account|
		account.user.title
	end
	column "phone" do |account|
		account.user.profile.phone
	end
    column :sign_in_count	
    column :last_sign_in_at

    default_actions
  end


# 	show do                     
# 		# panel "Account" do
# 			row :email                  

# 			# panel "User" do
# 			f.attributes_table_for user do |u|
# 				u.row :name
# 				# panel "Profile" do
# 					u.attributes_table_for profile do |p|
# 						p.row   :first_name
# 						p.row   :last_name
# 						p.row :date_of_birth, as: :date_select
# 						p.row  :phone, as: :number
# 						p.row   :gender
# 						p.row   :about
# 						p.row  :daily_email_option, as: :radio
# 					end
# 			end
# # end
# # end
# # end

# 		f.actions                         
# 	end 

show do
	columns do
		column do
			h2 "Offerings Created"
			panel "events_created" do
				table_for account.user.events_created do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "games_created" do
				table_for account.user.events_created do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "venues_created" do
				table_for account.user.events_created do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "personal_trainers_created" do
				table_for account.user.events_created do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "group_trainings_created" do
				table_for account.user.events_created do
					column :title
					column :descreption
					column :sport
				end
			end
		end

		column do
			h2 "Offerings Administrating"
			panel "events_administrating" do
				table_for account.user.events_administrating do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "games_administrating" do
				table_for account.user.events_administrating do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "venues_administrating" do
				table_for account.user.events_administrating do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "personal_trainers_administrating" do
				table_for account.user.events_administrating do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "group_trainings_administrating" do
				table_for account.user.events_administrating do
					column :title
					column :descreption
					column :sport
				end
			end
		end


		column do
			h2 "Offerings Participating"
			panel "events_participating" do
				table_for account.user.events_participating do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "games_participating" do
				table_for account.user.events_participating do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "venues_participating" do
				table_for account.user.events_participating do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "personal_trainers_participating" do
				table_for account.user.events_participating do
					column :title
					column :descreption
					column :sport
				end
			end
			panel "group_trainings_participating" do
				table_for account.user.events_participating do
					column :title
					column :descreption
					column :sport
				end
			end
		end
	end

end

sidebar "User information", only: [:show, :edit] do

		attributes_table_for account do
			row :email
		end


		attributes_table_for account.user do
			row :name
		end


		attributes_table_for account.user.profile do
			row   :first_name
			row   :last_name
			row :date_of_birth
			row  :phone
			row   :gender
			row   :about
			row  :daily_email_option		
		end

end

	form do |f|                         
		f.inputs "Account" do       
			f.input :email                  
	        if f.object.new_record?
	            f.input :password
	            f.input :password_confirmation
	        end
		end

	  f.inputs "Users", :for => [:user, f.object.user || User.new] do |user_form|


	    user_form.input :name
	    if !f.object.new_record?
		  user_form.inputs "Profile", :for => [:profile, user_form.object.profile || Profile.new] do |profile_form|
				profile_form.input   :first_name
				profile_form.input   :last_name
				profile_form.input :date_of_birth, as: :date_select
				profile_form.input  :phone, as: :number
				profile_form.input   :gender
				profile_form.input   :about
				profile_form.input  :daily_email_option, as: :radio
		  end
		end
  	end
		f.actions                         
	end 

end