class CreateAdmissions < ActiveRecord::Migration
  def self.up
    create_table :admissions do |t|
      t.string :admn_category
      t.string :org_code
      t.string :org_location
      t.string :registration_id
      t.string :admn_date
      t.string :mr_no
      t.string :admn_no
      t.string :patient_name
      t.integer :age
      t.string :gender
      t.string :admn_type
      t.string :department
      t.string :consultant_id
      t.string :consultant_name
      t.string :ward
      t.string :room
      t.string :bed
      t.string :floor
      t.string :attendant_name
      t.string :attendant_ph_no
      t.string :package_category
      t.string :sub_category
      t.string :days
      t.string :amount
      t.string :advance
      t.string :bill_no1
      t.string :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :admissions
  end
end
