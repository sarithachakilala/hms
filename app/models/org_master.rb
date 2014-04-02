class OrgMaster < ActiveRecord::Base
	has_many :org_master_child_tables ,  :dependent => :destroy
	accepts_nested_attributes_for :org_master_child_tables, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
end
