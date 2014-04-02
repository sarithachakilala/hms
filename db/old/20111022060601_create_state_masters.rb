class CreateStateMasters < ActiveRecord::Migration
  def self.up
    create_table :state_masters do |t|
      t.integer :country_master_id
      t.string :code
      t.string :name


      t.timestamps
    end
  end

  def self.down
    drop_table :state_masters
  end
end
