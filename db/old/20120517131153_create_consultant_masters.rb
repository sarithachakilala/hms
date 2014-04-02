class CreateConsultantMasters < ActiveRecord::Migration
  def self.up
    create_table :consultant_masters do |t|
      t.string :org_code
      t.string :org_location
      t.string :consultant_type
      t.string :consultant_id
      t.string :payment_type
      t.float :salary
      t.string :salary_type
      t.integer :percentage
      t.integer :consulting_room
      t.integer :extension_no
      t.string :charge_type
      t.string :charge
      t.float :general_charge
      t.float :night_duty_charge
      t.float :emergency_charge

      t.timestamps
    end
  end

  def self.down
    drop_table :consultant_masters
  end
end
