module Offerable
  extend ActiveSupport::Concern

  included do

    has_one :location, as: :owner, :dependent => :destroy
    accepts_nested_attributes_for :location

    has_one :offering_creation, as: :offering, :dependent => :destroy
    accepts_nested_attributes_for :offering_creation

    has_many :offering_administrations, as: :offering, :dependent => :destroy
    accepts_nested_attributes_for :offering_administrations
    
    make_flaggable :like
    
    def creator
      User.find_by_id(self.offering_creation.creator_id) unless self.offering_creation.nil?
    end

    def administrators
      @admins = []
      self.offering_administrations.each do |admin|
        @admins << admin.administrator_id
      end
      User.find(@admins)
    end

  end

 end