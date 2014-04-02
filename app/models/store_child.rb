class StoreChild < ActiveRecord::Base
belongs_to :goodsrecieptnotemaster
belongs_to :purchase_order_return
acts_as_reportable
	$key_data
	def store_key(key_value)
		$key_data=key_value
	end
	def return_key
		return $key_data
	end
	
	end
