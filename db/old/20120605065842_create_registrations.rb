class CreateRegistrations < ActiveRecord::Migration
  def self.up
    create_table :registrations do |t|
      t.string :org_code
      t.string :org_location
      t.string :mr_no
      t.string :reg_no
      t.string :reg_date
      t.string :patient_name
      t.integer :age
      t.string :gender
      t.string :martial_status
      t.string :father_name
      t.string :city
      t.string :state
      t.string :country
      t.string :address
      t.string :mobile_no
      t.string :ph_no
      t.string :reg_type
      t.string :referral
      t.string :referral_name
      t.string :referral_contact_no
      t.string :name
      t.string :ph_no
      t.string :ins_company_name
      t.string :policy_no
      t.string :relation_to_insurence
      t.string :plan_name
      t.string :arogyasree_card_no
      t.string :userid
      t.timestamps
    end
  end

  def self.down
    drop_table :registrations
  end
end
