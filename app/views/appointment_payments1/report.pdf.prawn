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
pdf.rounded_rectangle [-4, 810], 585, 420, 10
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

pdf.image prawn_logo, :at => [10, 790],:width => 110, :height => 50
pdf.stroke do
line_no=680
	pdf.move_down(10)
	
	pdf.move_down(10)
	line_end=580
	pdf.line [0,730], [line_end,730]
	difference=20
	doctor_master=EmployeeMaster.find_by_empid_and_org_code(@appointment_payment.consultant_id,@appointment_payment.org_code)
	
	pdf.move_down(5)
	k=0
		pdf.text "<b>Bill Cum Receipt</b>", :align => :center, :inline_format => true
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
	pdf.draw_text "   Referral Phno", :at => [0, line_no-(k+6)*difference] , :size =>10
	pdf.draw_text "   Consultant Name", :at => [0, line_no-(k+7)*difference], :size =>10
	pdf.draw_text "   OP.NO", :at => [0, line_no-(k+8)*difference], :size =>10
	pdf.draw_text "   Consultant Fee", :at => [0, line_no-(k+9)*difference], :size =>10
pdf.draw_text "   Paid Amount", :at => [0, line_no-(k+10)*difference], :size =>10
	pdf.draw_text "   To wards consultation", :at => [0, line_no-(k+11)*difference], :size =>12
	
	
	

	for i  in k..(k+9)
		pdf.draw_text " : ", :at => [100, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@appointment_payment.mr_no} ", :at => [150, line_no-(k)*difference], :size =>10 
	pdf.draw_text " #{@registration.title+"."+@registration.patient_name} ", :at => [150, line_no-(k+1)*difference], :size =>10
	pdf.draw_text " #{@registration.age}/#{@registration.gender} ", :at => [150, line_no-(k+2)*difference], :size =>10 
	pdf.draw_text " #{@registration.address} ", :at => [150, line_no-(k+3)*difference], :size =>10 
	pdf.draw_text " #{@registration.referral} ", :at => [150, line_no-(k+4)*difference], :size =>10 
	pdf.draw_text " #{@registration.referral_name} ", :at => [150, line_no-(k+5)*difference], :size =>10 
	pdf.draw_text " #{@registration.referral_contact_no} ", :at => [150, line_no-(k+6)*difference], :size =>10 
	pdf.draw_text " #{doctor_master.name} ", :at => [150, line_no-(k+7)*difference], :size =>10 
	pdf.draw_text " #{@appointment_payment.op_number} ", :at => [150, line_no-(k+8)*difference], :size =>10 
	
	pdf.draw_text " #{@appointment_payment.consultant_fee} ", :at => [150, line_no-(k+9)*difference], :size =>10 
	pdf.draw_text " #{@appointment_payment.paid_amount} ", :at => [150, line_no-(k+10)*difference], :size =>10 
	pdf.draw_text " #{@to_watds.capitalize}rupees only.", :at => [150, line_no-(k+11)*difference], :size =>12
	
	
	pdf.draw_text "Authorised Signature", :at => [400, line_no-12*23], :size =>10
	

		pdf.draw_text "Date/Time", :at => [415, line_no-(k)*difference] , :size =>10
		pdf.draw_text "Bill No", :at => [415, line_no-(k+1)*difference] , :size =>10	
		for i  in k..k+1
			pdf.draw_text " : ", :at => [460, line_no-i*difference] 
		end
		pdf.draw_text " #{@appointment_payment.appt_date.strftime("%d-%m-%Y")}/ #{@appointment_payment.appt_time.strftime("%I:%M%p")} ", :at => [475, line_no-k*difference], :size =>10 
		pdf.draw_text " R#{@appointment_payment.bill_no11} ", :at => [480, line_no-(k+1)*difference], :size =>10
		
	
	
end
