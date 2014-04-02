class CreateChargeMasters < ActiveRecord::Migration
  def self.up
    create_table :charge_masters do |t|
      t.string :org_code
      t.string :org_location
      t.string :service_group
      t.string :service_name
      t.string :test_name
      t.float :charge
      t.string :insurance
      t.integer :ins_discount_type
      t.integer :ins_discount_value
      t.string :corporate
      t.string :crp_discount_type
      t.string :crp_discount_value
      t.float :lab_amount
      t.float :hospital_amount
      t.float :external_lab_amount
      t.string :lab_type
      t.string :charge_ph

      t.timestamps
    end
  end

  def self.down
    drop_table :charge_masters
  end
end
