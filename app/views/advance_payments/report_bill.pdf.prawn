
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
pdf.move_down(35)

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
pdf.rounded_rectangle [-4, 810], 585, 400, 10
line_no=700
	
	pdf.move_down(10)
	line_end=580
	pdf.line [0,730], [line_end,730]
	difference=20
	
	pdf.draw_text  "Bill CUM RECEIPT", :at => [200,710] , :size =>12, :style => :bold
	if(@print_type=="duplicate")
		pdf.draw_text  "(Duplicate)", :at => [500,710] , :size =>10, :style => :bold
	else 
		pdf.draw_text  "(Original)", :at => [500,710] , :size =>10, :style => :bold
	end
	pdf.draw_text "   MR.No", :at => [0, line_no-1*difference], :size =>10, :inline_format => true
	pdf.draw_text "   Admn.No", :at => [0, line_no-2*difference] , :size =>10
	pdf.draw_text "   Patient Name", :at => [0, line_no-3*difference] , :size =>10
	pdf.draw_text "   Age/Sex", :at => [0, line_no-4*difference] , :size =>10
	pdf.draw_text "   Transaction Type", :at => [0, line_no-5*difference], :size =>10
	pdf.draw_text "   Paid Amount", :at => [0, line_no-6*difference], :size =>10
	pdf.draw_text "   Till Now Paid ", :at => [0, line_no-7*difference], :size =>10
	pdf.draw_text "   To wards Advnce", :at => [0, line_no-8*difference], :size =>10
	

	for i  in 1..8
		pdf.draw_text " : ", :at => [140, line_no-i*difference] 
	end
	
	
	pdf.draw_text " #{@advance_payment.mr_no} ", :at => [150, line_no-1*difference] , :size =>10
	pdf.draw_text " #{@advance_payment.admn_no} ", :at => [150, line_no-2*difference] , :size =>10
	pdf.draw_text " #{@registration.title+"."+@registration.patient_name}", :at => [150, line_no-3*difference], :size =>10
	pdf.draw_text " #{@registration.age}/#{@registration.gender} ", :at => [150, line_no-4*difference] , :size =>10
if(@advance_payment.payment_mode)	
	pdf.draw_text " #{@advance_payment.payment_mode.capitalize}", :at => [150, line_no-5*difference] , :size =>10
end
	pdf.draw_text " #{number_with_precision(@advance_payment.gross_amount, :precision => 2, :separator => '.')}", :at => [150, line_no-6*difference] , :size =>10
	pdf.draw_text " #{number_with_precision(@advance_payment.already_paid_amount, :precision => 2, :separator => '.')} ", :at => [150, line_no-7*difference] , :size =>10
	pdf.draw_text " #{@to_watds.capitalize}rupees only. ", :at => [150, line_no-8*difference] , :size =>10


	
	pdf.draw_text "Date/Time", :at => [360, line_no-1*difference] , :size =>10
	pdf.draw_text "Bill No", :at => [360, line_no-2*difference] , :size =>10
	pdf.draw_text "Floor", :at => [360, line_no-3*difference] , :size =>10
	pdf.draw_text "Ward", :at => [360, line_no-4*difference] , :size =>10
	pdf.draw_text "Room", :at => [360, line_no-5*difference] , :size =>10
	pdf.draw_text "Bed", :at => [360, line_no-6*difference] , :size =>10
	
	
	
	pdf.draw_text " : ", :at => [430, line_no-1*difference] 
	pdf.draw_text " : ", :at => [430, line_no-2*difference]  
	pdf.draw_text " : ", :at => [430, line_no-3*difference]  
	pdf.draw_text " : ", :at => [430, line_no-4*difference]  
	pdf.draw_text " : ", :at => [430, line_no-5*difference]  
	pdf.draw_text " : ", :at => [430, line_no-6*difference]  
	
	
	
	pdf.draw_text " #{@advance_payment.advance_date.strftime("%d-%m-%Y")}/ #{@advance_payment.advance_time.strftime('%I:%M%p')} ", :at => [440, line_no-1*difference] , :size =>10
	pdf.draw_text "  #{@advance_payment.receipt_no}", :at => [440, line_no-2*difference], :size =>10
	pdf.draw_text "  #{@admissions.floor}", :at => [440, line_no-3*difference], :size =>10
	pdf.draw_text "  #{@admissions.ward}", :at => [440, line_no-4*difference], :size =>10
	pdf.draw_text "  #{@admissions.room}", :at => [440, line_no-5*difference], :size =>10
	pdf.draw_text "  #{@admissions.bed}", :at => [440, line_no-6*difference], :size =>10
	
	
	
	
	
	
	
	pdf.draw_text "Authorised Signature", :at => [390,460] , :size =>10,:inline_format => true

end
