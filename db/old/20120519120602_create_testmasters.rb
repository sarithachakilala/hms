class CreateTestmasters < ActiveRecord::Migration
  def self.up
    create_table :testmasters do |t|
      t.string :org_code
      t.string :org_location
      t.string :department_name
      t.string :test_name

      t.timestamps
    end
  end

  def self.down
    drop_table :testmasters
  end
end
