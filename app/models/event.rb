class Event < ActiveRecord::Base
  attr_accessible :category, :custom_address, :date_and_time, :descreption, :location_type, :title, :tournament_id
end
