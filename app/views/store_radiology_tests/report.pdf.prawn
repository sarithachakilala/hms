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
pdf.image prawn_logo, :width => 200, :height => 30
@org=OrgMasterChildTable.last
	if(@org)
			pdf.draw_text "#{@org.address}", :at => [210, 780], :size=>12
			pdf.draw_text "PHONE:", :at => [210, 760], :size =>12			
			pdf.draw_text "#{@org.ph_no}", :at => [260, 760], :size=>12 
			pdf.draw_text "EMAIL:", :at => [210, 740], :size =>12			
			pdf.draw_text "#{@org.email}", :at => [260, 740], :size=>12

	end

pdf.rounded_rectangle [-4, 810], 570, 800, 10
	
	
pdf.stroke do
line_no=555
line_no1=700

	line_end=550
	difference=22
	pdf.line [0,720], [line_end,720]
	pdf.draw_text "   Bill No", :at => [10, line_no1-1*difference] , :size =>12
	pdf.draw_text "   Patient Name", :at => [10, line_no1-2*difference] , :size =>12
	pdf.draw_text "   Refered By", :at => [10, line_no1-3*difference] , :size =>12
	for i  in 1..3
		pdf.draw_text " : ", :at => [100, line_no1-i*difference] 
	end
	pdf.draw_text " #{@testbooking.bill_no	}", :at => [110, line_no1-1*difference]
	pdf.draw_text " #{@registration.patient_name} ", :at => [110, line_no1-2*difference]
	pdf.draw_text " #{@testbooking.refferal_doctor} ", :at => [110, line_no1-3*difference]
	
	
	pdf.draw_text "   Date", :at => [370, line_no1-1*difference] , :size =>12
	pdf.draw_text "   Age", :at => [370, line_no1-2*difference] , :size =>12
	pdf.draw_text "   Sex", :at => [370, line_no1-3*difference] , :size =>12
	for j  in 1..3
		pdf.draw_text " : ", :at => [430, line_no1-j*difference] 
	end
	pdf.draw_text " #{@registration.reg_date.strftime("%d-%m-%Y")	}", :at => [450, line_no1-1*difference]
	pdf.draw_text " #{@registration.age} ", :at => [450, line_no1-2*difference]
	pdf.draw_text " #{@registration.gender} ", :at => [450, line_no1-3*difference]
	
	pdf.line [-5,625], [565,625]
	if(@store_test_result.service_name.length>30)
		pdf.draw_text "#{@store_test_result.service_name}", :at => [250, 600+5] , :size =>16	
	else
		pdf.draw_text "#{@store_test_result.service_name}", :at => [230, 600+5] , :size =>16	
	end
	pdf.line [-5,600], [555,600]
	pdf.move_down(180)
	if(@store_test_result.service_name=="CYTOLOGY" ||@store_test_result.service_name=="BIOPSY" || @store_test_result.service_name=="FINE NEDDLE ASPIRATION FOR CYTOLOGY(FNAC)")
		i=1
		for store_test_result_child in @store_test_result_child 
			if(store_test_result_child.test_name.length>20)
				pdf.text "<b>#{store_test_result_child.test_name}</b>         #{store_test_result_child.result} ",:inline_format => true
			elsif(store_test_result_child.test_name.length>10)
				pdf.text "<b>#{store_test_result_child.test_name}</b>                       #{store_test_result_child.result} ",:inline_format => true
			else
				pdf.text "#{store_test_result_child.test_name}                                 #{store_test_result_child.result} ",:inline_format => true
			end
			pdf.move_down(40);
			i=i+3
		end	
		if(@store_test_result.service_name=="FINE NEDDLE ASPIRATION FOR CYTOLOGY(FNAC)")
			pdf.move_down(70);
			pdf.text "<b>FNAC has its limitations,please correlate clinically,discuss if necessary</b>",:inline_format => true, :size => 10
		elsif(@store_test_result.service_name=="BIOPSY")
			pdf.move_down(90);
			pdf.text "Plese correlate clinically,discuss if necessary",:inline_format => true, :size => 10
			pdf.text "Remaining specimen & Paraffin block will be discared after One Month.",:inline_format => true, :size => 10
		end
	else
		pdf.draw_text "Parameter", :at => [40, line_no+20] , :size =>14
		pdf.draw_text "Result", :at => [250, line_no+20] , :size =>14
		pdf.draw_text "Normal Range", :at => [380, line_no+20] , :size =>14
		i=1
		for store_test_result_child in @store_test_result_child 
			pdf.draw_text "#{store_test_result_child.test_name}", :at => [40, line_no-i*difference] , :size =>12
			results=store_test_result_child.result.split(",")
			pdf.draw_text " : ", :at => [230, line_no-i*difference]
			for k in 0...results.length
				i=i+k
				pdf.draw_text "#{results[k]} ", :at => [250, line_no-i*difference] , :size =>12
				if(store_test_result_child.lbound!="") 						
					pdf.draw_text "#{store_test_result_child.lbound} #{store_test_result_child.units} ", :at => [420, line_no-i*difference] , :size =>12
				end
			end
			i=i+1
		end	
	end	
	pdf.draw_text "Pathologist", :at => [360, line_no-22*difference], :size =>14
end
