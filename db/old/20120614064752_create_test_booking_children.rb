class CreateTestBookingChildren < ActiveRecord::Migration
  def self.up
    create_table :test_booking_children do |t|
      t.integer :test_booking_id
      t.string :s_no
      t.string :test_code
      t.string :test_name
      t.float :rate
      t.string :dis_ptage
      t.float :dis_amount
      t.float :amount
      t.string :department
      t.string :status
      t.string :lab_type
      t.float :lab_amount
      t.string :org_code

      t.timestamps
    end
  end

  def self.down
    drop_table :test_booking_children
  end
end
