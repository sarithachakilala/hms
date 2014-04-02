class CreateMiscellaneousMasters < ActiveRecord::Migration
  def self.up
    create_table :miscellaneous_masters do |t|
      t.string :org_code
      t.string :org_location
      t.string :mis_no
      t.string :voucher_no
      t.date :date
      t.time :time
      t.string :department
      t.string :employee
      t.float :total_amount
      t.string :authorized_by
      t.text :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :miscellaneous_masters
  end
end
