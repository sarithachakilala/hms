
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
line_no=680

	
	pdf.move_down(10)
	line_end=580
pdf.line [0,730], [line_end,730]
	difference=20
	
	
	pdf.move_down(10)
	k=0
		pdf.text "<b>IP DUE RECEIPT</b>", :align => :center, :inline_format => true
		
		
		if(@print_type=="duplicate")
		 pdf.draw_text "(Duplicate)", :at => [440, 720], :style => :bold
		 else
		 pdf.draw_text "(Original)", :at => [440, 720], :style => :bold
		 end
		
	pdf.draw_text "   MR No", :at => [0, line_no-k*difference], :size =>10
	pdf.draw_text "   Patient Name", :at => [0, line_no-(k+1)*difference] , :size =>10
	pdf.draw_text "   Age/Sex", :at => [0, line_no-(k+2)*difference] , :size =>10
	pdf.draw_text "   Concession Authority", :at => [0, line_no-(k+3)*difference], :size =>10
	pdf.draw_text "   concession", :at => [0, line_no-(k+4)*difference], :size =>10
	pdf.draw_text "   Remaining Amount", :at => [0, line_no-(k+5)*difference], :size =>10
	
	

	for i  in k..(k+5)
		pdf.draw_text " : ", :at => [100, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@ip_due.mr_no} ", :at => [150, line_no-(k)*difference], :size =>10 
	pdf.draw_text " #{@registration.patient_name} ", :at => [150, line_no-(k+1)*difference], :size =>10
	pdf.draw_text " #{@registration.age}/#{@registration.gender} ", :at => [150, line_no-(k+2)*difference], :size =>10 
	pdf.draw_text " #{@ip_due.concession_authority} ", :at => [150, line_no-(k+3)*difference], :size =>10 
	pdf.draw_text " #{@ip_due.concession} ", :at => [150, line_no-(k+4)*difference], :size =>10 
	pdf.draw_text " #{@ip_due.remaining_amount} ", :at => [150, line_no-(k+5)*difference], :size =>10 
	
	
	pdf.draw_text " Due Date", :at => [410, line_no-k*difference] , :size =>10
	pdf.draw_text "Receipt No", :at => [410, line_no-(k+1)*difference] , :size =>10
	pdf.draw_text "Authorised Signature", :at => [400, line_no-11*23], :size =>10
	
	
	for i  in k..k+1
		pdf.draw_text " : ", :at => [465, line_no-i*difference] 
	end
    pdf.draw_text " #{@ip_due.due_date} ", :at => [490, line_no-(k)*difference], :size =>10 
	pdf.draw_text " #{@ip_due.receipt_no} ", :at => [490, line_no-(k+1)*difference], :size =>10 
	
	
	
	
	
	
end
