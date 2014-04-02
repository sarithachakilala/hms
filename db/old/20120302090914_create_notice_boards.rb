class CreateNoticeBoards < ActiveRecord::Migration
  def self.up
    create_table :notice_boards do |t|
      t.date :notice_date
      t.time :notice_time
      t.string :department
      t.text :notice

      t.timestamps
    end
  end

  def self.down
    drop_table :notice_boards
  end
end
