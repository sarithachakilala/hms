
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
prawn_logo = "public/images/amr.jpg"
pdf.image prawn_logo, :at => [10,810], :width => 147, :border=>0

pdf.rounded_rectangle [0, 810], 580, 820, 10


pdf.text "<b>AMRUTHA HEART HOSPITALS<b>", :size => 13, :align => :center, :inline_format => true
pdf.text "60-FEET ROAD, 0NGOLE - 523 002.", :align => :center,:style =>:bold
pdf.text "PHONE : 08592 - 234419, 282069", :align => :center,:style =>:bold
pdf.text "www.amruthahearthospitals.com", :align => :center,:style =>:bold

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
	pdf.draw_text "Package Name", :at => [10, line_no-4*difference], :size =>10
		
	for i  in 1..4
		pdf.draw_text " : ", :at => [140, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@final_bill.admn_no} ", :at => [150, line_no-1*difference], :size =>10 
	pdf.draw_text " #{@registration.first_name}.#{@registration.last_name} ", :at => [150, line_no-2*difference], :size =>10 
	pdf.draw_text " #{@registration.address} ", :at => [150, line_no-3*difference], :size =>10 
	pdf.draw_text " #{@admission.package} ", :at => [150, line_no-4*difference], :size =>10 
	
	pdf.draw_text "Admn.Date/Time", :at => [370, line_no-1*difference] , :size =>10
	pdf.draw_text "Dis.Date/Time", :at => [370, line_no-2*difference] , :size =>10
	pdf.draw_text "Room/Bed", :at => [370, line_no-3*difference] , :size =>10
	pdf.draw_text "Package Category", :at => [370, line_no-4*difference] , :size =>10
	
	for i  in 1..4
		pdf.draw_text " : ", :at => [448, line_no-i*difference] 
	end

	pdf.draw_text " #{@admission.admn_date.strftime("%d-%m-%Y")}/ #{@admission.created_at.strftime('%I:%M%p')} ", :at => [450, line_no-1*difference] , :size =>10 
	pdf.draw_text " #{@final_bill.final_bill_date.strftime("%d-%m-%Y")}/ #{@final_bill.created_at.strftime('%I:%M%p')} ", :at => [450, line_no-2*difference], :size =>10 
	pdf.draw_text " #{@admission.room}/ #{@admission.bed} ", :at => [450, line_no-3*difference] , :size =>10 
	pdf.draw_text " #{@admission.p_name} ", :at => [450, line_no-4*difference] , :size =>10 
	
	pdf.draw_text "Package Charge ", :at => [10, line_no-(i+2)*difference] , :size =>10
	if((@admission.amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@admission.amount, :precision => 2, :separator => '.')	}", :at => [520, line_no-(i+2)*difference] , :size =>10
	elsif((@admission.amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@admission.amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+2)*difference] , :size =>10
	elsif((@admission.amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@admission.amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+2)*difference] , :size =>10
	elsif((@admission.amount.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@admission.amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+2)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@admission.amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+2)*difference] , :size =>10
	end
	
	pdf.draw_text "Miscellaneous Charge ", :at => [10, line_no-(i+3)*difference] , :size =>10
	if((@final_bill.miscellaneous_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [520, line_no-(i+3)*difference] , :size =>10
	elsif((@final_bill.miscellaneous_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+3)*difference] , :size =>10
	elsif((@final_bill.miscellaneous_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+3)*difference] , :size =>10
	elsif((@final_bill.miscellaneous_amount.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+3)*difference] , :size =>10	
	elsif((@final_bill.miscellaneous_amount.to_i).to_s.length==5)
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+3)*difference] , :size =>10		
	else
		pdf.draw_text "#{number_with_precision(@final_bill.miscellaneous_amount, :precision => 2, :separator => '.')	}", :at => [495, line_no-(i+2)*difference] , :size =>10
	end
		
	pdf.line [10,line_no-(i+4)*difference],[550,line_no-(i+4)*difference]
	pdf.draw_text "Total ", :at => [400, line_no-(i+5)*difference] , :size =>10
	if((@final_bill.gross_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.gross_amount, :precision => 2, :separator => '.')	}", :at => [520, line_no-(i+5)*difference] , :size =>10
	elsif((@final_bill.gross_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.gross_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+5)*difference] , :size =>10
	elsif((@final_bill.gross_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.gross_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+5)*difference] , :size =>10
	elsif((@final_bill.gross_amount.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.gross_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+5)*difference] , :size =>10
	elsif((@final_bill.gross_amount.to_i).to_s.length==5)
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+5)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.gross_amount, :precision => 2, :separator => '.')	}", :at => [495, line_no-(i+5)*difference] , :size =>10
	end
	
	pdf.draw_text "Discount ", :at => [400, line_no-(i+6)*difference] , :size =>10
	
	if((@final_bill.concession.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [520, line_no-(i+6)*difference] , :size =>10
	elsif((@final_bill.concession.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+6)*difference] , :size =>10
	elsif((@final_bill.concession.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+6)*difference] , :size =>10
	elsif((@final_bill.concession.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+6)*difference] , :size =>10
	elsif((@final_bill.concession.to_i).to_s.length==5)
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+6)*difference] , :size =>10	
	else
		pdf.draw_text "#{number_with_precision(@final_bill.concession, :precision => 2, :separator => '.')	}", :at => [495, line_no-(i+6)*difference] , :size =>10
	end
	
	pdf.draw_text "Advance ", :at => [400, line_no-(i+7)*difference] , :size =>10
	
	if((@final_bill.advance.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')	}", :at => [520, line_no-(i+7)*difference] , :size =>10
	elsif((@final_bill.advance.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+7)*difference] , :size =>10
	elsif((@final_bill.advance.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+7)*difference] , :size =>10
	elsif((@final_bill.advance.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+7)*difference] , :size =>10
	elsif((@final_bill.advance.to_i).to_s.length==5)
		pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+7)*difference] , :size =>10		
	else
		pdf.draw_text "#{number_with_precision(@final_bill.advance, :precision => 2, :separator => '.')	}", :at => [495, line_no-(i+7)*difference] , :size =>10
	end
	
	pdf.draw_text "Due ", :at => [400, line_no-(i+8)*difference] , :size =>10
	
	if((@final_bill.balance_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')	}", :at => [520, line_no-(i+8)*difference] , :size =>10
	elsif((@final_bill.balance_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+8)*difference] , :size =>10
	elsif((@final_bill.balance_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+8)*difference] , :size =>10
	elsif((@final_bill.balance_amount.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+8)*difference] , :size =>10
elsif((@final_bill.balance_amount.to_i).to_s.length==5)
		pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+8)*difference] , :size =>10		
	else
		pdf.draw_text "#{number_with_precision(@final_bill.balance_amount, :precision => 2, :separator => '.')	}", :at => [495, line_no-(i+8)*difference] , :size =>10
	end
	
	pdf.draw_text "Paid Amount", :at => [400, line_no-(i+9)*difference] , :size =>10
	
	if((@final_bill.paid_amount.to_i).to_s.length==1)
		pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')	}", :at => [520, line_no-(i+9)*difference] , :size =>10
	elsif((@final_bill.paid_amount.to_i).to_s.length==2)
		pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')	}", :at => [515, line_no-(i+9)*difference] , :size =>10
	elsif((@final_bill.paid_amount.to_i).to_s.length==3)
		pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')	}", :at => [510, line_no-(i+9)*difference] , :size =>10
	elsif((@final_bill.paid_amount.to_i).to_s.length==4)
		pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')	}", :at => [505, line_no-(i+9)*difference] , :size =>10
	elsif((@final_bill.paid_amount.to_i).to_s.length==5)
		pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')	}", :at => [500, line_no-(i+9)*difference] , :size =>10
	else
		pdf.draw_text "#{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')	}", :at => [495, line_no-(i+9)*difference] , :size =>10
	end
	
	
	
	pdf.move_down(500)
	
	pdf.text_box " In Words Received : #{number_with_precision(@final_bill.paid_amount, :precision => 2, :separator => '.')} (Rupees #{@to_watds} only)" ,:at => [10, 300], :inline_format => true, :size =>10

	pdf.draw_text "(Signature Of Patient)", :at => [10, 0] , :size =>10
	
	
	pdf.draw_text "(Authorised Signature) ", :at => [450, 0] , :size =>10
end