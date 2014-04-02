class CreateDischargeSummaries < ActiveRecord::Migration
  def self.up
    create_table :discharge_summaries do |t|
     
      t.string :admn_no
      t.string :mr_no
      t.date :discharge_date
      t.time :time
      t.string :discharge_consultant
      t.string :status
      t.string :medicine
      t.text :summary
      t.date :review_date
      t.time :time1
      t.text :remarks
      t.string :org_code
      t.string :org_location

      t.timestamps
    end
  end

  def self.down
    drop_table :discharge_summaries
  end
end
