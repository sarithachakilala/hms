class CreateWardCosts < ActiveRecord::Migration
  def self.up
    create_table :ward_costs do |t|
      t.string :consultant_master_id
      t.string :ward
      t.string :gcost
      t.string :night_duty_cost
      t.string :emergency_cost

      t.timestamps
    end
  end

  def self.down
    drop_table :ward_costs
  end
end
