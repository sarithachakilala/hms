page_no=0
total=0
i=0
k=1
if(@patient_type=="OP" || @patient_type=="Both")
	for appt_payments in @appt_payments
	pdf.stroke do
	if(page_no==0)
	pdf.font('Times-Roman')
	pdf.rounded_rectangle [0, 810], 580, 810, 10
	pdf.draw_text "Sandard App", :at => [170, 790], :size =>17
	data_line=20
	line_no=755
		difference=20	
		pdf.move_down(50)
		line_start=2*difference
		line_start1=105
		end_line=500
		line_no1=738
		pdf.line [0,line_start1+662], [580,line_start1+662]
	
	
		pdf.line [30,line_start1+662], [30,data_line]
		pdf.line [105,line_start1+662], [105,data_line]
		pdf.line [240,line_start1+662], [240,data_line]
		pdf.line [300,line_start1+662], [300,data_line]
		pdf.line [380,line_start1+662], [380,data_line]
		pdf.line [430,line_start1+662], [430,data_line]
		pdf.line [500,line_start1+662], [500,data_line]
	
		pdf.line [0,line_start1+642], [580,line_start1+642]

		pdf.draw_text "S.No", :at => [8, line_no], :size =>9
		pdf.draw_text "MR No", :at => [45, line_no], :size =>9
		pdf.draw_text "Patient Name", :at => [115, line_no], :size =>9
		pdf.draw_text "Age/Gender", :at => [250, line_no], :size =>9
		pdf.draw_text "Appt.Date & Time", :at => [310, line_no], :size =>9
		pdf.draw_text "Case", :at => [390, line_no], :size =>9
		pdf.draw_text "Consultant", :at => [435, line_no], :size =>9
		pdf.draw_text "Paid Amount", :at => [510, line_no], :size =>9
	
		i=0
		total=0
	
		page_no=page_no+1
	end	

			if(i<54)
			pdf.draw_text "#{k}", :at => [15,735-10*i], :size =>9
			pdf.draw_text "#{appt_payments.mr_no}", :at => [45,735-10*i], :size =>9
			@registrations=Registration.find_by_mr_no(appt_payments.mr_no)
			consultant=EmployeeMaster.find_by_empid(appt_payments.consultant_id)
			pdf.draw_text "#{@registrations.patient_name}", :at => [120,735-10*i], :size =>9
			pdf.draw_text "#{@registrations.age}/#{@registrations.gender}", :at => [255,735-10*i], :size =>9
			if(appt_payments.appt_date!="")
				pdf.draw_text "#{appt_payments.appt_date.strftime('%d-%m-%Y')} #{appt_payments.appt_time.strftime('%H-%M')}", :at => [310,735-10*i], :size =>9
			end
			pdf.draw_text "OP", :at => [395,735-10*i], :size =>9
			pdf.draw_text "#{consultant.name}", :at => [435,735-10*i], :size =>9
			pdf.draw_text "#{appt_payments.paid_amount}", :at => [510,735-10*i], :size =>9
		
			i=i+1
			total=total
	end
	    pdf.line [0,20], [580,20]
		pdf.draw_text "Count", :at => [380,10], :size =>9
		pdf.draw_text "#{i}", :at => [420,10], :size =>9
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
end
if(@patient_type=="IP" || @patient_type=="Both")
	for appt_payments in @consultant
	pdf.stroke do
	if(page_no==0)
	pdf.font('Times-Roman')
	pdf.rounded_rectangle [0, 810], 580, 810, 10
	pdf.draw_text "Sandard App", :at => [170, 790], :size =>17
	data_line=20
	line_no=755
		difference=20	
		pdf.move_down(50)
		line_start=2*difference
		line_start1=105
		end_line=500
		line_no1=738
		pdf.line [0,line_start1+662], [580,line_start1+662]
	
	
		pdf.line [30,line_start1+662], [30,data_line]
		pdf.line [105,line_start1+662], [105,data_line]
		pdf.line [240,line_start1+662], [240,data_line]
		pdf.line [300,line_start1+662], [300,data_line]
		pdf.line [380,line_start1+662], [380,data_line]
		pdf.line [430,line_start1+662], [430,data_line]
		pdf.line [500,line_start1+662], [500,data_line]
	
		pdf.line [0,line_start1+642], [580,line_start1+642]

		pdf.draw_text "S.No", :at => [8, line_no], :size =>9
		pdf.draw_text "MR No", :at => [45, line_no], :size =>9
		pdf.draw_text "Patient Name", :at => [115, line_no], :size =>9
		pdf.draw_text "Age/Gender", :at => [250, line_no], :size =>9
		pdf.draw_text "Appt.Date & Time", :at => [310, line_no], :size =>9
		pdf.draw_text "Case", :at => [390, line_no], :size =>9
		pdf.draw_text "Consultant", :at => [435, line_no], :size =>9
		pdf.draw_text "Paid Amount", :at => [510, line_no], :size =>9
	
		i=0
		total=0
	
		page_no=page_no+1
	end	
			consultant_visit1=ConsultantVisit.find_by_id(appt_payments.consultant_visit_id)
			if(i<54)
			pdf.draw_text "#{k}", :at => [15,735-10*i], :size =>9
			pdf.draw_text "#{consultant_visit1.mr_no}", :at => [45,735-10*i], :size =>9
			@registrations=Registration.find_by_mr_no(consultant_visit1.mr_no)
			pdf.draw_text "#{@registrations.patient_name}", :at => [120,735-10*i], :size =>9
			pdf.draw_text "#{@registrations.age}/#{@registrations.gender}", :at => [255,735-10*i], :size =>9
			if(appt_payments.date_and_time!="")
				pdf.draw_text "#{appt_payments.date_and_time.strftime('%d-%m-%Y %H-%M')}", :at => [310,735-10*i], :size =>9
			end
			pdf.draw_text "IP", :at => [395,735-10*i], :size =>9
			pdf.draw_text "#{appt_payments.cons_name.split("-")[1]}", :at => [435,735-10*i], :size =>9
			pdf.draw_text "#{appt_payments.charge}", :at => [510,735-10*i], :size =>9
		
			i=i+1
			total=total
	end
	    pdf.line [0,20], [580,20]
		pdf.draw_text "Count", :at => [380,10], :size =>9
		pdf.draw_text "#{i}", :at => [420,10], :size =>9
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
end
