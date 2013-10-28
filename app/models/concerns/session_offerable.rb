module SessionOfferable
  extend ActiveSupport::Concern

  included do

    belongs_to :owner, polymorphic: true
    accepts_nested_attributes_for :owner

    has_one :offering_creation, as: :offering, :dependent => :destroy
    accepts_nested_attributes_for :offering_creation

    has_many :offering_administrations, as: :offering, :dependent => :destroy
    accepts_nested_attributes_for :offering_administrations
    
    make_flaggable :like
    
    def creator
      User.find_by_id(owner.offering_creation.creator_id) unless owner.offering_creation.nil?
    end

    def administrators
      @admins = []
      owner.offering_administrations.each do |admin|
        @admins << admin.administrator_id
      end
      User.find(@admins)
    end

    def location
      owner.location
    end

  end

 end