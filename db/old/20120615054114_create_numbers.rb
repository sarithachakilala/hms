class CreateNumbers < ActiveRecord::Migration
  def self.up
    create_table :numbers do |t|
      t.string :org_location
      t.string :org_code
      t.string :name
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :numbers
  end
end
