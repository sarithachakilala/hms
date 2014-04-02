class CreateConsultantVisitChildren < ActiveRecord::Migration
  def self.up
    create_table :consultant_visit_children do |t|
      t.string :department
      t.string :cons_name
      t.string :date_and_time
      t.string :cons_type
      t.float :charge

      t.timestamps
    end
  end

  def self.down
    drop_table :consultant_visit_children
  end
end
