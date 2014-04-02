class CreateTestmasterChildren < ActiveRecord::Migration
  def self.up
    create_table :testmaster_children do |t|
      t.integer :testmaster_id
      t.string :paramaters
      t.string :field_type
      t.string :normal_range
      t.string :unit

      t.timestamps
    end
  end

  def self.down
    drop_table :testmaster_children
  end
end
