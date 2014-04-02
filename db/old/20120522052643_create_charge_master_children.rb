class CreateChargeMasterChildren < ActiveRecord::Migration
  def self.up
    create_table :charge_master_children do |t|
      t.string :charge_master_id
      t.string :reg_type
      t.string :name
      t.float :discount_price
      t.integer :discount_persentage
      t.float :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :charge_master_children
  end
end
