module Offerable
    extend ActiveSupport::Concern

    included do
        make_flaggable :like
        attr_accessor  :offering_type

        def offering_type
            self.class.to_s
        end

        searchable do
            string :offering_type
        end

# categorized features
## Acts
        if ["Team"].include? self.name
            has_many :act_administrations, as: :act, :dependent => :destroy; accepts_nested_attributes_for :act_administrations
            has_one :act_creation, as: :act, :dependent => :destroy; accepts_nested_attributes_for :act_creation

            def creator
                User.find_by_id(self.act_creation.creator_id) unless self.act_creation.nil?
            end
            def administrators
                @admins = []
                self.act_administrations.each do |admin|
                    @admins << admin.administrator_id
                end
                User.find(@admins)
            end
##

## offerings
        else
            has_one :offering_creation, as: :offering, :dependent => :destroy; accepts_nested_attributes_for :offering_creation
            has_many :offering_administrations, as: :offering, :dependent => :destroy; accepts_nested_attributes_for :offering_administrations

### offering session:
            if  ["OfferingSession"].include? self.name
                belongs_to :owner, polymorphic: true; accepts_nested_attributes_for :owner
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
###

### normal offering:
            else
                has_one :location, as: :owner, :dependent => :destroy; accepts_nested_attributes_for :location
                def creator
                    User.find_by_id(self.offering_creation.creator_id) unless self.offering_creation.nil?
                end

                def city
                    location.city
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
###
##
#
    end

end