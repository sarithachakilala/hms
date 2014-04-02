class CreateWardMasters < ActiveRecord::Migration
  def self.up
    create_table :ward_masters do |t|
      t.string :name
      t.string :no_of_rooms
      t.float :cost
      t.string :org_code
      t.string :org_location
      t.timestamps
    end
  end

  def self.down
    drop_table :ward_masters
  end
end
