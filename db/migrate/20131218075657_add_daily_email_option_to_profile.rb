class AddDailyEmailOptionToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :daily_email_option, :boolean, default: true
  end
end
