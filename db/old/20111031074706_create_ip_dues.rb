class CreateIpDues < ActiveRecord::Migration
  def self.up
    create_table :ip_dues do |t|
      t.string :admn_no
      t.string :mr_no
      t.date :due_date
      t.integer :receipt_no
      t.float :gross_amount
      t.float :due
      t.string :concession_authority
      t.integer :concession
      t.float :remaining_amount
	  t.string :payment_mode
      t.string :bank_name
      t.string :acc_no
      t.string :cheque_no
      t.float :cheque_amount
      t.string :card_no
      t.string :card_type
      t.date :expiry_date
      t.float :card_amount
	  t.string :org_code
      t.string :org_location
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :ip_dues
  end
end
