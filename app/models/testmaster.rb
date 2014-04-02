class Testmaster < ActiveRecord::Base
	has_many :testmaster_child
	 accepts_nested_attributes_for :testmaster_child, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { attrs[:paramaters].blank? } }
	 
validates_presence_of :department_name, :test_name,:investigation

	 
 end
