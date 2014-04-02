class PackageMasterMajestic < ActiveRecord::Base

validates_presence_of :category, :sub_category, :days
	has_many :package_master_majestic_children ,  :dependent => :destroy
	accepts_nested_attributes_for :package_master_majestic_children, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
end
