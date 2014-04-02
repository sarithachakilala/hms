class ModulesList < ActiveRecord::Base
	validates_presence_of :module_name, :position	
	has_many :module_list_children,  :dependent => :destroy
	accepts_nested_attributes_for :module_list_children, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { attrs[:form_name].blank? } }
end
