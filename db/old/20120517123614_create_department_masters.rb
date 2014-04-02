class CreateDepartmentMasters < ActiveRecord::Migration
  def self.up
    create_table :department_masters do |t|
      t.string :org_code
      t.string :org_location
      t.string :category
      t.string :department
      t.string :status
      t.string :hod
      t.string :ph_no_hod
      t.timestamps
    end
  end

  def self.down
    drop_table :department_masters
  end
end
