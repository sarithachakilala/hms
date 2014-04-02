class CreateAdvancePayments < ActiveRecord::Migration
  def self.up
    create_table :advance_payments do |t|
      t.string :mr_no
      t.string :admn_no
      t.date :advance_date
      t.float :total_amount
      t.float :gross_amount
      t.float :already_paid_amount
      t.integer :receipt_no
      t.string :payment_mode
      t.string :bank_name
      t.string :acc_no
      t.string :cheque_no
      t.string :card_no
      t.string :card_type
      t.date :expiry_date
      t.float :card_amount
      t.float :cheque_amount
      t.string :admn_category
	  t.string :org_code
	  t.string :org_location
      t.timestamps
    end
  end

  def self.down
    drop_table :advance_payments
  end
end
