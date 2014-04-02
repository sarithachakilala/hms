class FinalBill < ActiveRecord::Base
	validates_presence_of :admn_no, :mr_no
	acts_as_reportable
	has_many :registrations
	
	has_many :final_charges, :dependent => :destroy
	accepts_nested_attributes_for :final_charges , :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }	
end
