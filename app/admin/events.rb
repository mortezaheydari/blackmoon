ActiveAdmin.register Event do
    filter :title
	actions :all, except: [:edit, :destroy]
	
    index do 
      column :title 
      column :descreption 
      column :number_of_attendings
	  column :team_participation      
	  column :gender      	  
      column :fee_type      

    end

end