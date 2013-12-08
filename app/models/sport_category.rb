class SportCategory < ActiveRecord::Base
  attr_accessible :name

  has_many :sports; accepts_nested_attributes_for :sports
end
