class CreateFinalBillCancels < ActiveRecord::Migration
  def self.up
    create_table :final_bill_cancels do |t|
      t.string :admn_no
      t.string :mr_no
	  t.integer :receipt_no
      t.float :final_bill_amount
      t.float :final_bill_cancel_amount
	  t.date :final_bill_cancel_date
	  t.string :org_code
      t.string :org_location
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :final_bill_cancels
  end
end
