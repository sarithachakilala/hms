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

pdf.font_size =10


pdf.stroke do
line_no=630
	pdf.move_down(125)
	line_end=900
	difference=25
	doctor_master=ConsultantMaster.find_by_consultant_id_and_org_code(@admission.consultant_id,@admission.org_code)
	
	pdf.text "<b><u>Discharge Summary</u><b>", :size => 12, :align => :center, :inline_format => true
	
	
	pdf.draw_text "Patient Name", :at => [10, line_no-1*difference] , :size =>10
	pdf.draw_text "MR No", :at => [10, line_no-2*difference], :size =>10
	pdf.draw_text "Admn.No", :at => [10, line_no-3*difference], :size =>10
if(@discharge_summary.review_date != "")
	pdf.draw_text "Review Date", :at => [10, line_no-4*difference], :size =>10
end
	for i  in 1..4
		pdf.draw_text " : ", :at => [80, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@registration.title+"."+@registration.patient_name} ", :at => [110, line_no-1*difference], :size =>10
	pdf.draw_text " #{@registration.mr_no} ", :at => [110, line_no-2*difference], :size =>10 
	pdf.draw_text " #{@admission.admn_no} ", :at => [110, line_no-3*difference], :size =>10
if(@discharge_summary.review_date != "")
	pdf.draw_text " #{@discharge_summary.review_date.strftime("%d-%m-%Y")} ", :at => [110, line_no-4*difference], :size =>10
end
	
	
	pdf.draw_text "Age/Sex", :at => [310, line_no-1*difference] , :size =>10
	pdf.draw_text "D.O.A/Time", :at => [310, line_no-2*difference] , :size =>10
	pdf.draw_text "D.O.D/Time", :at => [310, line_no-3*difference] , :size =>10
	
	
	for i  in 1..3
		pdf.draw_text " : ", :at => [360, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@registration.age}/#{@registration.gender}", :at => [380, line_no-1*difference], :size =>10
	pdf.draw_text " #{@admission.admn_date.strftime("%d-%m-%Y")} / #{@admission.admn_time.strftime('%I:%M%p')}", :at => [380, line_no-2*difference], :size =>10
	pdf.draw_text " #{@discharge_summary.discharge_date.strftime("%d-%m-%Y")} / #{@discharge_summary.time.strftime('%I:%M%p')}", :at => [380, line_no-3*difference], :size =>10
	
	
	
		
		pdf.draw_text "Case Discussion:", :at => [10,480], :size =>12,  :style=>:bold
		pdf.draw_text "Final Diagonsis:", :at => [10,460], :size =>11,  :style=>:bold
		
		
		pdf.draw_text "Investigations:", :at => [10,400], :size =>11,  :style=>:bold
		pdf.draw_text "Report Closed", :at => [110,400]
		
		
		
		
		pdf.draw_text " Medication: ", :at => [7, 380], :size =>11,  :style=>:bold
	
	pdf.line [10,375],[480,375]
	pdf.line [10,350],[480,350]
	pdf.line [10,170],[480,170]
	
	
	i=10
	j=480
	pdf.draw_text "Medicine", :at => [i+15, j-5*difference], :size =>10
	pdf.draw_text "Frequency", :at => [i+160, j-5*difference], :size =>10
	pdf.draw_text "Quantity", :at => [i+240, j-5*difference], :size =>10
	pdf.draw_text "No. of Days", :at => [i+320, j-5*difference], :size =>10
	pdf.draw_text "M E N", :at => [i+425, j-5*difference], :size =>10
	
	

	
	for store in @discharge_summary.medicine_list
	pdf.draw_text " #{store.name} ", :at => [i+10, j-6*difference]
	pdf.draw_text " #{store.frequency} ", :at => [i+175, j-6*difference]
	pdf.draw_text " #{store.quantity} ", :at => [i+240, j-6*difference]
	pdf.draw_text " #{store.amount} ", :at => [i+320, j-6*difference]
	pdf.draw_text " #{store.morning}--#{store.afternoon}--#{store.night} ", :at => [i+425, j-6*difference]
	
	j=j+8
	difference=difference+4
	end
	
	
	k=170
	pdf.line [10,375],[10,k]
	pdf.line [160,375],[160,k]
	pdf.line [240,375],[240,k]
	pdf.line [320,375],[320,k]
	pdf.line [420,375],[420,k]
	pdf.line [480,375],[480,k]
	
	pdf.draw_text " Discharge Advice: ", :at => [10, 130], :size =>11,  :style=>:bold
	
	pdf.text_box " #{@discharge_summary.summary}", :at => [115,137], :width =>780, :height => 120, :size =>10
	
	pdf.draw_text " Authorised Signature ", :at => [450, 20]
	
	
end


	

	


