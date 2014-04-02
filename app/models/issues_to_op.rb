class IssuesToOp < ActiveRecord::Base
	acts_as_reportable
	validates_presence_of :issue_date, :patient_name
	has_many :issue_op_child, :dependent => :destroy
	accepts_nested_attributes_for :issue_op_child, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }	

	$key_data
	def store_key(key_value)
		$key_data=key_value
	end
	def return_key
		return $key_data
	end
	
end
