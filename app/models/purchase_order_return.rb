class PurchaseOrderReturn < ActiveRecord::Base
validates_presence_of :agency_names
has_many :purchase_order_return_children, :dependent => :destroy
	accepts_nested_attributes_for :purchase_order_return_children, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }	
end
