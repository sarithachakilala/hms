class CreateAgencyMasters < ActiveRecord::Migration
  def self.up
    create_table :agency_masters do |t|
      t.string :org_code
      t.string :org_location
      t.string :agency_name
      t.string :agency_tin_no
      t.string :vat_no
      t.string :list_of_items_supplied
      t.string :address
      t.string :city
      t.string :state
      t.string :country
      t.string :contact_person
      t.string :agency_email
      t.string :contact_no
      t.string :status
      t.text :note

      t.timestamps
    end
  end

  def self.down
    drop_table :agency_masters
  end
end
