class CreateBedManagements < ActiveRecord::Migration
  def self.up
    create_table :bed_managements do |t|
      t.string :user_id
      t.string :ward
      t.string :room
      t.string :bed

      t.timestamps
    end
  end

  def self.down
    drop_table :bed_managements
  end
end
