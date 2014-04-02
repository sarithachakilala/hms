
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
pdf.image prawn_logo, :width => 200, :height => 30
pdf.move_down(35)
prawn_logo = "public/images/barcodeimages/#{@test_booking.lab_no}.png"
pdf.image prawn_logo, :width => 200, :height => 30, :position => :center
pdf.draw_text "#{@test_booking.lab_no}", :at => [96, 760], :size =>11, :position => :left

@org=OrgMasterChildTable.last
	if(@org)
			pdf.draw_text "#{@org.address}", :at => [210, 780], :size=>12
			pdf.draw_text "PHONE:", :at => [210, 760], :size =>12			
			pdf.draw_text "#{@org.ph_no}", :at => [260, 760], :size=>12 
			pdf.draw_text "EMAIL:", :at => [210, 740], :size =>12			
			pdf.draw_text "#{@org.email}", :at => [260, 740], :size=>12

	end


pdf.stroke do
pdf.rounded_rectangle [-4, 810], 585, 820, 10
line_no=720
	pdf.move_down(0)
	line_end=580
	pdf.line [0,730], [line_end,730]
	difference=20
	pdf.text "<b>LAB RECEIPT</b>", :align => :center, :inline_format => true
	
	if(@print_type=="duplicate")
		pdf.draw_text  "(Duplicate)", :at => [500,730] , :size =>10, :style => :bold
	else 
		pdf.draw_text  "(Original)", :at => [500,730] , :size =>10, :style => :bold
	end
	
	pdf.draw_text "  MR No", :at => [0, line_no-2*difference], :size =>10
	pdf.draw_text "  Patient Name", :at => [0, line_no-3*difference] , :size =>10
	pdf.draw_text "  Ref.Doctor", :at => [0, line_no-4*difference], :size =>10
	
	pdf.draw_text "Lab No", :at => [200, line_no-4*difference], :size =>10
		
	pdf.draw_text ":", :at => [240, line_no-4*difference], :size =>10
	
	pdf.draw_text "#{@test_booking.lab_no}", :at => [250, line_no-4*difference], :size =>10
	
	for i  in 2..4
		pdf.draw_text " : ", :at => [80, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@test_booking.mr_no} ", :at => [90, line_no-2*difference] , :size =>10
	pdf.draw_text " #{@registration.title+"."+@test_booking.patient_name} ", :at => [90, line_no-3*difference], :size =>10
	pdf.draw_text "#{@test_booking.refferal_doctor} ", :at => [90, line_no-4*difference], :size =>10
	
	pdf.draw_text "Date", :at => [350, line_no-2*difference] , :size =>10
	pdf.draw_text "Age/Sex", :at => [350, line_no-3*difference] , :size =>10
	pdf.draw_text "Bill No", :at => [350, line_no-4*difference] , :size =>10
	
for i  in 2..4
		pdf.draw_text " : ", :at => [420, line_no-i*difference] 
	end	

	pdf.draw_text " #{@test_booking.created_at.strftime("%d-%m-%Y")} ", :at => [430, line_no-2*difference], :size =>10 
	pdf.draw_text " #{@registration.age}/#{@registration.gender} ", :at => [430, line_no-3*difference], :size =>10
	pdf.draw_text " L#{@test_booking.bill_no}", :at => [430, line_no-4*difference] , :size =>10
	pdf.line [0,line_no-5*difference],[580,line_no-5*difference]
	pdf.draw_text "  S.No", :at => [0, line_no-6*difference] , :size =>10
	pdf.draw_text "Lab Service Name ", :at => [200, line_no-6*difference] , :size =>10
	pdf.draw_text "Charges ", :at => [470, line_no-6*difference] , :size =>10
	pdf.line [0,line_no-(7*difference-10)],[580,line_no-(7*difference-10)]
	i=7
	j=1
	for test_booking in @test_booking.test_booking_child
		pdf.draw_text "  #{j} ", :at => [0, line_no-i*difference] , :size =>10
		pdf.draw_text "  #{test_booking.test_name} ", :at => [190, line_no-i*difference] , :size =>10
		pdf.draw_text "  #{test_booking.amount} ", :at => [480, line_no-i*difference] , :size =>10
		
		i=i+1
		j=j+1
	end
	if(i>12)
		pdf.line [0,line_no-i*difference],[580,line_no-i*difference]
		
		pdf.draw_text "Grand Total   : ", :at => [300, line_no-(i+1)*difference] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.grand_total, :precision => 2, :separator => '.')}", :at => [430, line_no-(i+1)*difference] , :size =>10
		pdf.draw_text "Discount      :", :at => [300, line_no-(i+3)*difference] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.concession, :precision => 2, :separator => '.')} ", :at => [430, line_no-(i+3)*difference] , :size =>10
		pdf.draw_text "Total Amount  :", :at => [300, line_no-(i+5)*difference] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.total_amount, :precision => 2, :separator => '.')}", :at => [430, line_no-(i+5)*difference] , :size =>10
	else
		diffe=12
		pdf.line [0,line_no-19*difference],[580,line_no-19*difference]
		pdf.draw_text "Grand Total      : ", :at => [400, line_no-25*diffe] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.grand_total.to_f, :precision => 2, :separator => '.')} ", :at => [490, line_no-25*diffe] , :size =>10
		pdf.draw_text "Discount           :", :at => [400, line_no-26*diffe] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.concession, :precision => 2, :separator => '.')} ", :at => [490, line_no-26*diffe] , :size =>10
		pdf.draw_text "Total Amount    :", :at => [400, line_no-27*diffe] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.total_amount.to_f, :precision => 2, :separator => '.')} ", :at => [490, line_no-27*diffe] , :size =>10
		
	end	
	
	pdf.draw_text "Authorised Signature", :at => [20, line_no-23*difference], :size =>10
end
