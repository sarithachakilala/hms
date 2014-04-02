
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

pdf.rounded_rectangle [0, 810], 560, 420, 10
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
line_no=750
	pdf.move_down(5)
	line_end=560
	pdf.line [0,748], [line_end,748]
	difference=15
	
	pdf.text "<b>BILL CUM RECEIPT</b>", :align => :center, :inline_format => true, :size =>11
	if(@print_type=="duplicate")
		pdf.draw_text  "(Duplicate)", :at => [505,735] , :size =>10, :style => :bold
	else 
		pdf.draw_text  "(Original)", :at => [505,735] , :size =>10, :style => :bold
	end
	
	pdf.draw_text "  MR No", :at => [0, line_no-2*difference], :size =>10
	pdf.draw_text "  Patient Name", :at => [0, line_no-3*difference] , :size =>10
	pdf.draw_text "  Ref.Doctor", :at => [0, line_no-4*difference], :size =>10
	
	for i  in 2..4
		pdf.draw_text " : ", :at => [80, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@test_booking.mr_no} ", :at => [90, line_no-2*difference] , :size =>10
	pdf.draw_text " #{@test_booking.patient_name} ", :at => [90, line_no-3*difference], :size =>10
	pdf.draw_text " #{@test_booking.refferal_doctor} ", :at => [90, line_no-4*difference], :size =>10
	
	pdf.draw_text "Date", :at => [380, line_no-2*difference] , :size =>10
	pdf.draw_text "Age/Sex", :at => [380, line_no-3*difference] , :size =>10
	pdf.draw_text "Bill No", :at => [380, line_no-4*difference] , :size =>10
	
	if(@test_booking.patient_type=="IP")
		pdf.draw_text "Admn.No", :at => [200, line_no-2*difference], :size =>10
		pdf.draw_text ":", :at => [245, line_no-2*difference], :size =>10
		pdf.draw_text "#{@test_booking.admn_no}", :at => [250, line_no-2*difference], :size =>10
	end

	pdf.draw_text "Lab No", :at => [200, line_no-4*difference], :size =>10
		
	pdf.draw_text ":", :at => [245, line_no-4*difference], :size =>10
	
	pdf.draw_text "#{@test_booking.lab_no}", :at => [250, line_no-4*difference], :size =>10

	for i  in 2..4
		pdf.draw_text " : ", :at => [440, line_no-i*difference] 
	end

	pdf.draw_text " #{@test_booking.booking_date.strftime("%d-%m-%Y")}  ", :at => [450, line_no-2*difference], :size =>10 
	pdf.draw_text " #{@registration.age}/#{@registration.gender} ", :at => [450, line_no-3*difference], :size =>10
	pdf.draw_text " L#{@test_booking.bill_no}", :at => [450, line_no-4*difference] , :size =>10
	pdf.line [0,line_no-5*difference],[560,line_no-5*difference]
	pdf.draw_text "  S.No", :at => [0, line_no-6*difference] , :size =>10
	pdf.draw_text "Service Name ", :at => [200, line_no-6*difference] , :size =>10
	pdf.draw_text "Charges ", :at => [470, line_no-6*difference] , :size =>10
	pdf.line [0,line_no-(7*difference-10)],[560,line_no-(7*difference-10)]
	i=7
	j=1
	for test_booking in @test_booking.test_booking_child
		pdf.draw_text "  #{j} ", :at => [0, line_no-i*difference] , :size =>10
		pdf.draw_text "#{test_booking.test_name} ", :at => [200, line_no-i*difference] , :size =>10
		
		sale_rate=test_booking.amount.to_s.split(".")
		if(sale_rate[0].length==1)
			pdf.draw_text "#{number_with_precision(test_booking.amount, :precision => 2, :separator => '.')}", :at => [485,line_no-i*difference], :size =>10
		elsif(sale_rate[0].length==2)
			pdf.draw_text "#{number_with_precision(test_booking.amount, :precision => 2, :separator => '.')}", :at => [480,line_no-i*difference], :size =>10
		else
			pdf.draw_text "#{number_with_precision(test_booking.amount, :precision => 2, :separator => '.')}", :at => [475,line_no-i*difference], :size =>10
		end
		i=i+1
		j=j+1
	end
	if(i>12)
		pdf.line [0,line_no-i*difference],[560,line_no-i*difference]
		pdf.draw_text "Grand Total   : ", :at => [300, line_no-(i+1)*difference] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.total_amount, :precision => 2, :separator => '.')}", :at => [430, line_no-(i+1)*difference] , :size =>10
		pdf.draw_text "Discount      :", :at => [300, line_no-(i+3)*difference] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.concession, :precision => 2, :separator => '.')} ", :at => [430, line_no-(i+3)*difference] , :size =>10
		pdf.draw_text "Final Amount  :", :at => [300, line_no-(i+5)*difference] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.paid_amount, :precision => 2, :separator => '.')} ", :at => [430, line_no-(i+5)*difference] , :size =>10
	    pdf.draw_text "Due :", :at => [300, line_no-(i+6)*difference] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.due, :precision => 2, :separator => '.')} ", :at => [430, line_no-(i+6)*difference] , :size =>10
	else
		diffe=12
		pdf.line [0,line_no-19*difference],[560,line_no-19*difference]
		pdf.draw_text "Grand Total      : ", :at => [400, line_no-25*diffe] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.total_amount.to_f, :precision => 2, :separator => '.')} ", :at => [490, line_no-25*diffe] , :size =>10
		pdf.draw_text "Discount           :", :at => [400, line_no-26*diffe] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.concession, :precision => 2, :separator => '.')} ", :at => [490, line_no-26*diffe] , :size =>10
		pdf.draw_text "Final Amount    :", :at => [400, line_no-27*diffe] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.paid_amount, :precision => 2, :separator => '.')}", :at => [490, line_no-27*diffe] , :size =>10
	    pdf.draw_text "Due                   :", :at => [400, line_no-28*diffe] , :size =>10
		pdf.draw_text "#{number_with_precision(@test_booking.due, :precision => 2, :separator => '.')} ", :at => [490, line_no-28*diffe] , :size =>10
	end
	pdf.draw_text "Authorised Signature", :at => [20, line_no-23*difference], :size =>10
end
