
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
pdf.rounded_rectangle [-2, 800], 560, 800, 10
home=Home.last
if(home)
	prawn_logo = "public/images/#{home.image_path}"
else
	prawn_logo = "public/images/hs-gol.png"
end
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
pdf.image prawn_logo, :at => [10, 780],:width => 110, :height => 30
pdf.stroke do
line_no=700

	line_end=555
	difference=20
	pdf.move_down(10)
	doctor_master=EmployeeMaster.find_by_empid_and_org_code(@admission.consultant_id,@admission.org_code)
	pdf.text "<b>Registration Record/Admission Record<b>", :size => 13, :align => :center, :inline_format => true
	pdf.line [0,725], [line_end,725]
	pdf.draw_text "Admn.No", :at => [0, line_no-1*difference], :size =>10
	pdf.draw_text "Patient Name", :at => [0, line_no-2*difference] , :size =>10
	pdf.draw_text "Father/Husband", :at => [0, line_no-3*difference] , :size =>10
	pdf.draw_text "Address", :at => [0, line_no-4*difference], :size =>10
	pdf.draw_text "Consultant", :at => [0, line_no-5*difference], :size =>10
	
	for i  in 1..5
		pdf.draw_text " : ", :at => [140, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@admission.admn_no} ", :at => [150, line_no-1*difference] 
	pdf.draw_text " #{@registration.title+"."+@registration.patient_name}", :at => [150, line_no-2*difference]
	pdf.draw_text " #{@registration.father_name}", :at => [150, line_no-3*difference]
	pdf.draw_text " #{@registration.address} ", :at => [150, line_no-4*difference]
if(doctor_master)
	pdf.draw_text " #{doctor_master.name} ", :at => [150, line_no-5*difference]
end
	
	
	pdf.draw_text "Admn.Date", :at => [280, line_no-1*difference] , :size =>10
	pdf.draw_text "Age", :at => [280, line_no-2*difference] , :size =>10
	pdf.draw_text "Department", :at => [280, line_no-3*difference], :size =>10
	
	
	for i  in 1..3
		pdf.draw_text " : ", :at => [350, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@admission.admn_date} ", :at => [360, line_no-1*difference] 
	pdf.draw_text " #{@registration.age} ", :at => [360, line_no-2*difference]
	pdf.draw_text " #{@admission.department} ", :at => [360, line_no-3*difference] 
	
	
	pdf.draw_text "Gender", :at => [440, line_no-2*difference] , :size =>10
	pdf.draw_text " : ", :at => [490, line_no-2*difference]  
	pdf.draw_text " #{@registration.gender} ", :at => [500, line_no-2*difference]
	
	
	pdf.move_down(168)
	pdf.line [0,line_no-7*22-10], [550,line_no-7*22-10]
	pdf.text " <b>  Admn.no      Admn.date     Dis.Date                   Ward                    Room             Bed         No.of Days</b>", :inline_format => true
	
	pdf.line [0,line_no-7*22-10], [0,line_no-11*22-10]
	pdf.line [70,line_no-7*22-10], [0+70,line_no-11*22-10]
	pdf.line [140,line_no-7*22-10], [0+140,line_no-11*22-10]
	pdf.line [210,line_no-7*22-10], [0+210,line_no-11*22-10]
	pdf.line [340,line_no-7*22-10], [340,line_no-11*22-10]
	pdf.line [420,line_no-7*22-10], [420,line_no-11*22-10]
	pdf.line [480,line_no-7*22-10], [480,line_no-11*22-10]
	pdf.line [550,line_no-7*22-10], [550,line_no-11*22-10]
	
	pdf.line [0,line_no-(9*22-10)], [550,line_no-(9*22-10)]
	pdf.draw_text "#{@admission.admn_no}", :at => [5, line_no-(10*22-10)]
	pdf.draw_text "#{@admission.admn_date}", :at => [5+70*1, line_no-(10*22-10)]
	days=0
	if(@discharge)
		days=(@discharge.discharge_date-@admission.admn_date).to_i
		pdf.draw_text "#{@discharge.discharge_date}", :at => [5+70*2, line_no-(10*22-10)]
	else
		days=(Date.today-@admission.admn_date).to_i
		pdf.draw_text "---------------", :at => [5+70*2, line_no-(10*22-10)]
	end
	pdf.draw_text "#{@admission.ward}", :at => [5+70*3, line_no-(10*22-10)]
	pdf.draw_text "#{@admission.room}", :at => [70*5, line_no-(10*22-10)]
	pdf.draw_text "#{@admission.bed}", :at => [5+70*6, line_no-(10*22-10)]
	pdf.draw_text "#{days+1}", :at => [70*7, line_no-(10*22-10)]
	pdf.line [0,line_no-11*22-10], [550,line_no-11*22-10]
	pdf.move_down(100)
	pdf.text "<b>Discharge status</b>             : #{@admission.admn_status}", :inline_format => true
	pdf.move_down(10)
	pdf.text "<b>Cause of death</b>                : ", :inline_format => true
	pdf.move_down(10)
if(@admission.attendant_name)
	pdf.text "<b>Attendent name</b>                :   #{@admission.attendant_name}                 <b>Mobile No</b> :  #{@admission.attendant_ph_no} ", :inline_format => true
end
	pdf.draw_text "Signature of Attending Doctor ", :at => [0, 50]
	pdf.draw_text "Signature of Hod of Dept.", :at => [350, 50]
end
pdf.start_new_page
pdf.rounded_rectangle [-2, 800], 560, 800, 10
pdf.image prawn_logo, :width => 200, :height => 30, :position => :center

pdf.stroke do
line_no=720
line_end=550
	pdf.move_down(10)
	pdf.text "<b>Billing Record</b>", :size => 13, :align => :center, :inline_format => true
	pdf.line [0,725], [line_end,725]
	difference=20
	doctor_master=EmployeeMaster.find_by_empid_and_org_code(@admission.consultant_id,@admission.org_code)
	pdf.draw_text "Admn.No", :at => [0, line_no-1*difference], :size =>10
	pdf.draw_text "Patient Name", :at => [0, line_no-2*difference] , :size =>10
	pdf.draw_text "Consultant", :at => [0, line_no-3*difference], :size =>10
	
	for i  in 1..3
		pdf.draw_text " : ", :at => [110, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@admission.admn_no} ", :at => [120, line_no-1*difference] 
	pdf.draw_text " #{@registration.title+"."+@registration.patient_name} ", :at => [120, line_no-2*difference]
if(doctor_master)
	pdf.draw_text " #{doctor_master.name} ", :at => [120, line_no-3*difference]
end	
	
	pdf.draw_text "Admn.Date", :at => [260, line_no-1*difference] , :size =>10
	pdf.draw_text "Age", :at => [260, line_no-2*difference] , :size =>10
	pdf.draw_text "Department", :at => [260, line_no-3*difference], :size =>10
	
	for i  in 1..3
		pdf.draw_text " : ", :at => [340, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@admission.admn_date} ", :at => [350, line_no-1*difference] 
	pdf.draw_text " #{@registration.age} ", :at => [350, line_no-2*difference]
	pdf.draw_text " #{@admission.department} ", :at => [350, line_no-3*difference]
	
	pdf.draw_text "Gender", :at => [440, line_no-2*difference] , :size =>10
	pdf.draw_text " : ", :at => [490, line_no-2*difference]  
	pdf.draw_text " #{@registration.gender} ", :at => [500, line_no-2*difference]
	
	pdf.move_down(130)
	pdf.text "<u><b>Patient Movements</b></u>" , :inline_format => true
	pdf.move_down(15)
	line_start=7*22-5
	pdf.line [0,line_no-line_start], [550,line_no-line_start]
	pdf.text " <b>  S.No             Ward          Room  Bed   Date&Time       Ward               Room  Bed   No.of days  Cost </b>", :inline_format => true
	pdf.line [0,line_no-7*24], [550,line_no-7*24]
	
	pdf.line [0,line_no-line_start], [0,line_no-13*25]
	pdf.line [35,line_no-line_start], [35,line_no-13*25]
	pdf.line [130,line_no-line_start], [130,line_no-13*25]
	pdf.line [170,line_no-line_start], [170,line_no-13*25]
	pdf.line [200,line_no-line_start], [200,line_no-13*25]
	pdf.line [270,line_no-line_start], [270,line_no-13*25]
	pdf.line [370,line_no-line_start], [370,line_no-13*25]
	pdf.line [410,line_no-line_start], [410,line_no-13*25]
	pdf.line [445,line_no-line_start], [445,line_no-13*25]
	pdf.line [510,line_no-line_start], [510,line_no-13*25]
	pdf.line [550,line_no-line_start], [550,line_no-13*25]
	
	pdf.line [0,line_no-13*25], [550,line_no-13*25]
	i=1
	amount=0
	days=0

	for bedtransfer in @bedtransfer
		amount=bedtransfer.amount.to_f-amount.to_f
		days=bedtransfer.no_of_days.to_i-days.to_i
		pdf.draw_text "#{i}", :at => [10,550-20*i]
		pdf.draw_text "#{bedtransfer.from_ward}", :at => [40,550-20*i]
		pdf.draw_text "#{bedtransfer.from_room}", :at => [135,550-20*i]
		pdf.draw_text "#{bedtransfer.from_bed}", :at => [175,550-20*i]
		pdf.draw_text "#{bedtransfer.transfer_date}", :at => [205,550-20*i]
		pdf.draw_text "#{bedtransfer.to_ward}", :at => [275,550-20*i]
		pdf.draw_text "#{bedtransfer.to_room}", :at => [375,550-20*i]
		pdf.draw_text "#{bedtransfer.to_bed}", :at => [415,550-20*i]
		pdf.draw_text "#{days}", :at => [460,550-20*i]
		pdf.draw_text "#{amount}", :at => [515,550-20*i]
		i=i+1
		amount=bedtransfer.amount
		days=bedtransfer.no_of_days
	end

	
end	


pdf.start_new_page
	pdf.rounded_rectangle [-2, 800], 560, 800, 10
	pdf.image prawn_logo, :width => 200, :height => 30, :position => :center
	pdf.stroke do
	line_no=942
	line_end=550
	end_line=400
	pdf.line [0,745], [line_end,745]
	pdf.move_down(40)
	pdf.text "<u><b>Consultant Visits</b></u>" , :inline_format => true
	pdf.move_down(20)
	pdf.line [0,line_no-10*25-5], [500,line_no-10*25-5]
	pdf.text " <b>  S.No            Consultant Name       Department               Date & Time           Cost    </b>", :inline_format => true
	pdf.line [0,line_no-10*27-5], [500,line_no-10*27-5]
	
	pdf.line [0,line_no-10*25-5], [0,end_line]
	pdf.line [60,line_no-10*25-5], [60,end_line]
	pdf.line [170,line_no-10*25-5], [170,end_line]
	pdf.line [280,line_no-10*25-5], [280,end_line]
	pdf.line [400,line_no-10*25-5], [400,end_line]
	pdf.line [500,line_no-10*25-5], [500,end_line]
	
	pdf.line [0,end_line], [500,end_line]
	i=0
	for consultant_visits in @consultant_visits
		doctor_master=EmployeeMaster.find_by_empid_and_org_code(consultant_visits.consultant,consultant_visits.org_code)
		pdf.draw_text "#{i+1}", :at => [10,650-20*i]
		pdf.draw_text "#{consultant_visits.consultant.split("-")[1]}", :at => [70,650-20*i]
		pdf.draw_text "#{consultant_visits.department}", :at => [180,650-20*i]
		pdf.draw_text "#{consultant_visits.date_of_visit}.#{consultant_visits.time_of_visit.strftime('%H:%M')}", :at => [290,650-20*i]
		pdf.draw_text "#{consultant_visits.charge}", :at => [410,650-20*i]
		i=i+1
	end
end

pdf.start_new_page
pdf.rounded_rectangle [-2, 800], 560, 800, 10
pdf.image prawn_logo, :width => 200, :height => 30, :position => :center

pdf.stroke do
line_no=720
line_end=550
	pdf.move_down(10)
	pdf.text "<b>History & Physical Examination Record</b>", :size => 13, :align => :center, :inline_format => true
	pdf.line [0,725], [line_end,725]
	pdf.move_down(20)
	difference=20
	
	pdf.draw_text "Admn.No", :at => [0, line_no-1*difference], :size =>10
	pdf.draw_text "Patient Name", :at => [0, line_no-2*difference] , :size =>10
	
	for i  in 1..2
		pdf.draw_text " : ", :at => [110, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@admission.admn_no} ", :at => [120, line_no-1*difference] 
	pdf.draw_text " #{@registration.title+"."+@registration.patient_name} ", :at => [120, line_no-2*difference]
		
	pdf.draw_text "Admn.Date", :at => [240, line_no-1*difference] , :size =>10
	pdf.draw_text "Age", :at => [240, line_no-2*difference] , :size =>10
	
	for i  in 1..2
		pdf.draw_text " : ", :at => [320, line_no-i*difference] 
	end
	
	pdf.draw_text " #{@admission.admn_date} ", :at => [330, line_no-1*difference] 
	pdf.draw_text " #{@registration.age} ", :at => [330, line_no-2*difference]
	
	pdf.draw_text "Gender", :at => [430, line_no-2*difference] , :size =>10
	pdf.draw_text " : ", :at => [480, line_no-2*difference]  
	pdf.draw_text " #{@registration.gender} ", :at => [490, line_no-2*difference]
	
	pdf.move_down(50)
	pdf.text "<u><b>History</b></u>" ,:align => :center, :inline_format => true
	pdf.move_down(10)
	if(@history)
		pdf.text "<b>           Cheif Complaints   :</b>  #{@history.chief_complaints}" , :inline_format => true
	
		pdf.move_down(10)
		pdf.text "<u><b>Family History</b></u>" , :inline_format => true
		pdf.draw_text "Mother Root :  #{@history.mother_root}", :at => [20,570]
		pdf.draw_text "Father Root  :  #{@history.father_root}", :at => [20,550]
	
		pdf.move_down(60)
		pdf.text "<u><b>Past History</b></u>" , :inline_format => true
		pdf.draw_text "Marital Status  : #{@registration.marital_status}",:at => [20,490]
		pdf.draw_text "Medical            : #{@history.past_medical_history}", :at => [20,470]
		pdf.draw_text "Surgical           : #{@history.surgical_history}", :at => [20,450]
	else
		pdf.text "<b>           Cheif Complaints   :</b> " , :inline_format => true
	
		pdf.move_down(10)
		pdf.text "<u><b>Family History</b></u>" , :inline_format => true
		pdf.draw_text "Mother Root :  ", :at => [20,570]
		pdf.draw_text "Father Root  :  ", :at => [20,550]
	
		pdf.move_down(60)
		pdf.text "<u><b>Past History</b></u>" , :inline_format => true
		pdf.draw_text "Marital Status  : #{@registration.martial_status}",:at => [20,490]
		pdf.draw_text "Medical            : ", :at => [20,470]
		pdf.draw_text "Surgical           : ", :at => [20,450]

	end
	
end




	
