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
pdf.rounded_rectangle [0, 810], 580, 820, 10
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
line_no=710
	pdf.move_down(20)
	line_end=580
	difference=20
	pdf.line [0,730], [line_end,730]
	pdf.text "<font size='12px'><b>FINAL BILL RECEIPT</b></font>" ,:align => :center, :inline_format => true
	
	if(@print_type=="duplicate")
		pdf.draw_text  "(Duplicate)", :at => [500,720] , :size =>10, :style => :bold
	else 
		pdf.draw_text  "(Original)", :at => [500,720] , :size =>10, :style => :bold
	end
	
	pdf.draw_text "Admn.No", :at => [10, line_no-1*difference], :size =>10
	pdf.draw_text "Patient Name", :at => [10, line_no-2*difference] , :size =>10
	pdf.draw_text "Address", :at => [10, line_no-3*difference], :size =>10
		
	for i  in 1..3
		pdf.draw_text " : ", :at => [140, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@final_bill.admn_no} ", :at => [150, line_no-1*difference], :size =>10 
	pdf.draw_text " #{@registration.patient_name}", :at => [150, line_no-2*difference], :size =>10 
	pdf.draw_text " #{@registration.address} ", :at => [150, line_no-3*difference], :size =>10 
	
	pdf.draw_text "Admn.Date/Time", :at => [370, line_no-1*difference] , :size =>10
	pdf.draw_text "Dis.Date/Time", :at => [370, line_no-2*difference] , :size =>10
	pdf.draw_text "Ward", :at => [370, line_no-3*difference] , :size =>10
	
	for i  in 1..3
		pdf.draw_text " : ", :at => [448, line_no-i*difference] 
	end

	pdf.draw_text " #{@admission.admn_date.strftime("%d-%m-%Y")}/ #{@admission.admn_time.strftime('%I:%M%p')} ", :at => [460, line_no-1*difference] , :size =>10 
	pdf.draw_text " #{@final_bill.final_bill_date.strftime("%d-%m-%Y")}/ #{@final_bill.finalbill_time.strftime('%I:%M%p')} ", :at => [460, line_no-2*difference], :size =>10 
	pdf.draw_text " #{@admission.ward} ", :at => [460, line_no-3*difference] , :size =>10 
	
	
	pdf.draw_text "Room Charges ", :at => [10, line_no-5*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.ward_fee, :precision => 2, :separator => '.')}", :at => [500, line_no-5*difference] , :size =>10
	
	pdf.draw_text "Nursing Charges  ", :at => [10, line_no-6*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.nurse_fee, :precision => 2, :separator => '.')} ", :at => [500, line_no-6*difference] , :size =>10
	
	pdf.draw_text "Consultant Visits  ", :at => [10, line_no-7*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.doctor_fee, :precision => 2, :separator => '.')}", :at => [500, line_no-7*difference] , :size =>10
	
	pdf.draw_text "Operating Charges  ", :at => [10, line_no-8*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.operation_amount, :precision => 2, :separator => '.')} ", :at => [500, line_no-8*difference] , :size =>10
	
	pdf.draw_text "Assistant's Charge  ", :at => [10, line_no-9*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.assistant_amount, :precision => 2, :separator => '.')} ", :at => [500, line_no-9*difference] , :size =>10
	
	pdf.draw_text "OT Charges  ", :at => [10, line_no-10*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.ot_fee, :precision => 2, :separator => '.')} ", :at => [500, line_no-10*difference] , :size =>10
	
	pdf.draw_text "Anaesthesia Charge  ", :at => [10, line_no-11*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.anaesthesia_amount, :precision => 2, :separator => '.')} ", :at => [500, line_no-11*difference] , :size =>10
	
	i=12
	for final_charge in @final_bill.final_charges
		pdf.draw_text "#{final_charge.charge_type} ", :at => [10, line_no-i*difference] , :size =>10
		pdf.draw_text "#{number_with_precision(final_charge.charge, :precision => 2, :separator => '.')} ", :at => [500, line_no-i*difference] , :size =>10
		i=i+1
	end
	 
	
	
	pdf.draw_text "Lab Charge ", :at => [10, line_no-(i)*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@lab_charge, :precision => 2, :separator => '.')} ", :at => [500, line_no-(i)*difference] , :size =>10
	
	pdf.draw_text "Medicine Charge ", :at => [10, line_no-(i+1)*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@medicine, :precision => 2, :separator => '.')}", :at => [500, line_no-(i+1)*difference] , :size =>10
	
	pdf.line [10,line_no-(i+2)*difference],[560,line_no-(i+2)*difference]
	pdf.draw_text "Gross Amount", :at => [400, line_no-(i+3)*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.gross_amount, :precision => 2, :separator => '.')}", :at => [500, line_no-(i+3)*difference] , :size =>10
	
	pdf.draw_text "Advance ", :at => [400, line_no-(i+4)*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')} ", :at => [500, line_no-(i+4)*difference] , :size =>10
	

pdf.draw_text "Discount ", :at => [400, line_no-(i+5)*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+5)*difference] , :size =>10
	
pdf.draw_text "Due Amount", :at => [400, line_no-(i+6)*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')} ", :at => [500, line_no-(i+6)*difference] , :size =>10
	

	
	pdf.draw_text "Paid Amount", :at => [400, line_no-(i+7)*difference] , :size =>10
	pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')} ", :at => [500, line_no-(i+7)*difference] , :size =>10
	
	for j  in 5..i+1
		pdf.draw_text " : ", :at => [400, line_no-j*difference] 
	end
	
	pdf.move_down(500)
	
	pdf.text_box " In Words Received : #{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')} (Rupees #{@to_watds} only)" ,:at => [10, 300], :inline_format => true, :size =>10

	pdf.draw_text "(Signature Of Patient)", :at => [10, 0] , :size =>10
	
	
	pdf.draw_text "(Authorised Signature) ", :at => [450, 0] , :size =>10
end
