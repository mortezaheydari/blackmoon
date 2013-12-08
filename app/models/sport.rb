class Sport < ActiveRecord::Base
  attr_accessible :name, :sport_category_id

  belongs_to :sport_category; accepts_nested_attributes_for :sport_category
end
