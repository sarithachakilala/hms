class CreateManufacturers < ActiveRecord::Migration
  def self.up
    create_table :manufacturers do |t|
      t.string :org_code
      t.string :org_location
      t.string :manufacturer_name
      t.string :manufacturer_code

      t.timestamps
    end
  end

  def self.down
    drop_table :manufacturers
  end
end
