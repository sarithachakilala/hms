class Goodsrecieptnotemaster < ActiveRecord::Base
	validates_presence_of :agency_name, :invoice_number, :invoice_date, :type_pay
	has_many :store_child, :dependent => :destroy
	accepts_nested_attributes_for :store_child, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { attrs[:item_name].blank? } }		 
	def self.per_page
      		3
	end
	acts_as_reportable
	$key_data
	def store_key(key_value)
		$key_data=key_value
	end
	def return_key
		return $key_data
	end
	after_save :update_child_records

	def update_child_records
		for store in self.store_child
			@store_child=StoreChild.find_by_id(store.id)
			@item=Itemmaster.find_by_product_name(store.item_name)
			qty=(store.sheets.to_f+store.free.to_f)*@item.units.to_i
			unit=@item.units.to_i
			sale_rate=(store.mrp).to_f/(unit).to_f
			StoreChild.update(store.id, :issued_quantity => 0, :quantity => qty, :received_quantity => qty, :sale_rate=>sale_rate, :units=>unit)
			
			
		end
	   
	end
	after_update :update_child_records
	def find_mr_no()
		@goosd= Goodsrecieptnotemaster.last
		number_master=NumberMaster.last
		starting_string_entry=number_master.entry_no
	
		str=""
		if(@goosd)
			entry=starting_string_entry+number_master.entry_no_length
			
			starting_string_entry<<@goosd.entry_no.slice!(starting_string_entry.length..entry.length).next
			
			return starting_string_entry
		else
			starting_string_entry<< number_master.entry_no_length.to_s
			return starting_string_entry
		end
	end



end
