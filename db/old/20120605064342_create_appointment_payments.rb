class CreateAppointmentPayments < ActiveRecord::Migration
  def self.up
    create_table :appointment_payments do |t|
      t.string :org_code
      t.string :org_location
      t.string :registration_id
      t.string :op_number
      t.string :mr_no
      t.string :book_date
      t.string :patient_name
      t.string :age
      t.string :gender
      t.string :appt_type
      t.string :appt_date
      t.string :appt_time
      t.string :department
      t.string :consultant_id
      t.string :consultant_name
      t.string :consultant_fee
      t.string :bill_no11
      t.string :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :appointment_payments
  end
end
