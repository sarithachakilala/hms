class CreateItemmasters < ActiveRecord::Migration
  def self.up
    create_table :itemmasters do |t|
      t.string :org_code
      t.string :org_location
      t.string :drug_type
      t.string :product_name
      t.string :is_medical_item
      t.string :units
      t.string :drug_formula
      t.string :manufacturer
      t.string :packing
      t.string :vat

      t.timestamps
    end
  end

  def self.down
    drop_table :itemmasters
  end
end
