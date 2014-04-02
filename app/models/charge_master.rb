class ChargeMaster < ActiveRecord::Base
has_many :charge_master_children, :dependent=> :destroy
accepts_nested_attributes_for :charge_master_children, :allow_destroy =>:true, :reject_if =>proc { |attrs| attrs.all? { |k, v| v.blank? } }
validates_presence_of :service_group
end