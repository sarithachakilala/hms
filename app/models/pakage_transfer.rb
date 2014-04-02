class PakageTransfer < ActiveRecord::Base
	validates_presence_of :admn_no, :mr_no, :e_cat, :e_subcat, :days, :amount, :trans_cat, :trans_subcat, :t_days, :t_amount	
end
