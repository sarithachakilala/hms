class CreateTestBookings < ActiveRecord::Migration
  def self.up
    create_table :test_bookings do |t|
      t.string :org_code
      t.string :org_location
      t.string :patient_type
      t.string :mr_no
      t.string :admn_no
      t.string :patient_name
      t.string :refferal_doctor
      t.string :lab_services
      t.string :lab_no
      t.string :bill_no
      t.float :tital_amount
      t.string :concession_authority
      t.float :concession
      t.float :grand_total
      t.string :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :test_bookings
  end
end
