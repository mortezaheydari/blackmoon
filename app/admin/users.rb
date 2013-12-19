ActiveAdmin.register User do

	belongs_to :account
  # filter :name

  # index download_links: false do
  #   column :email
  #   column "User Name", :name
  #   column "Full Name", :full_name
  #   column :contact_number, :sortable => false
  #   column :profile_filled, :sortable => false

  #   actions :defaults => false do |user|
  #     link_to "View", admin_user_path(user)
  #   end
  # end


  # index :as => :grid, :columns => 4, download_links: false do |user|
  #   link_to((user.name + ", (" + user.email + ")" ), admin_user_path(user))
  # end

  # form do |f|
  #   f.inputs "Details" do
  #     f.input :account_id
  #     f.input :name
  #     f.input :full_name
  #   end
  #   f.inputs "Contact" do
  #     f.input :contact_number       	
  #     f.input :address
  #   end
  #   f.actions
  # end  
 
end
