class CreateBedMasters < ActiveRecord::Migration
  def self.up
    create_table :bed_masters do |t|
      t.integer :ward_master_id
      t.integer :room_master_id
      t.string :name
      t.string :code
      t.string :status
      t.string :org_code
      t.string :org_location
      t.timestamps
    end
  end

  def self.down
    drop_table :bed_masters
  end
end
