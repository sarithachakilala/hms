page_no=0
total=0
i=0
k=1
for appt_payments in @appt_payments
pdf.stroke do
if(page_no==0)
pdf.font('Times-Roman')
pdf.rounded_rectangle [0, 810], 580, 810, 10
pdf.draw_text "AMRUTHA HEART HOSPITAL", :at => [170, 790], :size =>17
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
	pdf.line [115,line_start1+662], [115,data_line]
	pdf.line [250,line_start1+662], [250,data_line]
	pdf.line [340,line_start1+662], [340,data_line]
	pdf.line [420,line_start1+662], [420,data_line]
	pdf.line [490,line_start1+662], [490,data_line]
	
	pdf.line [0,line_start1+642], [580,line_start1+642]

	pdf.draw_text "S.No", :at => [8, line_no], :size =>9
	pdf.draw_text "MR No", :at => [50, line_no], :size =>9
	pdf.draw_text "Patient Name", :at => [125, line_no], :size =>9
	pdf.draw_text "Age/Gender", :at => [260, line_no], :size =>9
	pdf.draw_text "Appt.Date & Time", :at => [350, line_no], :size =>9
	pdf.draw_text "Consultant", :at => [430, line_no], :size =>9
	pdf.draw_text "Paid Amount", :at => [500, line_no], :size =>9
	
	i=0
	total=0
	
	page_no=page_no+1
end	

		if(i<54)
		pdf.draw_text "#{k}", :at => [15,735-10*i], :size =>9
		pdf.draw_text "#{appt_payments.mr_no}", :at => [50,735-10*i], :size =>9
		@registrations=Registration.find_by_mr_no(appt_payments.mr_no)
		consultant=ConsultantMaster.find_by_consultant_id(appt_payments.consultant_id)
		pdf.draw_text "#{@registrations.first_name}.#{@registrations.last_name}", :at => [125,735-10*i], :size =>9
		pdf.draw_text "#{@registrations.age}/#{@registrations.gender}", :at => [260,735-10*i], :size =>9
		if(appt_payments.cons_date!="")
			pdf.draw_text "#{appt_payments.cons_date.strftime('%d-%m-%Y')}   #{appt_payments.appt_time.strftime('%H-%M')}", :at => [345,735-10*i], :size =>9
		end
		pdf.draw_text "#{consultant.name}", :at => [430,735-10*i], :size =>9
		pdf.draw_text "#{appt_payments.paid_amount}", :at => [500,735-10*i], :size =>9
		
		i=i+1
		total=total
end
    pdf.line [0,20], [580,20]
	pdf.draw_text "Total", :at => [450,10], :size =>9
	pdf.draw_text "#{@total}", :at => [500,10], :size =>9
		if(i==54)
			page_no=0
			i=0
			pdf.start_new_page
		end
		k=k+1
end
end