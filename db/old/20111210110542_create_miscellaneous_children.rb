class CreateMiscellaneousChildren < ActiveRecord::Migration
  def self.up
    create_table :miscellaneous_children do |t|
      t.integer :miscellaneous_master_id
      t.integer :s_no
      t.string :service
	  t.string :reason
      t.string :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :miscellaneous_children
  end
end
