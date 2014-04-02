class CreateCountryMasters < ActiveRecord::Migration
  def self.up
    create_table :country_masters do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :country_masters
  end
end
