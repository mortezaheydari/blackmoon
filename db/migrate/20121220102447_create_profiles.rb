class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.integer :phone
      t.string :gender
      t.text :about

      t.timestamps
    end

    add_index :profiles, [:first_name, :last_name]
  end
end
