page_no=0
total=0
i=0
k=1
ref_name=""
for s in 0...@opbilling.length
pdf.stroke do
if(page_no==0)
pdf.font('Times-Roman')
pdf.rounded_rectangle [0, 810], 580, 810, 10
pdf.draw_text "Demo ApplicationL", :at => [230, 790], :size =>14
pdf.draw_text "Referal Report of OP And IP", :at => [230, 770], :size =>9
data_line=20
line_no=755
	difference=20	
	pdf.move_down(50)
	line_start=2*difference
	line_start1=105
	end_line=500
	line_no1=738
	pdf.line [0,line_start1+662], [580,line_start1+662]
	
	
	pdf.line [25,line_start1+662], [25,data_line]
	pdf.line [145,line_start1+662], [145,data_line]
	pdf.line [195,line_start1+662], [195,data_line]
	pdf.line [300,line_start1+662], [300,data_line]
	pdf.line [350,line_start1+662], [350,data_line]
	pdf.line [400,line_start1+662], [400,data_line]
	pdf.line [440,line_start1+662], [440,data_line]
	pdf.line [480,line_start1+662], [480,data_line]
	pdf.line [520,line_start1+662], [520,data_line]
	pdf.line [0,line_start1+642], [580,line_start1+642]

	pdf.draw_text "S.No", :at => [5, line_no], :size =>9
	pdf.draw_text "Ref.Name", :at => [50, line_no], :size =>9
	pdf.draw_text "MR No", :at => [150, line_no], :size =>9
	pdf.draw_text "Patient Name", :at => [200, line_no], :size =>9
	pdf.draw_text "Age/Gender", :at => [305, line_no], :size =>9
	pdf.draw_text "Date", :at => [355, line_no], :size =>9
	pdf.draw_text "OP", :at => [405, line_no], :size =>9
	pdf.draw_text "LAB", :at => [445, line_no], :size =>9
	pdf.draw_text "IP", :at => [485, line_no], :size =>9
	pdf.draw_text "PHARMACY", :at => [525, line_no], :size =>9
	
	i=0
	total=0
	
	page_no=page_no+1
end	 
     
	  
		if(i<60)
		if(ref_name!=@opbilling[s].referral_name)
			i=i+1
			pdf.draw_text "#{k}", :at => [7,735-10*i], :size =>9
			pdf.draw_text "#{@opbilling[s].referral_name}", :at => [30,735-10*i], :size =>9
			ref_name=@opbilling[s].referral_name
		else
			pdf.draw_text "#{k}", :at => [7,735-10*i], :size =>9
		end
		pdf.draw_text "#{@opbilling[s].mr_no}", :at => [147,735-10*i], :size =>9
		pdf.draw_text "#{@opbilling[s].patient_name}", :at => [205,735-10*i], :size =>9
		pdf.draw_text "#{@opbilling[s].age}/#{@opbilling[s].gender}", :at => [307,735-10*i], :size =>9
	
		
			pdf.draw_text "#{@opbilling[s].reg_date.strftime('%d-%m-%Y')}", :at => [355,735-10*i], :size =>9
			
			pamt=AppointmentPayment.find_by_mr_no(@opbilling[s].mr_no)
			totalop=0
			if(pamt)
					
			pdf.draw_text "#{pamt.paid_amount}", :at => [405,735-10*i], :size =>9
			else
			pdf.draw_text "0", :at => [405,735-10*i], :size =>9
			end
			lamt=TestBooking.find_by_mr_no(@opbilling[s].mr_no)
			if(lamt)
		    pdf.draw_text "#{lamt.paid_amount}", :at => [445,735-10*i], :size =>9	
		    else
			 pdf.draw_text "0", :at => [445,735-10*i], :size =>9
			 end
		    ipamt=FinalBill.find_by_mr_no(@opbilling[s].mr_no)
			if(ipamt)
		    pdf.draw_text "#{ipamt.paid_amount}", :at => [485,735-10*i], :size =>9	
		    else
			 pdf.draw_text "0", :at => [485,735-10*i], :size =>9
			 end
			 phamt=IssuesToOp.find_by_mr_no(@opbilling[s].mr_no)
			 if(phamt)
		    pdf.draw_text "#{phamt.paid_amt}", :at => [525,735-10*i], :size =>9	
		    else
			 pdf.draw_text "0", :at => [525,735-10*i], :size =>9
			 end
		i=i+1
		



    pdf.line [0,20], [580,20]
	pdf.draw_text "Count", :at => [380,10], :size =>9
	pdf.draw_text "#{i}", :at => [430,10], :size =>9
	pdf.draw_text "Total", :at => [490,10], :size =>9
	pdf.draw_text "#{number_with_precision(@tot, :precision => 2, :separator =>'.')}", :at => [530,10], :size =>9
		if(i>=60)
			page_no=0
			i=0
			pdf.start_new_page
		end
		k=k+1
end
end
end

pdf.start_new_page
page_no=0
total=0
i=0
k=1
ref_name=""
for s in 0...@osp.length
pdf.stroke do
if(page_no==0)
pdf.font('Times-Roman')
pdf.rounded_rectangle [0, 810], 580, 810, 10
pdf.draw_text "Demo Application", :at => [230, 790], :size =>14
pdf.draw_text "Referal Report of OSP", :at => [230, 770], :size =>9
data_line=20
line_no=755
	difference=20	
	pdf.move_down(50)
	line_start=2*difference
	line_start1=105
	end_line=500
	line_no1=738
	pdf.line [0,line_start1+662], [580,line_start1+662]
	
	
	pdf.line [25,line_start1+662], [25,data_line]
	pdf.line [145,line_start1+662], [145,data_line]
	pdf.line [195,line_start1+662], [195,data_line]
	pdf.line [300,line_start1+662], [300,data_line]
	pdf.line [350,line_start1+662], [350,data_line]
	pdf.line [400,line_start1+662], [400,data_line]
	pdf.line [440,line_start1+662], [440,data_line]
	pdf.line [480,line_start1+662], [480,data_line]
	pdf.line [520,line_start1+662], [520,data_line]
	pdf.line [0,line_start1+642], [580,line_start1+642]

	pdf.draw_text "S.No", :at => [5, line_no], :size =>9
	pdf.draw_text "Ref.Name", :at => [50, line_no], :size =>9
	pdf.draw_text "MR No", :at => [150, line_no], :size =>9
	pdf.draw_text "Patient Name", :at => [200, line_no], :size =>9
	pdf.draw_text "Age/Gender", :at => [305, line_no], :size =>9
	pdf.draw_text "Date", :at => [355, line_no], :size =>9
	pdf.draw_text "OP", :at => [405, line_no], :size =>9
	pdf.draw_text "LAB", :at => [445, line_no], :size =>9
	pdf.draw_text "IP", :at => [485, line_no], :size =>9
	pdf.draw_text "PHARMACY", :at => [525, line_no], :size =>9
	
	i=0
	total=0
	
	page_no=page_no+1
end	 
     
	  
		if(i<60)
		if(ref_name!=@osp[s].refferal_doctor)
			i=i+1
			pdf.draw_text "#{k}", :at => [7,735-10*i], :size =>9
			pdf.draw_text "#{@osp[s].refferal_doctor}", :at => [30,735-10*i], :size =>9
			ref_name=@osp[s].refferal_doctor
		else
			pdf.draw_text "#{k}", :at => [7,735-10*i], :size =>9
		end
		pdf.draw_text "", :at => [147,735-10*i], :size =>9
		pdf.draw_text "#{@osp[s].patient_name}", :at => [205,735-10*i], :size =>9
		
	
		
			pdf.draw_text "#{@osp[s].booking_date.strftime('%d-%m-%Y')}", :at => [355,735-10*i], :size =>9
			
			
			
		    pdf.draw_text "#{@osp[s].paid_amount}", :at => [445,735-10*i], :size =>9	
		   
			
		   
			
		i=i+1
		



    pdf.line [0,20], [580,20]
	pdf.draw_text "Count", :at => [380,10], :size =>9
	pdf.draw_text "#{i}", :at => [430,10], :size =>9
	pdf.draw_text "Total", :at => [490,10], :size =>9
	pdf.draw_text "#{@ospamt}", :at => [530,10], :size =>9
		if(i>=60)
			page_no=0
			i=0
			pdf.start_new_page
		end
		k=k+1
end
end
end
