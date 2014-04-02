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
pdf.rounded_rectangle [-4, 810], 585, 830, 10

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
line_no=710
	
	pdf.font_size=10
	line_end=550
	difference=25
	date=Time.now.strftime("%d-%m-%Y")
	doctor_master=EmployeeMaster.find_by_empid_and_org_code(@treatment_plan.consultant_id,@treatment_plan.org_code)
	@medicinelist1 = MedicineList.find_by_treatment_plan_id(@treatment_plan.id)
	pdf.line [0,730], [580,730]

	pdf.move_down(15)
	pdf.text "<b>TREATMENT PLAN RECEIPT</b>", :align => :center, :inline_format => true
	
	
	pdf.draw_text "MR No", :at => [10, line_no-1*difference], :size =>10
	pdf.draw_text "Patient Name", :at => [10, line_no-2*difference] , :size =>10
	pdf.draw_text "Age/Sex", :at => [10, line_no-3*difference] , :size =>10
	pdf.draw_text "Doctor", :at => [10, line_no-4*difference], :size =>10
	
	
	pdf.draw_text "Weight", :at => [10, line_no-6*difference], :size =>10, :style=>:bold
	pdf.draw_text ":", :at => [60, line_no-6*difference], :size =>10, :style=>:bold
	pdf.draw_text " #{@vital.weight} ", :at => [70, line_no-6*difference], :style=>:bold
	pdf.draw_text "Pulse", :at => [120, line_no-6*difference], :size =>10, :style=>:bold
	pdf.draw_text ":", :at => [160, line_no-6*difference], :size =>10, :style=>:bold
	pdf.draw_text " #{@vital.pulse} ", :at => [170, line_no-6*difference], :style=>:bold
	pdf.draw_text "Temperature", :at => [210, line_no-6*difference], :size =>10, :style=>:bold
	pdf.draw_text ":", :at => [280, line_no-6*difference], :size =>10
	pdf.draw_text " #{@vital.temparature} ", :at => [290, line_no-6*difference], :style=>:bold
	pdf.draw_text "Bp Systolic", :at => [330, line_no-6*difference], :size =>10, :style=>:bold
	pdf.draw_text ":", :at => [395, line_no-6*difference], :size =>10
	pdf.draw_text " #{@vital.bp_systolic} ", :at => [400, line_no-6*difference], :style=>:bold
	
	pdf.draw_text "Bp Diastolic", :at => [430, line_no-6*difference], :size =>10, :style=>:bold
	
	pdf.draw_text ":", :at => [500, line_no-6*difference], :size =>10
	pdf.draw_text " #{@vital.bp_diastolic} ", :at => [510, line_no-6*difference], :style=>:bold
	
	
	

	for i  in 1..4
		pdf.draw_text " : ", :at => [100, line_no-i*difference] 
	end
	
	
	pdf.draw_text " #{@treatment_plan.mr_no} ", :at => [150, line_no-1*difference] 
	pdf.draw_text " #{@registration.title+"."+@registration.patient_name} ", :at => [150, line_no-2*difference]
	pdf.draw_text " #{@registration.age}/#{@registration.gender} ", :at => [150, line_no-3*difference] 
	pdf.draw_text " #{doctor_master.name}", :at => [150, line_no-4*difference] 
	
	pdf.draw_text "Date/Time", :at => [420, line_no-1*difference] , :size =>10
	pdf.draw_text "Bill No", :at => [420, line_no-2*difference] , :size =>10
	pdf.draw_text "Next Visit", :at => [420, line_no-3*difference] , :size =>10
	for i  in 1..3
		pdf.draw_text " : ", :at => [470, line_no-i*difference] 
	end

	pdf.draw_text " #{@treatment_plan.treatment_date.strftime("%d-%m-%Y")}/#{@treatment_plan.treatment_time.strftime("%I:%M%p")}", :at => [483, line_no-1*difference] 
	pdf.draw_text " #{@vital.id} ", :at => [490, line_no-2*difference]
if(@treatment_plan.next_visit)	
	pdf.draw_text " #{@treatment_plan.next_visit.strftime("%d-%m-%Y")} ", :at => [490, line_no-3*difference] 
end	
	pdf.draw_text " Instructions: ", :at => [10, line_no-18*difference], :style=>:bold
	pdf.draw_text " : ", :at => [100, line_no-18*difference] 
	pdf.draw_text " #{@treatment_plan.advice} ", :at => [120, line_no-18*difference]
	
	
	
	
	
	
	
	
	pdf.draw_text " Medication: ", :at => [10, line_no-8*difference]
	
	pdf.line [10,500],[line_end-5,500]
	pdf.line [10,470],[line_end-5,470]
	pdf.line [10,330],[line_end-5,330]
	
	
	i=10
	j=600
	pdf.draw_text "Medicine", :at => [i+15, j-5*difference], :size =>10
	pdf.draw_text "Frequency", :at => [i+160, j-5*difference], :size =>10
	pdf.draw_text "Quantity", :at => [i+240, j-5*difference], :size =>10
	pdf.draw_text "No. of Days", :at => [i+320, j-5*difference], :size =>10
	pdf.draw_text "M E N", :at => [i+430, j-5*difference], :size =>10
	
	
	for store in @treatment_plan.medicine_list
	pdf.draw_text " #{store.name} ", :at => [i+15, j-6*difference]
	pdf.draw_text " #{store.frequency} ", :at => [i+175, j-6*difference]
	pdf.draw_text " #{store.quantity} ", :at => [i+240, j-6*difference]
	pdf.draw_text " #{store.days} ", :at => [i+320, j-6*difference]
	pdf.draw_text " #{store.morning}--#{store.afternoon}--#{store.night} ", :at => [i+430, j-6*difference]
	j=j+8
	difference=difference+4
	end
	
	
	k=330
	pdf.line [10,500],[10,k]
	pdf.line [160,500],[160,k]
	pdf.line [240,500],[240,k]
	pdf.line [320,500],[320,k]
	pdf.line [420,500],[420,k]
	pdf.line [line_end-5,500],[line_end-5,k]
	

	
	
	
	
	
	pdf.draw_text "(Authorised Signature)", :at => [425, 17], :size =>10
	
	
	
	
	if(@print_type=="duplicate")
	pdf.draw_text "Duplicate", :at => [430, 720] , :size =>10, :style=>:bold
	else
	pdf.draw_text "Original", :at => [430, 720] , :size =>10, :style=>:bold
	end
	
end
