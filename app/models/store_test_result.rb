class StoreTestResult < ActiveRecord::Base
	has_many :store_test_result_children ,  :dependent => :destroy
	accepts_nested_attributes_for :store_test_result_children, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
end
