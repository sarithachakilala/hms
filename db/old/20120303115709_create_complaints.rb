class CreateComplaints < ActiveRecord::Migration
  def self.up
    create_table :complaints do |t|
      t.string :name
      t.date :pdate
      t.time :ptime
      t.string :about
	  t.string :status
      t.timestamps
    end
  end

  def self.down
    drop_table :complaints
  end
end
