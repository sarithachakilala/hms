class PharmacyPayment < ActiveRecord::Base
validates_presence_of :agency_name
acts_as_reportable
	has_many :pharmacy_payment_children,  :dependent => :destroy
	accepts_nested_attributes_for :pharmacy_payment_children, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { attrs[:invoice_no]=="" } }
	$key_data
	def store_key(key_value)
		$key_data=key_value
	end
	def return_key
		return $key_data
	end


after_save :change_status_of_purchase_invoice
	after_update :change_status_of_purchase_invoice

	def change_status_of_purchase_invoice
		for payment_child in self. pharmacy_payment_children
			if(payment_child.status=="on" || payment_child.status=="1")
				purchase_invoice=Goodsrecieptnotemaster.find_by_invoice_number_and_invoice_date_and_type_pay(payment_child.invoice_no,payment_child.invoice_date,'Credit')
			if(purchase_invoice)
				if(payment_child.balance==0)
					Goodsrecieptnotemaster.update(purchase_invoice.id, :type_pay => "Cash")
				else
					Goodsrecieptnotemaster.update(purchase_invoice.id, :due => payment_child.balance, :paid_amount => payment_child.received)
				end
			end
			end
		end
	end
	
end
