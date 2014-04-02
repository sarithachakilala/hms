page_no=0
total=0
i=0
k=1
for sales in @store_child
pdf.stroke do
if(page_no==0)
pdf.font('Times-Roman')
pdf.rounded_rectangle [0, 810], 580, 50, 10
pdf.draw_text "#{@goods.vendor_code}", :at => [100, 790], :size =>17
pdf.draw_text "D.L  : #{@vm.agency_dl_no}", :at => [410, 785], :size =>13
pdf.draw_text "Tin  : #{@vm.agency_tin_no}", :at => [410, 767], :size =>13
pdf.line [380,810], [380,760]
pdf.move_down(5)

	if(@goods.invoice_date)
		@date=@goods.invoice_date.strftime("%d-%m-%Y")
	else
		@date=@goods.invoice_date
	end
	line_no=755
	difference=20
	pdf.rounded_rectangle [0, 755], 580, 780, 10
	pdf.move_down(15)
	
	 pdf.draw_text "Name", :at => [15, line_no-1*difference], :size =>10
	 pdf.draw_text "Date", :at => [380, line_no-1*difference], :size =>10
	 pdf.draw_text "Invoice No", :at => [380, line_no-2*difference], :size =>10
	for ij  in 1..1
		pdf.draw_text " : ", :at => [50, line_no-ij*difference] 
	end
	for ij  in 1..2
		pdf.draw_text " : ", :at => [430, line_no-ij*difference] 
	end
	 pdf.draw_text "Stanadard App Medieaz", :at => [60, line_no-1*difference], :size =>10,:font => 'Algerian'
	 pdf.draw_text "D.L NO    : 559/RR/AP/2009/w ,", :at => [15, line_no-2*difference], :size =>9
	 pdf.draw_text "TIN NO : 28594229116", :at => [135, line_no-2*difference], :size =>9
	 pdf.draw_text "#{@date}", :at => [450, line_no-1*difference], :size =>10
	 pdf.draw_text "", :at => [100, line_no-2*difference], :size =>10
	 pdf.draw_text "#{@goods.invoice_number}", :at => [450, line_no-2*difference], :size =>10
	data_line=100	
	pdf.move_down(50)
	line_start=2*difference
	line_start1=46
	end_line=500
	line_no1=738
	pdf.line [0,line_start1+662], [580,line_start1+662]
	pdf.line [0,line_start1+680], [0,data_line]
	pdf.line [40,line_start1+662], [40,data_line]
	pdf.line [145,line_start1+662], [145,data_line]
	pdf.line [185,line_start1+662], [185,data_line]
	pdf.line [245,line_start1+662], [245,data_line]
	pdf.line [295,line_start1+662], [295,data_line]
	pdf.line [355,line_start1+662], [355,data_line]
	pdf.line [390,line_start1+662], [390,data_line]
	pdf.line [435,line_start1+662], [435,data_line]
	pdf.line [495,line_start1+662], [495,data_line]
	pdf.line [545,line_start1+662], [545,data_line]
	

	pdf.draw_text "S.No", :at => [8, line_no-3*difference], :size =>9
	pdf.draw_text "Product Name", :at => [50, line_no-3*difference], :size =>9
	pdf.draw_text "Pack", :at => [155, line_no-3*difference], :size =>9
	pdf.draw_text "MFG", :at => [200, line_no-3*difference], :size =>9
	pdf.draw_text "Batch No", :at => [250, line_no-3*difference], :size =>9
	pdf.draw_text "Exp.Dt.", :at => [310, line_no-3*difference], :size =>9
	pdf.draw_text "Qty", :at => [360, line_no-3*difference], :size =>9
	pdf.draw_text "MRP(Rs)", :at => [395, line_no-3*difference], :size =>9
	pdf.draw_text "Pur.Rate(Rs)", :at => [440, line_no-3*difference], :size =>9
	pdf.draw_text "Amount(Rs)", :at => [500, line_no-3*difference], :size =>9
	pdf.draw_text "Vat(%)", :at => [550, line_no-3*difference], :size =>9
	pdf.line [0,line_no-2*35], [580,line_no-2*35]
	
	pdf.line [60,150-2*35], [580,150-2*35]
	pdf.line [60,100], [60,25]
	
	pdf.line [0,data_line], [580,data_line]
	page_no=page_no+1
end	

		if(i<55)
		pdf.draw_text "#{k}", :at => [15,670-10*i], :size =>9
		pdf.draw_text "#{sales.item_name}", :at => [50,670-10*i], :size =>9
		pdf.draw_text "#{sales.packing}", :at => [155,670-10*i], :size =>9
		pdf.draw_text "#{sales.mfr}", :at => [200,670-10*i], :size =>9
		pdf.draw_text "#{sales.batch_no}", :at => [250,670-10*i], :size =>9
		if(sales.expiry_date)
			pdf.draw_text "#{sales.expiry_date.strftime('%m/%Y')}", :at => [310,670-10*i], :size =>9
		end
		pdf.draw_text "#{sales.quantity}", :at => [360,670-10*i], :size =>9
		sale_rate=sales.mrp.to_s.split(".")
		if(sale_rate[0].length==1)
			pdf.draw_text "#{number_with_precision(sales.mrp, :precision => 2)}", :at => [405,670-10*i], :size =>9
		elsif(sale_rate[0].length==2)
			pdf.draw_text "#{number_with_precision(sales.mrp, :precision => 2)}", :at => [400,670-10*i], :size =>9
		else
			pdf.draw_text "#{number_with_precision(sales.mrp, :precision => 2)}", :at => [395,670-10*i], :size =>9
		end
		sale_rate=sales.purchase_rate.to_s.split(".")
		if(sale_rate[0].length==1)
			pdf.draw_text "#{number_with_precision(sales.purchase_rate, :precision => 2)}", :at => [450,670-10*i], :size =>9
		elsif(sale_rate[0].length==2)
			pdf.draw_text "#{number_with_precision(sales.purchase_rate, :precision => 2)}", :at => [445,670-10*i], :size =>9
		else
			pdf.draw_text "#{number_with_precision(sales.purchase_rate, :precision => 2)}", :at => [440,670-10*i], :size =>9
		end
		
		sale_rate=sales.amount.to_s.split(".")
		if(sale_rate[0].length==1)
			pdf.draw_text "#{number_with_precision(sales.amount, :precision => 2)}", :at => [515,670-10*i], :size =>9
		elsif(sale_rate[0].length==2)
			pdf.draw_text "#{number_with_precision(sales.amount, :precision => 2)}", :at => [510,670-10*i], :size =>9
		elsif(sale_rate[0].length==3)
			pdf.draw_text "#{number_with_precision(sales.amount, :precision => 2)}", :at => [505,670-10*i], :size =>9	
		else
			pdf.draw_text "#{number_with_precision(sales.amount, :precision => 2)}", :at => [500,670-10*i], :size =>9
		end
		pdf.draw_text "#{sales.vat}", :at => [560,670-10*i], :size =>9
		i=i+1
		total=sales.amount+total
		end
		if(i==55)
			pdf.draw_text "No. of Items :  #{i}", :at =>[10,20], :size =>9
			pdf.draw_text "Total Amount  :", :at =>[405,60], :size =>12
			pdf.draw_text " #{number_with_precision(total, :precision => 2)}",:at =>[500,60], :size =>9
			pdf.draw_text "Signature", :at =>[490,20], :size =>9
			
			
			page_no=0
			i=0
			pdf.start_new_page
		end
		k=k+1
end
end
pdf.draw_text "Sub Total  ", :at =>[70,85], :size =>9
pdf.draw_text "Discount  ", :at =>[160,85], :size =>9
pdf.draw_text "Taxable  ", :at =>[250,85], :size =>9
pdf.draw_text "VAT Rs  ", :at =>[320,85], :size =>9
pdf.draw_text "Total Amount", :at =>[400,85], :size =>9

pdf.draw_text "No. of Items :  #{k-1}", :at =>[10,1], :size =>9

			pdf.draw_text "VAT 5%  ", :at =>[5,70], :size =>9
			pdf.draw_text "VAT 14.5%  ", :at =>[5,55], :size =>9
			pdf.draw_text "VAT 0%  ", :at =>[5,40], :size =>9
			pdf.draw_text "TOTAL  ", :at =>[5,25], :size =>9
			
			pdf.draw_text " #{number_with_precision(@goods.five_value, :precision => 2)}", :at =>[80,70], :size =>9
			if(@goods.fourt_value.to_s.length==3) 
				pdf.draw_text " #{number_with_precision(@goods.fourt_value, :precision => 2)}", :at =>[95,55], :size =>9
			elsif(@goods.fourt_value.to_s.length==4) 	
				pdf.draw_text " #{number_with_precision(@goods.fourt_value, :precision => 2)}", :at =>[90,55], :size =>9
			elsif(@goods.fourt_value.to_s.length==5)
				pdf.draw_text " #{number_with_precision(@goods.fourt_value, :precision => 2)}", :at =>[85,55], :size =>9
			end	
			
			if(@goods.zero_pre.to_s.length==3) 
				pdf.draw_text " #{number_with_precision(@goods.zero_pre, :precision => 2)}", :at =>[95,40], :size =>9
			elsif(@goods.zero_pre.to_s.length==4) 	
				pdf.draw_text " #{number_with_precision(@goods.zero_pre, :precision => 2)}", :at =>[90,40], :size =>9
			elsif(@goods.zero_pre.to_s.length==5)
				pdf.draw_text " #{number_with_precision(@goods.zero_pre, :precision => 2)}", :at =>[85,40], :size =>9
			end
			pdf.draw_text " #{number_with_precision((@goods.zero_pre)+(@goods.five_value)+(@goods.fourt_value), :precision => 2)}", :at =>[80,25], :size =>9
			
			if(@goods.five_discount_per.to_s.length==3)
				pdf.draw_text " #{number_with_precision(@goods.five_discount_per, :precision => 2)}", :at =>[180,70], :size =>9
			elsif(@goods.five_discount_per.to_s.length==4) 	
				pdf.draw_text " #{number_with_precision(@goods.five_discount_per, :precision => 2)}", :at =>[175,70], :size =>9
			elsif(@goods.five_discount_per.to_s.length==5)
				pdf.draw_text " #{number_with_precision(@goods.five_discount_per, :precision => 2)}", :at =>[170,70], :size =>9
			end
			
			if(@goods.fourt_dic_per.to_s.length==3)
				pdf.draw_text " #{number_with_precision(@goods.fourt_dic_per, :precision => 2)}", :at =>[180,55], :size =>9
			elsif(@goods.fourt_dic_per.to_s.length==4)
				pdf.draw_text " #{number_with_precision(@goods.fourt_dic_per, :precision => 2)}", :at =>[175,55], :size =>9
			elsif(@goods.fourt_dic_per.to_s.length==5)			
				pdf.draw_text " #{number_with_precision(@goods.fourt_dic_per, :precision => 2)}", :at =>[170,55], :size =>9
			end
			
			if(@goods.zero_pre_dic.to_s.length==3)
				pdf.draw_text " #{number_with_precision(@goods.zero_pre_dic, :precision => 2)}", :at =>[180,40], :size =>9
			elsif(@goods.zero_pre_dic.to_s.length==4)
				pdf.draw_text " #{number_with_precision(@goods.zero_pre_dic, :precision => 2)}", :at =>[175,40], :size =>9
			elsif(@goods.zero_pre_dic.to_s.length==5)			
				pdf.draw_text " #{number_with_precision(@goods.zero_pre_dic, :precision => 2)}", :at =>[170,40], :size =>9
			end
			pdf.draw_text " #{number_with_precision((@goods.zero_pre_dic)+(@goods.five_discount_per)+(@goods.fourt_dic_per), :precision => 2)}", :at =>[170,25], :size =>9
			
			if(@goods.after_five_dic.to_s.length==3)
				pdf.draw_text " #{number_with_precision(@goods.after_five_dic, :precision => 2)}", :at =>[260,70], :size =>9
			elsif(@goods.after_five_dic.to_s.length==4)		
				pdf.draw_text " #{number_with_precision(@goods.after_five_dic, :precision => 2)}", :at =>[255,70], :size =>9
			elsif(@goods.after_five_dic.to_s.length==5)
				pdf.draw_text " #{number_with_precision(@goods.after_five_dic, :precision => 2)}", :at =>[250,70], :size =>9
			end
			
			if(@goods.after_fourt_dic.to_s.length==3)
				pdf.draw_text " #{number_with_precision(@goods.after_fourt_dic, :precision => 2)}", :at =>[260,55], :size =>9
			elsif(@goods.after_fourt_dic.to_s.length==4)
				pdf.draw_text " #{number_with_precision(@goods.after_fourt_dic, :precision => 2)}", :at =>[255,55], :size =>9
			elsif(@goods.after_fourt_dic.to_s.length==5)
				pdf.draw_text " #{number_with_precision(@goods.after_fourt_dic, :precision => 2)}", :at =>[250,55], :size =>9
			end
			
			if(@goods.after_zero_dic.to_s.length==3)
				pdf.draw_text " #{number_with_precision(@goods.after_zero_dic, :precision => 2)}", :at =>[260,40], :size =>9
			elsif(@goods.after_zero_dic.to_s.length==4)
				pdf.draw_text " #{number_with_precision(@goods.after_zero_dic, :precision => 2)}", :at =>[255,40], :size =>9
			elsif(@goods.after_zero_dic.to_s.length==5)
				pdf.draw_text " #{number_with_precision(@goods.after_zero_dic, :precision => 2)}", :at =>[250,40], :size =>9
			end
			pdf.draw_text " #{number_with_precision((@goods.after_zero_dic)+(@goods.after_fourt_dic)+(@goods.after_five_dic), :precision => 2)}", :at =>[250,25], :size =>9
			
			if(@goods.five_vat.to_s.length==3)
				pdf.draw_text " #{number_with_precision(@goods.five_vat, :precision => 2)}", :at =>[330,55], :size =>9
			elsif(@goods.five_vat.to_s.length==4)
				pdf.draw_text " #{number_with_precision(@goods.five_vat, :precision => 2)}", :at =>[325,55], :size =>9
			elsif(@goods.five_vat.to_s.length==5)
				pdf.draw_text " #{number_with_precision(@goods.five_vat, :precision => 2)}", :at =>[320,55], :size =>9
			end
			
			if(@goods.fourt_vat.to_s.length==3)
				pdf.draw_text " #{number_with_precision(@goods.fourt_vat, :precision => 2)}", :at =>[330,40], :size =>9
			elsif(@goods.fourt_vat.to_s.length==4)
				pdf.draw_text " #{number_with_precision(@goods.fourt_vat, :precision => 2)}", :at =>[325,40], :size =>9
			elsif(@goods.fourt_vat.to_s.length==5)
				pdf.draw_text " #{number_with_precision(@goods.fourt_vat, :precision => 2)}", :at =>[320,40], :size =>9
			end
			
			
			pdf.draw_text " #{number_with_precision((@goods.five_vat)+(@goods.fourt_vat), :precision => 2)}", :at =>[320,25], :size =>9
			
			pdf.draw_text " #{number_with_precision(@goods.total_amount, :precision => 2)}",:at =>[400,25], :size =>9
			pdf.draw_text "Signature", :at =>[490,1], :size =>9
			