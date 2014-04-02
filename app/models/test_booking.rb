class TestBooking < ActiveRecord::Base
	has_many :test_booking_child, :dependent => :destroy
	accepts_nested_attributes_for :test_booking_child, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }	

	validates_presence_of :patient_type, :lab_no, :mr_no, :patient_name, :bill_no, :total_amount,:grand_total
acts_as_reportable
	$key_data
	def store_key(key_value)
		$key_data=key_value
	end
	def return_key
		return $key_data
	end

	#to generate barcode Id
	def find_test_no()
		@test=TestBooking.last
		@number=NumberMaster.last
		test_no_prefix=@number.barcode_id	
		str=""
		if(@test)
			@test_no=@test.barcode_id

			test=test_no_prefix+@number.barcode_length
			test_no_prefix<<@test.barcode_id.slice!(test_no_prefix.length..test.length).next
			return test_no_prefix
		else
			
			test_no_prefix<<@number.barcode_id.to_s<<@number.barcode_length.to_s
			puts test_no_prefix
			return test_no_prefix

		end
	end

end
