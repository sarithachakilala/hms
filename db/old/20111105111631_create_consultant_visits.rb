class CreateConsultantVisits < ActiveRecord::Migration
  def self.up
    create_table :consultant_visits do |t|
      t.string :admn_no
      t.string :mr_no
      t.string :department
      t.string :consultant
      t.date :date_of_visit
      t.time :time_of_visit
      t.float :charge
      t.string :org_code
      t.string :org_location   
      t.timestamps
    end
  end

  def self.down
    drop_table :consultant_visits
  end
end
