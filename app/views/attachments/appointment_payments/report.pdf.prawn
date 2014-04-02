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
prawn_logo = "public/images/exleaz.jpg"

else
prawn_logo = "public/images/hs-gol.png"
end
pdf.move_down(10)
pdf.rounded_rectangle [-4, 810], 585, 420, 10
pdf.image prawn_logo, :width => 200, :height => 30
@org=OrgMasterChildTable.last
	if(@org)
			pdf.draw_text "#{@org.address}", :at => [210, 780], :size=>12
			pdf.draw_text "PHONE:", :at => [210, 760], :size =>12			
			pdf.draw_text "#{@org.ph_no}", :at => [260, 760], :size=>12 
			pdf.draw_text "EMAIL:", :at => [210, 740], :size =>12			
			pdf.draw_text "#{@org.email}", :at => [260, 740], :size=>12 

	end


pdf.stroke do
line_no=680
	pdf.move_down(10)
	
	pdf.move_down(10)
	line_end=580
	pdf.line [0,730], [line_end,730]
	difference=20
	doctor_master=EmployeeMaster.find_by_empid_and_org_code(@appointment_payment.consultant_id,@appointment_payment.org_code)
	
	pdf.move_down(25)
	k=0
		pdf.text "<b>RECEIPT</b>", :align => :center, :inline_format => true
		if(@print_type=="duplicate")
		 pdf.draw_text "(Duplicate)", :at => [440, 720], :style => :bold
		 else
		 pdf.draw_text "(Original)", :at => [430, 710], :style => :bold
		 end
		
	pdf.draw_text "   MR No", :at => [0, line_no-k*difference], :size =>10
	pdf.draw_text "   Patient Name", :at => [0, line_no-(k+1)*difference] , :size =>10
	pdf.draw_text "   Age/Sex", :at => [0, line_no-(k+2)*difference] , :size =>10
	pdf.draw_text "   Address", :at => [0, line_no-(k+3)*difference] , :size =>10
	pdf.draw_text "	  Referral Type", :at => [0, line_no-(k+4)*difference] , :size =>10
	pdf.draw_text "   Referral Name", :at => [0, line_no-(k+5)*difference] , :size =>10
	pdf.draw_text "   Consultant Name", :at => [0, line_no-(k+6)*difference], :size =>10
	pdf.draw_text "   OP.NO", :at => [0, line_no-(k+7)*difference], :size =>10
	pdf.draw_text "   Consultant Fee", :at => [0, line_no-(k+8)*difference], :size =>10
	
	

	for i  in k..(k+8)
		pdf.draw_text " : ", :at => [100, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@appointment_payment.mr_no} ", :at => [150, line_no-(k)*difference], :size =>10 
	pdf.draw_text " #{@registration.patient_name} ", :at => [150, line_no-(k+1)*difference], :size =>10
	pdf.draw_text " #{@registration.age}/#{@registration.gender} ", :at => [150, line_no-(k+2)*difference], :size =>10 
	pdf.draw_text " #{@registration.address} ", :at => [150, line_no-(k+3)*difference], :size =>10 
	pdf.draw_text " #{@registration.referral} ", :at => [150, line_no-(k+4)*difference], :size =>10 
	pdf.draw_text " #{@registration.referral_name} ", :at => [150, line_no-(k+5)*difference], :size =>10 
	pdf.draw_text " #{doctor_master.name} ", :at => [150, line_no-(k+6)*difference], :size =>10 
	pdf.draw_text " #{@appointment_payment.op_number} ", :at => [150, line_no-(k+7)*difference], :size =>10 
	pdf.draw_text " #{@appointment_payment.consultant_fee} ", :at => [150, line_no-(k+8)*difference], :size =>10 
	
	
	
	pdf.draw_text "Authorised Signature", :at => [400, line_no-11*23], :size =>10
	
	
	if(@registration.image_path!="empty" && @registration.image_path!="")
		patient_logo = "public/#{@registration.image_path}"
		pdf.image patient_logo, :at => [460,700], :width => 100, :height=>70, :border=>0
		pdf.draw_text "Date/Time", :at => [420, line_no-(k+3)*difference] , :size =>10
		pdf.draw_text "Bill No", :at => [420, line_no-(k+4)*difference] , :size =>10	
		for i  in k+3..k+4
			pdf.draw_text " : ", :at => [465, line_no-i*difference] 
		end
		pdf.draw_text " #{@appointment_payment.appt_date.strftime("%d-%m-%Y")}/ #{@appointment_payment.appt_time.strftime("%I:%M%p")} ", :at => [480, line_no-(k+3)*difference], :size =>10 
		pdf.draw_text "R#{@appointment_payment.bill_no11} ", :at => [480, line_no-(k+4)*difference], :size =>10
	else
		pdf.draw_text "Date/Time", :at => [420, line_no-(k)*difference] , :size =>10
		pdf.draw_text "Bill No", :at => [420, line_no-(k+1)*difference] , :size =>10	
		for i  in k..k+1
			pdf.draw_text " : ", :at => [465, line_no-i*difference] 
		end
		pdf.draw_text " #{@appointment_payment.appt_date.strftime("%d-%m-%Y")}/ #{@appointment_payment.appt_time.strftime("%I:%M%p")} ", :at => [480, line_no-k*difference], :size =>10 
		pdf.draw_text " R#{@appointment_payment.bill_no11} ", :at => [480, line_no-(k+1)*difference], :size =>10
	end
	
	
end