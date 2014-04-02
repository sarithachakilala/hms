class CreateServicemasters < ActiveRecord::Migration
  def self.up
    create_table :servicemasters do |t|
      t.string :org_code
      t.string :org_location
      t.string :service_group_code
      t.string :service_name
      t.string :service_code

      t.timestamps
    end
  end

  def self.down
    drop_table :servicemasters
  end
end
