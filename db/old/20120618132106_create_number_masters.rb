class CreateNumberMasters < ActiveRecord::Migration
  def self.up
    create_table :number_masters do |t|
      t.string :mr_no
      t.string :reg_no
      t.string :ins_no
      t.string :cas_no
      t.string :appt_payment_receipt_no
      t.string :op_no
      t.string :ip_no
      t.string :lab_no
      t.string :lab_bill_no
      t.string :ip_advance_receipt_no
      t.string :ip_final_bill_receipt_no
      t.string :ins_find_bill_no
      t.string :mis_voucher_no

      t.timestamps
    end
  end

  def self.down
    drop_table :number_masters
  end
end
