class ConsultantMaster < ActiveRecord::Base
	 has_many :ward_cost , :dependent => :destroy
	 accepts_nested_attributes_for :ward_cost, :allow_destroy => :true, :reject_if => proc {|attrs| attrs.all? {|k,v| v.blank?}} 
	validates_presence_of :consultant_type, :consultant_id, :payment_type, :charge_type
	 
 end
