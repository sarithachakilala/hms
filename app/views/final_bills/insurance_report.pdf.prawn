
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
pdf.font_size =9
home=Home.last
	if(home)
		prawn_logo = "#{home.image_path}"

	else
		prawn_logo = "public/images/hs-gol.png"
	end
pdf.image prawn_logo, :width => 200, :height => 30
pdf.rounded_rectangle [0, 810], 580, 820, 10
@org=OrgMasterChildTable.last
	if(@org)
			pdf.text "<b>#{@org.address}</b>", :size => 13, :align => :center, :inline_format => true
			pdf.text "<b>PHONE : #{@org.ph_no}<b>", :size => 10, :align => :center, :inline_format => true
			pdf.text "<b>Email : #{@org.email}<b>", :size => 10, :align => :center, :inline_format => true
	end
pdf.stroke do
line_no=710
	pdf.move_down(15)
	line_end=580
	difference=20
	pdf.line [0,748], [line_end,748]
	pdf.text "<font size='12px'><b>FINAL BILL RECEIPT</b></font>" ,:align => :center, :inline_format => true
	
	if(@print_type=="duplicate")
		pdf.draw_text  "(Duplicate)", :at => [500,725] , :size =>10, :style => :bold
	else 
		pdf.draw_text  "(Original)", :at => [500,725] , :size =>10, :style => :bold
	end
	
	pdf.draw_text "Admn.No", :at => [10, line_no-1*difference], :size =>10
	pdf.draw_text "Patient Name", :at => [10, line_no-2*difference] , :size =>10
	pdf.draw_text "Address", :at => [10, line_no-3*difference], :size =>10
	pdf.draw_text "Company Name", :at => [10, line_no-4*difference], :size =>10	
	
	for i  in 1..4
		pdf.draw_text " : ", :at => [140, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@final_bill.admn_no} ", :at => [150, line_no-1*difference], :size =>10 
	pdf.draw_text " #{@registration.first_name}.#{@registration.last_name} ", :at => [150, line_no-2*difference], :size =>10 
	pdf.draw_text " #{@registration.address} ", :at => [150, line_no-3*difference], :size =>10 
	pdf.draw_text " #{@registration.ins_comp_code} ", :at => [150, line_no-4*difference], :size =>10 
	
	pdf.draw_text "Admn.Date/Time", :at => [370, line_no-1*difference] , :size =>10
	pdf.draw_text "Dis.Date/Time", :at => [370, line_no-2*difference] , :size =>10
	pdf.draw_text "Room/Bed", :at => [370, line_no-3*difference] , :size =>10
	pdf.draw_text "Policy Name", :at => [370, line_no-4*difference] , :size =>10
	
	for i  in 1..4
		pdf.draw_text " : ", :at => [448, line_no-i*difference] 
	end

	pdf.draw_text " #{@admission.admn_date.strftime("%d-%m-%Y")}/ #{@admission.admn_time.strftime('%I:%M%p')} ", :at => [450, line_no-1*difference] , :size =>10 
	pdf.draw_text " #{@final_bill.final_bill_date.strftime("%d-%m-%Y")}/ #{@final_bill.finalbill_time.strftime('%I:%M%p')} ", :at => [450, line_no-2*difference], :size =>10 
	pdf.draw_text " #{@admission.room}/ #{@admission.bed} ", :at => [450, line_no-3*difference] , :size =>10 
	pdf.draw_text " #{@registration.plan_name} ", :at => [450, line_no-4*difference] , :size =>10 
	
	l=6
	pdf.draw_text "Room Charges ", :at => [10, line_no-l*difference] , :size =>10
	if((@final_bill.ward_fee.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.ward_fee, :precision => 2, :separator => '.')	}", :at => [520, line_no-l*difference] , :size =>10
	elsif((@final_bill.ward_fee.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.ward_fee, :precision => 2, :separator => '.')	}", :at => [515, line_no-l*difference] , :size =>10
	elsif((@final_bill.ward_fee.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.ward_fee, :precision => 2, :separator => '.')	}", :at => [510, line_no-l*difference] , :size =>10
	elsif((@final_bill.ward_fee.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.ward_fee, :precision => 2, :separator => '.')	}", :at => [505, line_no-l*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.ward_fee, :precision => 2, :separator => '.')	}", :at => [500, line_no-l*difference] , :size =>10
	end

	pdf.draw_text "Nursing Charges  ", :at => [10, line_no-(l+1)*difference] , :size =>10
	if((@final_bill.nurse_fee.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.nurse_fee, :precision => 2, :separator => '.')	}", :at => [520, line_no-(l+1)*difference] , :size =>10
	elsif((@final_bill.nurse_fee.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.nurse_fee, :precision => 2, :separator => '.')	}", :at => [515, line_no-(l+1)*difference] , :size =>10
	elsif((@final_bill.nurse_fee.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.nurse_fee, :precision => 2, :separator => '.')	}", :at => [510, line_no-(l+1)*difference] , :size =>10
	elsif((@final_bill.nurse_fee.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.nurse_fee, :precision => 2, :separator => '.')	}", :at => [505, line_no-(l+1)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.nurse_fee, :precision => 2, :separator => '.')	}", :at => [500, line_no-(l+1)*difference] , :size =>10
	end
		
	pdf.draw_text "Consultant Visits  ", :at => [10, line_no-(l+2)*difference] , :size =>10
	if((@final_bill.doctor_fee.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.doctor_fee, :precision => 2, :separator => '.')	}", :at => [520, line_no-(l+2)*difference] , :size =>10
	elsif((@final_bill.doctor_fee.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.doctor_fee, :precision => 2, :separator => '.')	}", :at => [515, line_no-(l+2)*difference] , :size =>10
	elsif((@final_bill.doctor_fee.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.doctor_fee, :precision => 2, :separator => '.')	}", :at => [510, line_no-(l+2)*difference] , :size =>10
	elsif((@final_bill.doctor_fee.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.doctor_fee, :precision => 2, :separator => '.')	}", :at => [505, line_no-(l+2)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.doctor_fee, :precision => 2, :separator => '.')	}", :at => [500, line_no-(l+2)*difference] , :size =>10
	end
		
	pdf.draw_text "Operating Charges  ", :at => [10, line_no-(l+3)*difference] , :size =>10
	if((@final_bill.operation_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.operation_amount, :precision => 2, :separator => '.')	}", :at => [520, line_no-(l+3)*difference] , :size =>10
	elsif((@final_bill.operation_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.operation_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(l+3)*difference] , :size =>10
	elsif((@final_bill.operation_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.operation_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(l+3)*difference] , :size =>10
	elsif((@final_bill.operation_amount.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.operation_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(l+3)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.operation_amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-(l+3)*difference] , :size =>10
	end
	
	pdf.draw_text "Assistant's Charge  ", :at => [10, line_no-(l+4)*difference] , :size =>10
	if((@final_bill.assistant_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.assistant_amount, :precision => 2, :separator => '.')	}", :at => [520, line_no-(l+4)*difference] , :size =>10
	elsif((@final_bill.assistant_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.assistant_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(l+4)*difference] , :size =>10
	elsif((@final_bill.assistant_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.assistant_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(l+4)*difference] , :size =>10
	elsif((@final_bill.assistant_amount.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.assistant_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(l+4)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.assistant_amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-(l+4)*difference] , :size =>10
	end
		
	pdf.draw_text "OT Charges  ", :at => [10, line_no-(l+5)*difference] , :size =>10
	if((@final_bill.ot_fee.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.ot_fee, :precision => 2, :separator => '.')	}", :at => [520, line_no-(l+5)*difference] , :size =>10
	elsif((@final_bill.ot_fee.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.ot_fee, :precision => 2, :separator => '.')	}", :at => [515, line_no-(l+5)*difference] , :size =>10
	elsif((@final_bill.ot_fee.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.ot_fee, :precision => 2, :separator => '.')	}", :at => [510, line_no-(l+5)*difference] , :size =>10
	elsif((@final_bill.ot_fee.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.ot_fee, :precision => 2, :separator => '.')	}", :at => [505, line_no-(l+5)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.ot_fee, :precision => 2, :separator => '.')	}", :at => [500, line_no-(l+5)*difference] , :size =>10
	end
		
	pdf.draw_text "Anaesthesia Charge  ", :at => [10, line_no-(l+6)*difference] , :size =>10
	if((@final_bill.anaesthesia_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.anaesthesia_amount, :precision => 2, :separator => '.')	}", :at => [520, line_no-(l+6)*difference] , :size =>10
	elsif((@final_bill.anaesthesia_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.anaesthesia_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(l+6)*difference] , :size =>10
	elsif((@final_bill.anaesthesia_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.anaesthesia_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(l+6)*difference] , :size =>10
	elsif((@final_bill.anaesthesia_amount.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.anaesthesia_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(l+6)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.anaesthesia_amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-(l+6)*difference] , :size =>10
	end
		
	i=13
	for final_charge in @final_bill.final_charges
		pdf.draw_text "#{final_charge.charge_type} ", :at => [10, line_no-i*difference] , :size =>10
		if((final_charge.charge.to_i).to_s.length==1)
			pdf.draw_text "#{number_with_precision(final_charge.charge, :precision => 2, :separator => '.')	}", :at => [520, line_no-i*difference] , :size =>10
		elsif((final_charge.charge.to_i).to_s.length==2)
			pdf.draw_text "#{number_with_precision(final_charge.charge, :precision => 2, :separator => '.')	}", :at => [515, line_no-i*difference] , :size =>10
		elsif((final_charge.charge.to_i).to_s.length==3)
			pdf.draw_text "#{number_with_precision(final_charge.charge, :precision => 2, :separator => '.')	}", :at => [510, line_no-i*difference] , :size =>10
		elsif((final_charge.charge.to_i).to_s.length==4)
			pdf.draw_text "#{number_with_precision(final_charge.charge, :precision => 2, :separator => '.')	}", :at => [505, line_no-i*difference] , :size =>10	
		else
			pdf.draw_text "#{number_with_precision(final_charge.charge, :precision => 2, :separator => '.')	}", :at => [500, line_no-i*difference] , :size =>10
		end
		i=i+1
	end
	 
	
	
	pdf.draw_text "Lab Charge ", :at => [10, line_no-(i)*difference] , :size =>10
	if((@final_bill.lab_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.lab_amount, :precision => 2, :separator => '.')	}", :at => [520, line_no-i*difference] , :size =>10
	elsif((@final_bill.lab_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.lab_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-i*difference] , :size =>10
	elsif((@final_bill.lab_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.lab_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-i*difference] , :size =>10
	elsif((@final_bill.lab_amount.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.lab_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-i*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.lab_amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-i*difference] , :size =>10
	end
	
	pdf.draw_text "Medicine Charge ", :at => [10, line_no-(i+1)*difference] , :size =>10
	if((@medicine.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@medicine, :precision => 2, :separator => '.')	}", :at => [520, line_no-(i+1)*difference] , :size =>10
	elsif((@medicine.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@medicine, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+1)*difference] , :size =>10
	elsif((@medicine.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@medicine, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+1)*difference] , :size =>10
	elsif((@medicine.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@medicine, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+1)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@medicine, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+1)*difference] , :size =>10
	end
	
	pdf.draw_text "Miscellaneous Charge ", :at => [10, line_no-(i+2)*difference] , :size =>10
	if((@final_bill.miscellaneous_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [520, line_no-(i+2)*difference] , :size =>10
	elsif((@final_bill.miscellaneous_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+2)*difference] , :size =>10
	elsif((@final_bill.miscellaneous_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+2)*difference] , :size =>10
	elsif((@final_bill.miscellaneous_amount.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+2)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+2)*difference] , :size =>10
	end
		
	pdf.line [10,line_no-(i+3)*difference],[550,line_no-(i+3)*difference]
	pdf.draw_text "Total ", :at => [400, line_no-(i+4)*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.gross_amount, :precision => 2, :separator => '.')}", :at => [500, line_no-(i+4)*difference] , :size =>10
	
	pdf.draw_text "Discount ", :at => [400, line_no-(i+5)*difference] , :size =>10
	
	if((@final_bill.concession.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+5)*difference] , :size =>10
	elsif((@final_bill.concession.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+5)*difference] , :size =>10
	elsif((@final_bill.concession.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+5)*difference] , :size =>10
	else
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+5)*difference] , :size =>10
	end
	
	pdf.draw_text "Advance ", :at => [400, line_no-(i+6)*difference] , :size =>10
	
	if((@final_bill.advance.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+6)*difference] , :size =>10
	elsif((@final_bill.advance.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+6)*difference] , :size =>10
	elsif((@final_bill.advance.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+6)*difference] , :size =>10
	else
		pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+6)*difference] , :size =>10
	end
	
	pdf.draw_text "Due ", :at => [400, line_no-(i+7)*difference] , :size =>10
	
	if((@final_bill.balance_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+7)*difference] , :size =>10
	elsif((@final_bill.balance_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+7)*difference] , :size =>10
	elsif((@final_bill.balance_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+7)*difference] , :size =>10
	else
		pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+7)*difference] , :size =>10
	end
	
	pdf.draw_text "Paid Amount", :at => [400, line_no-(i+8)*difference] , :size =>10
	
	if((@final_bill.paid_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+8)*difference] , :size =>10
	elsif((@final_bill.paid_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+8)*difference] , :size =>10
	elsif((@final_bill.paid_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+8)*difference] , :size =>10
	else
		pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+8)*difference] , :size =>10
	end
	
	for j  in 6..i+2
		pdf.draw_text " : ", :at => [400, line_no-j*difference] 
	end
	
	pdf.move_down(500)
	
	pdf.text_box " In Words Received : #{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')} (Rupees #{@to_watds} only)" ,:at => [10, 300], :inline_format => true, :size =>10

	pdf.draw_text "(Signature Of Patient)", :at => [10, 0] , :size =>10
	
	
	pdf.draw_text "(Authorised Signature) ", :at => [450, 0] , :size =>10
end
