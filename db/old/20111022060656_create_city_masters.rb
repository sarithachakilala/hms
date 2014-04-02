class CreateCityMasters < ActiveRecord::Migration
  def self.up
    create_table :city_masters do |t|
      t.integer :state_master_id
      t.string :code
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :city_masters
  end
end
