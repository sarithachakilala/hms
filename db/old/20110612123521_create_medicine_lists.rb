class CreateMedicineLists < ActiveRecord::Migration
  def self.up
    create_table :medicine_lists do |t|
      t.integer :treatment_plan_id
      t.integer :discharge_summary_id
      t.integer :s_no
      t.string :name
      t.string :code
	  t.string :frequency
      t.integer :quantity
      t.float :amount
      t.string :comments
      t.string :root
      t.string :options
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :medicine_lists
  end
end
