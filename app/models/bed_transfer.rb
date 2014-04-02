class BedTransfer < ActiveRecord::Base
validates_presence_of :to_room, :to_bed, :to_floor, :transfer_type,:admn_no
end
