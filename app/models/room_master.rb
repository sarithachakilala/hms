class RoomMaster < ActiveRecord::Base
	validates_presence_of :name, :no_of_beds
end
