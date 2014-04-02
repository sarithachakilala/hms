class CreateEmployeeMasters < ActiveRecord::Migration
  def self.up
    create_table :employee_masters do |t|
      t.string :org_code
      t.string :org_location
      t.string :empid
      t.string :name
      t.string :category
      t.string :department
      t.string :designation
      t.date :dob
      t.date :join_date
      t.string :payment_type
      t.string :bank_name
      t.string :acc_no
      t.string :branch_name
      t.text :address
      t.string :city
      t.string :state
      t.string :country
      t.string :zipcode
      t.string :phno
      t.string :email_id
      t.time :from_time
      t.time :to_time

      t.timestamps
    end
  end

  def self.down
    drop_table :employee_masters
  end
end
