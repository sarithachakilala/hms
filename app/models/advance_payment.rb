class AdvancePayment < ActiveRecord::Base

	
validates_presence_of :admn_no, :gross_amount
		def payment_details(admn_no,org_code,bill_time,category)
		investigation_charges=0
		consultation_charges=0
		general_services=0
		ot_charge=0
		pre_charge=0
		advance=0
		nurse_chage=0
		issue_amount=0
		@admission=Admission.find_by_admn_no_and_org_code(admn_no,org_code)
		@advance=AdvancePayment.sum(:gross_amount, :conditions => "admn_no = '#{admn_no}' and org_code = '#{org_code}'")
		@investigation_charges=TestBooking.sum(:grand_total, :conditions => "admn_no = '#{admn_no}'AND org_code = '#{org_code}'")
		consultation_visit=ConsultantVisit.last(:conditions => " admn_no = '#{admn_no}'AND org_code = '#{org_code}'")
		consultation_charges=0
		if(consultation_visit)
			consultation_charges=ConsultantVisitChild.sum(:charge,:conditions => "consultant_visit_id = '#{consultation_visit.id}'")
		end	
		@ward=BedTransfer.all(:conditions => " admn_no ='#{admn_no}' and org_code = '#{org_code}'")
		@issue_to_ip=IssuesToOp.sum(:total_amount, :conditions => "admn_no = '#{admn_no}' AND org_code = '#{org_code}'")
		general_services=0

		if(@ward[0])
			amount=0
			nurse_chage=0
			
			for ward in @ward
				if(ward.no_of_days==0)
					ward_cost=WardMaster.find_by_name_and_org_code(ward.from_ward,ward.org_code)
					to_ward_cost=WardMaster.find_by_name_and_org_code(ward.to_ward,ward.org_code)
					if(ward_cost.nurse_chage>to_ward_cost.nurse_chage)
						amount=ward_cost.cost+amount
						nurse_chage=ward_cost.nurse_chage+nurse_chage
					else
						amount=to_ward_cost.cost+amount
						nurse_chage=ward_cost.nurse_chage+nurse_chage
					end
				else
					ward_cost=WardMaster.find_by_name_and_org_code(ward.from_ward,ward.org_code)
					to_ward_cost=WardMaster.find_by_name_and_org_code(ward.to_ward,ward.org_code)
					if(ward_cost.nurse_chage>to_ward_cost.nurse_chage)
						amount=ward_cost.cost+amount
						nurse_chage=ward_cost.nurse_chage+nurse_chage
					else
						amount=to_ward_cost.cost+amount
						nurse_chage=ward_cost.nurse_chage+nurse_chage
					end
				end
				old_date=(ward.transfer_date).to_date
			end
			ward_cost=WardMaster.find_by_name_and_org_code(@admission.ward,@admission.org_code)
			bed_charge=amount+(Date.today-old_date)*ward_cost.cost
			if(category=="poor")
				total=amount.to_i
			else
				total=bed_charge.to_i+@investigation_charges.to_i+consultation_charges.to_i+ot_charge.to_i+nurse_chage.to_i+general_services.to_i+@issue_to_ip.to_i
			end
			if(@advance)
				advance=@advance
				due=total-(advance)
			else
				advance=@admission.reg_fee.to_f
				due=total-@admission.reg_fee.to_f
			end
		else
			@ward=WardMaster.find_by_name_and_org_code(@admission.ward,@admission.org_code)
			date=@admission.admn_date
			today=Date.today
			days=0
			if(date.to_s==today.to_s)
				days=1
			else
				#discharge_times=DischargeTime.find_by_org_code(@admission.org_code)
				days=((today-date.to_date).to_i)+1
				
			end
			ward_cost=WardMaster.find_by_name_and_org_code(@admission.ward,@admission.org_code)

			nurse_chage=(days.to_i*ward_cost.nurse_chage)
			
			if(category=="poor")
				total=days*@ward.cost.to_i
			else
				total=(days*@ward.cost.to_i)+consultation_charges.to_i+ot_charge.to_i+general_services.to_i+@investigation_charges.to_i+@issue_to_ip.to_i+nurse_chage.to_i+@issue_to_ip.to_f
				bed_charge=days*@ward.cost.to_i
			end
			if(@advance)
				advance=@advance
				due=total-(advance)
			else
				advance=0
				due=total-advance
			end
		end

		return total,advance,due,nurse_chage.to_f,ot_charge.to_i,bed_charge,consultation_charges.to_i,@investigation_charges.to_i,@issue_to_ip.to_f
	end
end
