page_no=0
total=0
i=0
k=1
if @test_amount[0]
for s in 0...@test_amount.length
pdf.stroke do
if(page_no==0)
pdf.font('Times-Roman')
pdf.rounded_rectangle [0, 810], 580, 810, 10
pdf.draw_text "Standard App", :at => [200, 790], :size =>17
pdf.draw_text "#{@tname} Collection", :at => [190, 770], :size =>12
data_line=0
line_no=755
	difference=20	
	pdf.move_down(50)
	line_start=2*difference
	line_start1=105
	end_line=500
	line_no1=738
	pdf.line [0,line_start1+662], [580,line_start1+662]
	pdf.line [40,line_start1+662], [40,data_line]
	pdf.line [150,line_start1+662], [150,data_line]
	pdf.line [200,line_start1+662], [200,data_line]
	pdf.line [300,line_start1+662], [300,data_line]
	pdf.line [450,line_start1+662], [450,data_line]
	pdf.line [510,line_start1+662], [510,data_line]
	pdf.line [0,line_start1+642], [580,line_start1+642]

	pdf.draw_text "S.No", :at => [8, line_no], :size =>9
	
	pdf.draw_text "Patient Name", :at => [50, line_no], :size =>9
	pdf.draw_text "Age/Sex", :at => [160, line_no], :size =>9
	pdf.draw_text "Address", :at => [210, line_no], :size =>9
	pdf.draw_text "Test Name", :at => [310, line_no], :size =>9
	pdf.draw_text "Date", :at => [460, line_no], :size =>9
	
	pdf.draw_text "Paid Amount", :at => [520, line_no], :size =>9
	
	i=0
	total=0
	
	page_no=page_no+1
end	

		if(i<54)
		pdf.draw_text "#{s+1}", :at => [15,735-10*i], :size =>9
		@name=TestBooking.find_by_id(@test_amount[s].test_booking.id)
		 
		if(@name)
		@reg=Registration.find_by_mr_no(@name.mr_no)
		if(@reg)
		pdf.draw_text "#{@name.patient_name}", :at => [45,735-10*i], :size =>9
		pdf.draw_text "#{@reg.age}/#{@reg.gender}", :at => [155,735-10*i], :size =>9
			pdf.draw_text "#{@reg.address}", :at => [205,735-10*i], :size =>9
		end
		end
		pdf.draw_text "#{@test_amount[s].test_name }", :at => [305,735-10*i], :size =>9
		
		pdf.draw_text "#{@test_amount[s].created_at.strftime("%d-%m-%Y") }", :at => [460,735-10*i], :size =>9
		pdf.draw_text "#{@test_amount[s].amount}", :at => [525,735-10*i], :size =>9
		
		
		i=i+1
		total=total
end
    pdf.line [0,20], [580,20]
	pdf.draw_text "Total", :at => [460,10], :size =>9
	pdf.draw_text "#{@total}", :at => [525,10], :size =>9
		if(i==54)
			page_no=0
			i=0
			pdf.start_new_page
		end
		k=k+1
end
end
end
