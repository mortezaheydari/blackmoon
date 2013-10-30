module MultiSession
  extend ActiveSupport::Concern

  included do
	has_many :offering_sessions, as: :owner, :dependent => :destroy; accepts_nested_attributes_for :offering_sessions

		
  end

end