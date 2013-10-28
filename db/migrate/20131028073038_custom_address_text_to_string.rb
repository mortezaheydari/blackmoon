class CustomAddressTextToString < ActiveRecord::Migration
    def up
        change_column :locations, :custom_address, :string
    end

    def down
        change_column :locations, :custom_address, :text
    end

end
