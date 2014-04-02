class CreateTreatmentPlans < ActiveRecord::Migration
  def self.up
    create_table :treatment_plans do |t|
      t.string :org_code
      t.string :org_location
      t.string :registration_id
      t.string :patient_type
      t.string :mr_no
      t.string :admn_no
      t.date :treatment_date
      t.time :treatment_time
      t.string :consultant_id
      t.string :medicines
      t.string :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :treatment_plans
  end
end
