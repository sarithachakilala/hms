
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


pdf.move_down(5)

pdf.move_down(10)	
pdf.font_size=10
pdf.stroke do
line_no=555
line_no1=700

	line_end=550
	difference=25

	pdf.draw_text "   Bill No", :at => [10, line_no1-1*difference] , :size =>10
	pdf.draw_text "   Patient Name", :at => [10, line_no1-2*difference] , :size =>10
	pdf.draw_text "   Refered By", :at => [10, line_no1-3*difference] , :size =>10
	for i  in 1..3
		pdf.draw_text " : ", :at => [100, line_no1-i*difference] 
	end
	
	pdf.draw_text " #{@testbooking.bill_no}", :at => [110, line_no1-1*difference]
	pdf.draw_text "  #{@registration.title+"."+@registration.patient_name}", :at => [110, line_no1-2*difference]
	pdf.draw_text " #{@testbooking.refferal_doctor} ", :at => [110, line_no1-3*difference]
	
	
	pdf.draw_text "   Date", :at => [370, line_no1-1*difference] , :size =>10
	pdf.draw_text "   Age", :at => [370, line_no1-2*difference] , :size =>10
	pdf.draw_text "   Sex", :at => [370, line_no1-3*difference] , :size =>10
	for j  in 1..3
		pdf.draw_text " : ", :at => [430, line_no1-j*difference] 
	end
	pdf.draw_text " #{@registration.created_at.strftime("%d-%m-%Y")}", :at => [450, line_no1-1*difference]
	pdf.draw_text " #{@registration.age} ", :at => [450, line_no1-2*difference]
	pdf.draw_text " #{@registration.gender} ", :at => [450, line_no1-3*difference]
	
	pdf.line [-5,620], [555,620]
	if(@store_test_result.service_name.length>30)
		pdf.draw_text "#{@store_test_result.service_name}", :at => [50, 600+5] , :size =>14	
	else
		pdf.draw_text "                                             #{@store_test_result.service_name}", :at => [30, 600+5] , :size =>14	
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
				pdf.text "<b>#{store_test_result_child.test_name}</b>                                 #{store_test_result_child.result} ",:inline_format => true
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
	else(@store_test_result.service_name=="HAEMOGRAMME")
		pdf.font_size=9
		pdf.draw_text "Parameter", :at => [40, line_no+28] 
		pdf.draw_text "Result", :at => [250, line_no+28] 
		pdf.draw_text "Normal Range", :at => [380, line_no+28]
		i=0
		for store_test_result_child in @store_test_result_child
			if(store_test_result_child.test_name=="Blood Picture" || store_test_result_child.test_name=="Haemoparasites" || store_test_result_child.test_name=="Impression")
				pdf.draw_text "#{store_test_result_child.test_name}", :at => [40, line_no-i*difference] 
				
				results=store_test_result_child.result.split(",")
				pdf.draw_text " : ", :at => [230, line_no-i*difference]
				for k in 0...results.length
					i=i+k
					pdf.text_box "#{results[k]} ", :at => [250, 562-i*difference],  :width => 300
					
				end
				i=i+2
			else
				pdf.draw_text "#{store_test_result_child.test_name}", :at => [40, line_no-i*difference] 
				results=store_test_result_child.result.split(",")
				pdf.draw_text " : ", :at => [230, line_no-i*difference]
				for k in 0...results.length
					i=i+k
					pdf.draw_text "#{results[k]}  #{store_test_result_child.units}", :at => [250, line_no-i*difference] 
					if(store_test_result_child.lbound!="") 						
						pdf.draw_text "#{store_test_result_child.lbound} #{store_test_result_child.units}", :at => [380, line_no-i*difference]
					end
				end
				i=i+1
			end
			
		end
		s=0
		for s in 0...@store_test_result_child.length
		if(@store_test_result_child[s].field_type=="Sub-Heading" && @store_test_result_child[s].code=="Total WBC Count" )
		pdf.draw_text "Total WBC Count",:at => [20, 570], :style=>:bold
		elsif(@store_test_result_child[s].field_type=="Sub-Heading" && @store_test_result_child[s].code=="Differential Count" )
		pdf.draw_text "Differential Count",:at => [20, 543], :style=>:bold
		elsif(@store_test_result_child[s].field_type=="Sub-Heading" && @store_test_result_child[s].code=="Blood Picture" )
		pdf.draw_text "Blood Picture",:at => [20, 140], :style=>:bold
		end
		end
	end	
	pdf.draw_text "Pathologist", :at => [440, line_no-23*difference], :size =>10, :style=>:bold
end
