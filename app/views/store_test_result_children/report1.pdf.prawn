
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

pdf.draw_text " LAB INVESTIGATIONS", :at => [10, 730] , :size =>20, :style =>:italic, :style =>:bold
pdf.rounded_rectangle [0, 810], 810, 810, 10
pdf.move_down(10)	
	
pdf.stroke do
line_no=555
line_no1=700

	line_end=550
	difference=22
	pdf.line [0,720], [line_end,720]

	pdf.draw_text "   MR No", :at => [10, line_no1-1*difference] , :size =>10, :style =>:bold
	pdf.draw_text "   Patient Name", :at => [10, line_no1-2*difference] , :size =>10, :style =>:bold
	pdf.draw_text "   Refered By", :at => [10, line_no1-3*difference] , :size =>10, :style =>:bold
	for i  in 1..3
		pdf.draw_text " : ", :at => [100, line_no1-i*difference] 
	end
	if(@registration)
	pdf.draw_text " #{@registration.mr_no	}", :at => [110, line_no1-1*difference]
	pdf.draw_text " #{@registration.patient_name} ", :at => [110, line_no1-2*difference]
	pdf.draw_text " #{@testbooking.refferal_doctor}  M.D.,D.M. ", :at => [110, line_no1-3*difference]
	
	
	pdf.draw_text "   Date", :at => [370, line_no1-1*difference] , :size =>10, :style =>:bold
	pdf.draw_text "   Age", :at => [370, line_no1-2*difference] , :size =>10, :style =>:bold	
	pdf.draw_text "   Sex", :at => [370, line_no1-3*difference] , :size =>10, :style =>:bold
	for j  in 1..3
		pdf.draw_text " : ", :at => [430, line_no1-j*difference] 
	end
	else
	pdf.draw_text "#{@testbooking.lab_no} ", :at => [110, line_no1-1*difference]
	pdf.draw_text " #{@testbooking.patient_name} ", :at => [110, line_no1-2*difference]
	pdf.draw_text " #{@testbooking.refferal_doctor} ", :at => [110, line_no1-3*difference]
	
	
	pdf.draw_text "   Date", :at => [370, line_no1-1*difference] , :size =>10, :style =>:bold
	pdf.draw_text "   Age", :at => [370, line_no1-2*difference] , :size =>10, :style =>:bold	
	pdf.draw_text "   Sex", :at => [370, line_no1-3*difference] , :size =>10, :style =>:bold
	for j  in 1..3
		pdf.draw_text " : ", :at => [430, line_no1-j*difference] 
	end
	end
	pdf.draw_text " #{Date.today.strftime("%d-%m-%Y")}", :at => [450, line_no1-1*difference]
	pdf.draw_text " #{@registration.age} ", :at => [450, line_no1-2*difference]
	pdf.draw_text " #{@registration.gender} ", :at => [450, line_no1-3*difference]
	pdf.line [0,620], [line_end,620]
	i=1
	for tests in @tests
		@store_test_result=StoreTestResult.find_by_service_name_and_lab_no(tests,@lab_no)
		store_test_result_child=StoreTestResultChild.find(:all,:conditions => "store_test_result_id='#{@store_test_result.id}' and (result is not null and result!='')")
		if(i==1)
			lengt=0
			pdf.draw_text " #{tests}", :at => [200, (605)-(((lengt+2)*difference))] , :size =>12	, :style =>:bold 
			lengt=lengt+store_test_result_child.length
		else
			pdf.draw_text " #{tests}", :at => [200, (605)-((lengt*difference)+80)] , :size =>12	, :style =>:bold
			i=i+2
			lengt=lengt+3*store_test_result_child.length
		end
		pdf.move_down(10)
		pdf.draw_text "Test Name", :at => [40, line_no+27] , :size =>11, :style =>:bold
		pdf.draw_text "Result", :at => [250, line_no+27] , :size =>11, :style =>:bold
		pdf.draw_text "Normal Range", :at => [380, line_no+27] , :size =>11, :style =>:bold
		if(@store_test_result)
		for store_test_result_child in @store_test_result.store_test_result_children 
		if(store_test_result_child.result!="")
			pdf.draw_text "#{store_test_result_child.test_name}", :at => [40, line_no-i*difference] , :size =>10
			pdf.draw_text "#{store_test_result_child.result} ", :at => [250, line_no-i*difference] , :size =>10
			pdf.draw_text "#{store_test_result_child.lbound} #{store_test_result_child.units}", :at => [380, line_no-i*difference] , :size =>10
			i=i+1
		end
		end
		
	end
 end  
end
