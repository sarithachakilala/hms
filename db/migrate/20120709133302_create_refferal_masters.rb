class CreateRefferalMasters < ActiveRecord::Migration
  def self.up
    create_table :refferal_masters do |t|
      t.string :refferal_name
      t.string :email
      t.string :ph_no
      t.string :org_code
      t.string :org_loaction
      t.string :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :refferal_masters
  end
end
