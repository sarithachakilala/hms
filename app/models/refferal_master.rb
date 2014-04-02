class RefferalMaster < ActiveRecord::Base
	validates_presence_of :ph_no, :refferal_name
	validates_numericality_of :ph_no
	validates_length_of :ph_no, :is=>10 
end
