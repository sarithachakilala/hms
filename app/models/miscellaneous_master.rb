class MiscellaneousMaster < ActiveRecord::Base
	has_many :miscellaneous_child, :dependent => :destroy
	accepts_nested_attributes_for :miscellaneous_child, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }	

	validates_presence_of :mis_no, :voucher_no, :date, :department, :total_amount, :authorized_by, :employee

	def find_mis_no()
		@miscellaneous_master=MiscellaneousMaster.last
		number_master=NumberMaster.last
		starting_string_mis=number_master.mis_voucher_no
		starting_string_mis1=number_master.mis_suffix
		str=""

		if(@miscellaneous_master)
			mis_no=starting_string_mis+number_master.ip_no_length
			starting_string_mis<<@miscellaneous_master.mis_no.slice!(starting_string_mis.length..mis_no.length).next
			return starting_string_mis
		else
			starting_string_mis<<number_master.mis_no_length<<number_master.mis_suffix
			return starting_string_mis
		end
	end
end

