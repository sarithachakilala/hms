
pdf.instance_eval do
   def write(some_text, style=:text)
      text some_text, :size=>font_size[style]
   end
   def separator
      write " ", :text
      stroke {y=@y-25; line [1,y], [bounds.width,y]}
      write " ", :text
   end
end
home=Home.last
if(home)
	prawn_logo = "public/images/#{home.image_path}"
else
	prawn_logo = "public/images/hs-gol.png"
end

pdf.move_down(10)
@org=OrgMasterChildTable.last
if(@org)
	address=@org.address.split(";")
	for i in 0...address.length
		if(i==0)
			pdf.text "<b>#{address[i]}</b>", :align => :center, :inline_format => true
		else
			pdf.text "#{address[i]}", :align => :center, :inline_format => true
		end	
	end	
end

pdf.image prawn_logo, :at => [10, 800],:width => 110, :height => 50


pdf.stroke do
pdf.rounded_rectangle [-4, 810], 585, 820, 10
line_no=730
	pdf.move_down(15)
	line_end=555
	difference=20
	total=0
	@consultant=ConsultantMaster.find_by_consultant_id(@admission.consultant_id)
	pdf.line [-5,725], [line_end,725]
	pdf.line [-5,635], [line_end,635]
	pdf.draw_text "Bill No", :at => [0, line_no-1*difference], :size =>10
	pdf.draw_text "Admn.No", :at => [0, line_no-2*difference], :size =>10
	pdf.draw_text "Patient Name", :at => [0, line_no-3*difference] , :size =>10
	pdf.draw_text "Consultant", :at => [0, line_no-4*difference], :size =>10
		
	for i  in 1..4
		pdf.draw_text " : ", :at => [100, line_no-i*difference] 
	end
	pdf.draw_text " #{@final_bill.receipt_no} ", :at => [110, line_no-1*difference] 
	pdf.draw_text " #{@final_bill.admn_no}/#{Time.new.year-2000} ", :at => [110, line_no-2*difference] 
	pdf.draw_text " #{@registration.title+"."+@registration.patient_name	} ", :at => [110, line_no-3*difference]
	pdf.draw_text " #{@consultant.consultant_id} ", :at => [110, line_no-4*difference]
	
	pdf.draw_text "Admn.Date", :at => [320, line_no-1*difference] , :size =>10
	pdf.draw_text "Dis.Date", :at => [320, line_no-2*difference] , :size =>10
	pdf.draw_text "Age/Sex", :at => [320, line_no-3*difference] , :size =>10
	pdf.draw_text "No Of Days", :at => [320, line_no-4*difference] , :size =>10
	
	for i  in 1..4
		pdf.draw_text " : ", :at => [400, line_no-i*difference] 
	end
	pdf.draw_text " #{@admission.admn_date.strftime("%d/%m/%Y")} ", :at => [410, line_no-1*difference]
if((@final_bill.final_bill_date) && 	(@final_bill.final_bill_time))
	pdf.draw_text " #{@final_bill.final_bill_date.strftime("%d/%m/%Y")}  #{@final_bill.final_bill_time.strftime("%H:%M")}", :at => [410, line_no-2*difference]
	end
	pdf.draw_text " #{@registration.age}  #{@registration.age_in}/ #{@registration.gender} ", :at => [410, line_no-3*difference] 
	if((@final_bill.final_bill_date-@admission.admn_date)==0)
		patient_days=1
	else
		patient_days=(@final_bill.final_bill_date-@admission.admn_date)
	end
	
	pdf.draw_text " #{patient_days} ", :at => [410, line_no-4*difference]
	
	charge_line=6
	if(@admission.admn_category!="Package")
	pdf.draw_text "Room/Bed Charges ", :at => [0, line_no-charge_line*difference] , :size =>10
	charge_line=charge_line+1
	@bed_transfer=BedTransfer.find(:all, :conditions => "admn_no = '#{@admission.admn_no}'")
	if(@bed_transfer[0])
		for bed_transfer in @bed_transfer
			if(bed_transfer.no_of_days!=0)
				@wardmaster=WardMaster.find_by_name(bed_transfer.from_ward)
				pdf.draw_text "#{bed_transfer.from_ward} ", :at => [50, line_no-charge_line*difference] , :size =>10
				pdf.draw_text "( #{(bed_transfer.no_of_days)} *  #{number_with_precision(@wardmaster.cost, :precision => 2, :separator =>".")} )", :at => [250, line_no-charge_line*difference] , :size =>10
				pdf.draw_text "( #{bed_transfer.transfer_date.strftime('%d.%m.%Y')}- #{bed_transfer.transfer_date.strftime('%d.%m.%Y')} )", :at => [120, line_no-charge_line*difference] , :size =>10
				if(((bed_transfer.no_of_days*@wardmaster.cost).to_i).to_s.length==1)
					pdf.draw_text "#{number_with_precision(bed_transfer.no_of_days*@wardmaster.cost, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
				elsif(((bed_transfer.no_of_days*@wardmaster.cost).to_i).to_s.length==2)
					pdf.draw_text "#{number_with_precision(bed_transfer.no_of_days*@wardmaster.cost, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
				elsif(((bed_transfer.no_of_days*@wardmaster.cost).to_i).to_s.length==3)
					pdf.draw_text "#{number_with_precision((bed_transfer.no_of_days)*@wardmaster.cost, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
				else	
					pdf.draw_text "#{number_with_precision(bed_transfer.no_of_days*@wardmaster.cost, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
				end	
				total=total+(bed_transfer.no_of_days*@wardmaster.cost)
				charge_line=charge_line+1
				date=bed_transfer.transfer_date
			end
		end
		wardmaster=WardMaster.find_by_name(@admission.ward)
		pdf.draw_text "#{@admission.ward} ", :at => [50, line_no-charge_line*difference] , :size =>10
		pdf.draw_text "( #{date.strftime('%d.%m.%Y')}- #{@final_bill.final_bill_date.strftime('%d.%m.%Y')} )", :at => [120, line_no-charge_line*difference] , :size =>10
		if((@final_bill.final_bill_date-date)==0)
			days=1
		else
			days=(@final_bill.final_bill_date-date)
		end
		if(days.to_s.length==1)
			pdf.draw_text "( #{days} *  #{number_with_precision(10, :precision => 2, :separator =>".")} )", :at => [255, line_no-charge_line*difference] , :size =>10
		else
			pdf.draw_text "( #{days} *  #{number_with_precision(10, :precision => 2, :separator =>".")} )", :at => [250, line_no-charge_line*difference] , :size =>10
		end
		if(((days*10).to_i).to_s.length==1)
			pdf.draw_text "#{number_with_precision(days*10, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
		elsif(((days*10).to_i).to_s.length==2)
			pdf.draw_text "#{number_with_precision(days*10, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
		elsif(((days*10).to_i).to_s.length==3)
			pdf.draw_text "#{number_with_precision(days*10, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
		else	
			pdf.draw_text "#{number_with_precision(days*10, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
		end	
		total=total+(days*10)
		charge_line=charge_line+1
	else
		wardmaster=WardMaster.find_by_name(@admission.ward)
		pdf.draw_text "#{@admission.ward} ", :at => [50, line_no-charge_line*difference] , :size =>10
		
		if((@final_bill.final_bill_date-@admission.admn_date)==0)
			tot_days=1
		else
			tot_days=@final_bill.final_bill_date-@admission.admn_date
		end
		pdf.draw_text "( #{@admission.admn_date.strftime('%d.%m.%Y')}- #{@final_bill.final_bill_date.strftime('%d.%m.%Y')} )", :at => [120, line_no-charge_line*difference] , :size =>10
		if((@final_bill.final_bill_date-@admission.admn_date).to_s.length==1)
			pdf.draw_text "( #{tot_days} *  #{number_with_precision(10, :precision => 2, :separator =>".")} )", :at => [250, line_no-charge_line*difference] , :size =>10
		else
			pdf.draw_text "( #{tot_days} *  #{number_with_precision(10, :precision => 2, :separator =>".")} )", :at => [250, line_no-charge_line*difference] , :size =>10
		end
		if((10.to_i).to_s.length==1)
			pdf.draw_text "#{number_with_precision(()*10, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
		elsif((10.to_i).to_s.length==2)
			pdf.draw_text "#{number_with_precision(tot_days*10, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
		elsif((10.to_i).to_s.length==3)
			pdf.draw_text "#{number_with_precision(tot_days*10, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
		else	
			pdf.draw_text "#{number_with_precision(tot_days*10, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
		end	
		total=total+(tot_days*10)
		charge_line=charge_line+2
	end
	
	pdf.draw_text "Nursing & Service Charges ", :at => [0, line_no-charge_line*difference] , :size =>10
	charge_line=charge_line+1
	@bed_transfer=BedTransfer.find(:all, :conditions => "admn_no = '#{@admission.admn_no}'")
	if(@bed_transfer[0])
		for bed_transfer in @bed_transfer
			if(bed_transfer.no_of_days!=0)
				wardmaster=WardMaster.find_by_name(bed_transfer.from_ward)
				pdf.draw_text "#{bed_transfer.from_ward} ", :at => [50, line_no-charge_line*difference] , :size =>10
				pdf.draw_text "( #{(bed_transfer.no_of_days)} *  #{number_with_precision(10, :precision => 2, :separator =>".")} )", :at => [250, line_no-charge_line*difference] , :size =>10
				pdf.draw_text "( #{bed_transfer.be_trans_date.strftime('%d.%m.%Y')}- #{bed_transfer.trans_date.strftime('%d.%m.%Y')} )", :at => [120, line_no-charge_line*difference] , :size =>10
				if(((bed_transfer.no_of_days*10).to_i).to_s.length==1)
					pdf.draw_text "#{number_with_precision(bed_transfer.no_of_days*10, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
				elsif(((bed_transfer.no_of_days*10).to_i).to_s.length==2)
					pdf.draw_text "#{number_with_precision(bed_transfer.no_of_days*10, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
				elsif(((bed_transfer.no_of_days*10).to_i).to_s.length==3)
					pdf.draw_text "#{number_with_precision((bed_transfer.no_of_days)*10, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
				else	
					pdf.draw_text "#{number_with_precision(bed_transfer.no_of_days*10, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
				end	
				total=total+(bed_transfer.no_of_days*10)
				charge_line=charge_line+1
				date=bed_transfer.trans_date
			end
		end
		wardmaster=WardMaster.find_by_name(@admission.ward)
		pdf.draw_text "#{@admission.ward} ", :at => [50, line_no-charge_line*difference] , :size =>10
		pdf.draw_text "( #{date.strftime('%d.%m.%Y')}- #{@final_bill.final_bill_date.strftime('%d.%m.%Y')} )", :at => [120, line_no-charge_line*difference] , :size =>10
		if((@final_bill.final_bill_date-date)==0)
			days=1
		else
			days=(@final_bill.final_bill_date-date)
		end
		if(days.to_s.length==1)
			pdf.draw_text "( #{days} *  #{number_with_precision(10, :precision => 2, :separator =>".")} )", :at => [255, line_no-charge_line*difference] , :size =>10
		else
			pdf.draw_text "( #{days} *  #{number_with_precision(10, :precision => 2, :separator =>".")} )", :at => [250, line_no-charge_line*difference] , :size =>10
		end
		if(((days*10).to_i).to_s.length==1)
			pdf.draw_text "#{number_with_precision(days*10, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
		elsif(((days*10).to_i).to_s.length==2)
			pdf.draw_text "#{number_with_precision(days*10, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
		elsif(((days*10).to_i).to_s.length==3)
			pdf.draw_text "#{number_with_precision(days*10, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
		else	
			pdf.draw_text "#{number_with_precision(days*10, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
		end	
		total=total+(days*10)
		charge_line=charge_line+1
	else
		wardmaster=WardMaster.find_by_name(@admission.ward)
		pdf.draw_text "#{@admission.ward} ", :at => [50, line_no-charge_line*difference] , :size =>10
		if((@final_bill.final_bill_date-@admission.admn_date)==0)
			tot_days=1
		else
			tot_days=@final_bill.final_bill_date-@admission.admn_date
		end
		pdf.draw_text "( #{@admission.admn_date.strftime('%d.%m.%Y')}- #{@final_bill.final_bill_date.strftime('%d.%m.%Y')} )", :at => [120, line_no-charge_line*difference] , :size =>10
		pdf.draw_text "( #{tot_days} *  #{number_with_precision(10, :precision => 2, :separator =>".")} )", :at => [250, line_no-charge_line*difference] , :size =>10
		
		if(((tot_days*10).to_i).to_s.length==1)
			pdf.draw_text "#{number_with_precision(tot_days*10, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
		elsif(((tot_days*10).to_i).to_s.length==2)
			pdf.draw_text "#{number_with_precision(tot_days*10, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
		elsif(((tot_days*10).to_i).to_s.length==3)
			pdf.draw_text "#{number_with_precision(tot_days*10, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
		else	
			pdf.draw_text "#{number_with_precision(tot_days*10, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
		end	
		total=total+((@final_bill.final_bill_date-@admission.admn_date)*10)
		charge_line=charge_line+2
	end
	
	pdf.draw_text "Investigation Charges ", :at => [0, line_no-charge_line*difference] , :size =>10
		if((@final_bill.lab_amount.to_i).to_s.length==1)
			pdf.draw_text "#{number_with_precision(@final_bill.lab_amount, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
		elsif((@final_bill.lab_amount.to_i).to_s.length==2)
			pdf.draw_text "#{number_with_precision(@final_bill.lab_amount, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
		elsif((@final_bill.lab_amount.to_i).to_s.length==3)
			pdf.draw_text "#{number_with_precision(@final_bill.lab_amount, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
		else	
			pdf.draw_text "#{number_with_precision(@final_bill.lab_amount, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
		end	
		if(@final_bill.lab_amount)
		total=total+@final_bill.lab_amount
		end
	charge_line=charge_line+1
	
	pdf.draw_text "Consultant Visit ", :at => [0, line_no-charge_line*difference] , :size =>10
	consultant_visit=ConsultantVisit.find(:all,:conditions => "admn_no ='#{@final_bill.admn_no}'")
	if(consultant_visit[0])
	pdf.draw_text "( #{consultant_visit.length} *  #{number_with_precision(consultant_visit[0].charge, :precision => 2, :separator =>".")} )", :at => [250, line_no-charge_line*difference] , :size =>10
		con_amount=consultant_visit.length*consultant_visit[0].charge.to_f
		if((con_amount.to_i).to_s.length==1)
			pdf.draw_text "#{number_with_precision(con_amount, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
		elsif((con_amount.to_i).to_s.length==2)
			pdf.draw_text "#{number_with_precision(con_amount, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
		elsif((con_amount.to_i).to_s.length==3)
			pdf.draw_text "#{number_with_precision(con_amount, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
		else	
			pdf.draw_text "#{number_with_precision(con_amount, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
		end	
		total=total+con_amount
		charge_line=charge_line+1
	end
	for final_charge in @final_bill.final_charges
		if(final_charge.charge!=0)
			pdf.draw_text "#{final_charge.charge_type}", :at => [0, line_no-charge_line*difference] , :size =>9
			if((final_charge.charge.to_i).to_s.length==1)
				pdf.draw_text "#{number_with_precision(final_charge.charge, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
			elsif((final_charge.charge.to_i).to_s.length==2)
				pdf.draw_text "#{number_with_precision(final_charge.charge, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
			elsif((final_charge.charge.to_i).to_s.length==3)
				pdf.draw_text "#{number_with_precision(final_charge.charge, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
			else	
				pdf.draw_text "#{number_with_precision(final_charge.charge, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
			end	
			total=total+final_charge.charge
			charge_line=charge_line+1
		end
	end
	charge_line=charge_line+1
	pdf.draw_text "TOTAL   : ", :at => [150, line_no-charge_line*difference] , :size =>10
		
		if((total.to_i).to_s.length==1)
			pdf.draw_text "#{number_with_precision(total, :precision => 2)}", :at =>[515,line_no-charge_line*difference], :size =>10
		elsif((total.to_i).to_s.length==2)
			pdf.draw_text "#{number_with_precision(total, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
		elsif((total.to_i).to_s.length==3)
			pdf.draw_text "#{number_with_precision(total, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
		elsif((total.to_i).to_s.length==4)
			pdf.draw_text "#{number_with_precision(total, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10	
		else	
			pdf.draw_text "#{number_with_precision(total, :precision => 2, :separator =>".")}", :at => [495,line_no-charge_line*difference], :size =>10
		end	
		charge_line=charge_line+2
		
		
elsif(@admission.admn_category=="Package")
	
		charge_line=charge_line+1
	pdf.draw_text " PACKAGE TOTAL  AMOUNT : ", :at => [0, line_no-charge_line*difference] , :size =>10
		total=@admission.amount
		if((total.to_i).to_s.length==1)
			pdf.draw_text "#{number_with_precision(total, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
		elsif((total.to_i).to_s.length==2)
			pdf.draw_text "#{number_with_precision(total, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
		elsif((total.to_i).to_s.length==3)
			pdf.draw_text "#{number_with_precision(total, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
		elsif((total.to_i).to_s.length==4)
			pdf.draw_text "#{number_with_precision(total, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10	
		else	
			pdf.draw_text "#{number_with_precision(total, :precision => 2, :separator =>".")}", :at => [495,line_no-charge_line*difference], :size =>10
		end	

	
	end
	charge_line=charge_line+2
	pdf.draw_text "Advance", :at => [0, line_no-charge_line*difference] , :size =>10
	@advance=AdvancePayment.find(:all,:conditions => "admn_no = '#{@final_bill.admn_no}'")
	charge_line=charge_line+1
	for advance in @advance
		if(advance.gross_amount)
			pdf.draw_text "#{advance.advance_date.strftime('%d.%m.%Y')} ", :at => [50, line_no-charge_line*difference] , :size =>10
		if(((advance.gross_amount).to_i).to_s.length==1)
			pdf.draw_text "#{number_with_precision(advance.gross_amount, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
		elsif(((advance.gross_amount).to_i).to_s.length==2)
			pdf.draw_text "#{number_with_precision(advance.gross_amount, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
		elsif(((advance.gross_amount).to_i).to_s.length==3)
			pdf.draw_text "#{number_with_precision(advance.gross_amount, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
		else	
			pdf.draw_text "#{number_with_precision(advance.gross_amount, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
		end	
		charge_line=charge_line+1
	end
	end
	charge_line=charge_line+1
	pdf.line [-5,line_no-charge_line*difference], [line_end,line_no-charge_line*difference]
	charge_line=charge_line+1
	pdf.draw_text "NET AMOUNT           : ", :at => [0, line_no-charge_line*difference] , :size =>10
	if((@final_bill.due.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.due, :precision => 2, :separator =>".")}", :at =>[515,line_no-charge_line*difference], :size =>10
	elsif((@final_bill.due.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.due, :precision => 2, :separator =>".")}", :at => [510,line_no-charge_line*difference], :size =>10
	elsif((@final_bill.due.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.due, :precision => 2, :separator =>".")}", :at => [505,line_no-charge_line*difference], :size =>10
	else	
		pdf.draw_text "#{number_with_precision(@final_bill.due, :precision => 2, :separator =>".")}", :at => [500,line_no-charge_line*difference], :size =>10
	end	
	charge_line=charge_line+1
	pdf.line [-5,line_no-charge_line*difference], [line_end,line_no-charge_line*difference]
	
	pdf.draw_text "Signature of Patient ", :at => [0, 0] , :size =>10
	pdf.draw_text "Authorised Signature ", :at => [400, 0] , :size =>10
end
