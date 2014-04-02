class CreateRoomMasters < ActiveRecord::Migration
  def self.up
    create_table :room_masters do |t|
      t.integer :ward_master_id
      t.string :name
      t.string :code
      t.string :floor
      t.integer :no_of_beds
      t.integer :extension_no
      t.string :status
      t.string :org_code
      t.string :org_location

      t.timestamps
    end
  end

  def self.down
    drop_table :room_masters
  end
end
