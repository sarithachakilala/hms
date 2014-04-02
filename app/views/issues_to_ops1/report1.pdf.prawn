pdf.rounded_rectangle [0, 810], 580, 53, 10
home=Home.last
if(home)
	prawn_logo = "public/images/#{home.image_path}"
else
	prawn_logo = "public/images/hs-gol.png"
end

@org=OrgMasterChildTable.last
if(@org)
	address=@org.address.split(";")
	for i in 0...address.length-1
		if(i==0)
			pdf.text "<b>#{address[i]}</b>", :align => :center, :inline_format => true
		else
			pdf.text "#{address[i]}", :align => :center, :inline_format => true
		end	
	end	
end

pdf.image prawn_logo, :at => [10, 790],:width => 170, :height => 30			

 pdf.draw_text "PHARMACY BILL", :at => [210, 740], :style => :bold

pdf.line [430,810], [430,757]
pdf.move_down(5)
pdf.stroke do
	line_no=750
	line_no1=800
	difference=20
	pdf.rounded_rectangle [0, 755], 580, 375, 10
	pdf.move_down(15)
	
 pdf.draw_text "Patient Name", :at => [15, line_no-1*difference], :size =>10
	 pdf.draw_text "Doctor", :at => [15, line_no-2*difference], :size =>10
	 pdf.draw_text "Date", :at => [380, line_no-1*difference], :size =>10
	 pdf.draw_text "Bill No", :at => [380, line_no-2*difference], :size =>10
	for i  in 1..2
		pdf.draw_text " : ", :at => [80, line_no-i*difference] 
	end
	for i  in 1..2
		pdf.draw_text " : ", :at => [430, line_no-i*difference] 
	end
	 pdf.draw_text "Tin.No : TN000001", :at => [445, line_no1-0.5*difference], :size =>10
	 pdf.draw_text "DL.No  : DL000001", :at => [445, line_no1-1.5*difference], :size =>10
	 
	 pdf.draw_text "#{@issues_to_op.title+"."+@issues_to_op.patient_name}", :at => [90, line_no-1*difference], :size =>10
	 pdf.draw_text "#{@issues_to_op.issue_date.strftime("%d-%m-%Y")}/#{@issues_to_op.issue_time.strftime("%I:%M%p")}", :at => [440, line_no-1*difference], :size =>10
	 pdf.draw_text "#{@issues_to_op.consultant}", :at => [90, line_no-2*difference], :size =>10
	 pdf.draw_text "#{@issues_to_op.receipt_no}", :at => [440, line_no-2*difference], :size =>10
	data_line=440	
	pdf.move_down(50)
	line_start=2*difference
	line_start1=46
	end_line=500
	line_no1=738
	pdf.line [0,line_start1+662], [580,line_start1+662]
	pdf.line [0,line_start1+680], [0,data_line]
	pdf.line [40,line_start1+662], [40,data_line]
	pdf.line [170,line_start1+662], [170,data_line]
	pdf.line [250,line_start1+662], [250,data_line]
	pdf.line [325,line_start1+662], [325,data_line]
	pdf.line [380,line_start1+662], [380,data_line]
	pdf.line [440,line_start1+662], [440,data_line]
	pdf.line [485,line_start1+662], [485,data_line]
	
pdf.draw_text "S.No", :at => [8, line_no-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Product Name", :at => [50, line_no-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Batch No", :at => [180, line_no-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Exp.Dt.", :at => [260, line_no-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Qty", :at => [335, line_no-3*difference], :size =>11, :style => :bold
	pdf.draw_text "MFR", :at => [390, line_no-3*difference], :size =>11, :style => :bold
	pdf.draw_text "MRP", :at => [460, line_no-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Amount", :at => [495, line_no-3*difference], :size =>11, :style => :bold
	pdf.line [0,line_no-2*35], [580,line_no-2*35]
		i=0
	for issues_to_op in @issue
		pdf.draw_text "#{i+1}", :at => [15,670-20*i], :size =>10
		pdf.draw_text "#{issues_to_op.item_name}", :at => [50,670-20*i], :size =>10
		pdf.draw_text "#{issues_to_op.batch_no}", :at => [190,670-20*i], :size =>10
	    pdf.draw_text "#{issues_to_op.expiry_date.strftime('%m/%Y')}", :at => [260,670-20*i], :size =>10
	    pdf.draw_text "#{issues_to_op.issue_qty}", :at => [345,670-20*i], :size =>10
	    pdf.draw_text "#{}", :at => [390,670-20*i], :size =>10
		sale_rate=issues_to_op.sale_rate.to_s.split(".")
		if(sale_rate[0].length==1)
			pdf.draw_text "#{number_with_precision(issues_to_op.sale_rate, :precision => 2)}", :at => [460,670-20*i], :size =>10
		elsif(sale_rate[0].length==2)
			pdf.draw_text "#{number_with_precision(issues_to_op.sale_rate, :precision => 2)}", :at => [455,670-20*i], :size =>10
		else
			pdf.draw_text "#{number_with_precision(issues_to_op.sale_rate, :precision => 2)}", :at => [450,670-20*i], :size =>10
		end
		amount=issues_to_op.total.to_s.split(".")
		if(amount[0].length==1)
			pdf.draw_text "#{number_with_precision(issues_to_op.total, :precision => 2)}", :at => [510,670-20*i], :size =>10
		elsif(amount[0].length==2)
			pdf.draw_text "#{number_with_precision(issues_to_op.total, :precision => 2)}", :at => [505,670-20*i], :size =>10
		else	
			pdf.draw_text "#{number_with_precision(issues_to_op.total, :precision => 2)}", :at => [500,670-20*i], :size =>10
		end	
		i=i+1
	end
	if(i>8)
		pdf.move_down(180+(i-8)*20)
		data_line=480-(i-8)*20
	else
		pdf.move_down(180)
	end
	pdf.draw_text "No. of Items :  #{i}", :at =>[10,data_line-20], :size =>10
	pdf.draw_text "Discount :   #{number_with_precision(@discount, :precision => 2)}", :at =>[200,data_line-20], :size =>10
	pdf.draw_text "Total  :  #{number_with_precision(@issues_to_op.paid_amt, :precision => 2)}", :at =>[470,data_line-20], :size =>10, :style => :bold
	pdf.draw_text "Signature", :at =>[490,390], :size =>10
	
	pdf.line [0,data_line], [580,data_line]
	
if(@print_type=="duplicate")
	pdf.draw_text "(Duplicate)", :at => [500, 740] , :size =>10, :style=>:bold
	else
	pdf.draw_text "(Original)", :at => [500, 740] , :size =>10, :style=>:bold
	end
	end

