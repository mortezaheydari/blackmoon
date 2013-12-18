class HappeningCase < ActiveRecord::Base
  after_update :update_happening_schedules
  include PublicActivity::Model  
  attr_accessible :date_and_time, :duration_type, :happening_id, :happening_type, :time_from, :time_to, :title

  belongs_to :happening, polymorphic: true
  accepts_nested_attributes_for :happening

  has_many :happening_schedules, :dependent => :destroy;
  accepts_nested_attributes_for :happening_schedules

  validates :date_and_time, presence: true
  validates :duration_type, presence: true

  def update_happening_schedules
  	happening_schedules.each do |happ_sch|
		if self.duration_type = "All Day"
			happ_sch.date_and_time = self.date_and_time
		else
			d = self.date_and_time
			t = self.time_from
			happ_sch.date_and_time = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
		end
		happ_sch.save
	end
  end

end
