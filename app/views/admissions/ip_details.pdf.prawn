page_no=0
total=0
i=0
k=1
	for admission in @admission
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
		pdf.line [225,line_start1+662], [225,data_line]
		pdf.line [280,line_start1+662], [280,data_line]
		pdf.line [355,line_start1+662], [355,data_line]
		pdf.line [445,line_start1+662], [445,data_line]
		pdf.line [515,line_start1+662], [515,data_line]
	
		pdf.line [0,line_start1+642], [580,line_start1+642]

		pdf.draw_text "S.No", :at => [8, line_no], :size =>9
		pdf.draw_text "MR No", :at => [45, line_no], :size =>9
		pdf.draw_text "Patient Name", :at => [115, line_no], :size =>9
		pdf.draw_text "Age/Gender", :at => [230, line_no], :size =>9
		pdf.draw_text "Date & Time", :at => [285, line_no], :size =>9
		pdf.draw_text "Test Name", :at => [360, line_no], :size =>9
		pdf.draw_text "Consultant", :at => [450, line_no], :size =>9
		pdf.draw_text "Paid Amount", :at => [520, line_no], :size =>9
	
		i=0
		total=0
	
		page_no=page_no+1
	end	

		if(i<54)
			registration=Registration.last(:conditions => "mr_no='#{admission.mr_no}'")
			pdf.draw_text "#{k}", :at => [15,735-10*i], :size =>9
			pdf.draw_text "#{admission.mr_no}", :at => [45,735-10*i], :size =>9
			pdf.draw_text "#{registration.patient_name}", :at => [120,735-10*i], :size =>9
			pdf.draw_text "#{registration.age}/#{registration.gender}", :at => [235,735-10*i], :size =>9
			if(admission.admn_date!="")
				pdf.draw_text "#{admission.admn_date.strftime('%d-%m-%Y')}", :at => [285,735-10*i], :size =>9
			end
			pdf.draw_text "", :at => [365,735-10*i], :size =>9
			pdf.draw_text "", :at => [455,735-10*i], :size =>9
			pdf.draw_text "", :at => [520,735-10*i], :size =>9
			i=i+1
			total=total+10
		end
	    	pdf.line [0,20], [580,20]
		pdf.draw_text "Count", :at => [360,10], :size =>9
		pdf.draw_text "#{i}", :at => [400,10], :size =>9		
		pdf.draw_text "Total", :at => [470,10], :size =>9
		pdf.draw_text "#{number_with_precision(total, :precision => 2, :separator =>'.')}", :at => [520,10], :size =>9
			if(i==54)
				page_no=0
				i=0
				pdf.start_new_page
			end
			k=k+1
	end
	end
