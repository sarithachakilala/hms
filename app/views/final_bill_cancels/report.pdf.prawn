
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
pdf.rounded_rectangle [0, 810], 580, 400, 10

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

pdf.image prawn_logo, :at => [10, 780],:width => 170, :height => 30

pdf.stroke do
line_no=710
	pdf.move_down(25)
	line_end=580
	difference=20
	pdf.line [0,730], [line_end,730]
pdf.draw_text  "FINAL BILL CANCEL RECEIPT", :at => [200,710] , :size =>12, :style => :bold


	if(@print_type=="duplicate")
		pdf.draw_text  "(Duplicate)", :at => [500,700] , :size =>10, :style => :bold
	else 
		pdf.draw_text  "(Original)", :at => [500,700] , :size =>10, :style => :bold
	end
	
	pdf.draw_text "Admn.No", :at => [10, line_no-2*difference], :size =>10
	pdf.draw_text "Patient Name", :at => [10, line_no-3*difference] , :size =>10
	pdf.draw_text "Address", :at => [10, line_no-4*difference], :size =>10
	pdf.draw_text "Final Bill Amount", :at => [10, line_no-5*difference], :size =>10
	pdf.draw_text "Final Bill Cancel Amount", :at => [10, line_no-6*difference], :size =>10
		
	for i  in 2..6
		pdf.draw_text " : ", :at => [140, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@final_bill_cancel.admn_no} ", :at => [150, line_no-2*difference], :size =>10 
	pdf.draw_text " #{@registration.title+"."+@registration.patient_name} ", :at => [150, line_no-3*difference], :size =>10 
	pdf.draw_text " #{@registration.address} ", :at => [150, line_no-4*difference], :size =>10 
	pdf.draw_text " #{@final_bill_cancel.final_bill_amount} ", :at => [150, line_no-5*difference], :size =>10 
	pdf.draw_text " #{@final_bill_cancel.final_bill_cancel_amount} ", :at => [150, line_no-6*difference], :size =>10 
	
	
	pdf.draw_text "Date/Time", :at => [370, line_no-2*difference] , :size =>10
	
	pdf.draw_text "Room/Bed", :at => [370, line_no-3*difference] , :size =>10
	
	for i  in 2..3
		pdf.draw_text " : ", :at => [448, line_no-i*difference] 
		
	end
	pdf.draw_text " #{@final_bill_cancel.final_bill_cancel_date.strftime("%d-%m-%Y")}/#{@final_bill_cancel.finalbill_cancel_time.strftime("%I:%M%p")} ", :at => [460, line_no-2*difference], :size =>10
	pdf.draw_text " #{@admission.room} /#{@admission.bed}", :at => [460, line_no-3*difference], :size =>10 
	
		
	pdf.draw_text "(Signature Of Patient)", :at => [10,430] , :size =>10
	
	
	pdf.draw_text "(Authorised Signature) ", :at => [450, 430] , :size =>10
end
