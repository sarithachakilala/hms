class WardMaster < ActiveRecord::Base
validates_presence_of :name, :cost
validates_format_of :name, :with =>/^[A-Za-z.*\z]|[A-ZA-Z1+]/
validates_numericality_of :no_of_rooms
end
