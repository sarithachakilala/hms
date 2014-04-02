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
pdf.rounded_rectangle [-4, 810], 585, 820, 10
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
	line_no=720
pdf.line [0,730], [590,730]

pdf.draw_text "TIN NO: 28849283616      		     		     		     				DL 20,41                               DL 21.41 ", :at => [2,715], :size =>11, :style => :bold


	difference=20

	pdf.move_down(35)
	 pdf.draw_text "Bill No", :at => [15, line_no-1*difference], :size =>11, :style => :bold
	 pdf.draw_text "Patient Name", :at => [15, line_no-2*difference], :size =>11, :style => :bold
	 pdf.draw_text "Doctor Name", :at => [380, line_no-1*difference], :size =>11, :style => :bold
	 pdf.draw_text "Date", :at => [380, line_no-2*difference], :size =>11, :style => :bold
	for i  in 1..2
		pdf.draw_text " : ", :at => [70, line_no-i*difference] 
	end
	
		pdf.draw_text " : ", :at => [420, line_no-1*difference] 

	 pdf.draw_text "#{@issues_to_op.receipt_no}", :at => [90, line_no-1*difference], :size =>11, :style => :bold
	 pdf.draw_text "#{@issues_to_op.patient_name}", :at => [90, line_no-2*difference], :size =>11, :style => :bold
	 pdf.draw_text "#{@issues_to_op.consultant}", :at => [90, line_no-3*difference], :size =>11, :style => :bold
	 pdf.draw_text "#{@issues_to_op.issue_date}", :at => [440, line_no-1*difference], :size =>11, :style => :bold
	data_line=600	
	pdf.move_down(50)
	line_start=2*difference
	line_start1=35
	end_line=480
	
	line_no1=720
	pdf.draw_text "S.No", :at => [8, line_no1-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Medicine Name", :at => [50, line_no1-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Qty", :at => [180, line_no1-3*difference], :size =>11, :style => :bold
	pdf.draw_text "B.No.", :at => [230, line_no1-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Exp Date", :at => [270, line_no1-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Rate", :at => [345, line_no1-3*difference], :size =>11, :style => :bold
	pdf.draw_text "VAT %", :at => [400, line_no1-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Discount ", :at => [440, line_no1-3*difference], :size =>11, :style => :bold
	pdf.draw_text "Amount", :at => [495, line_no1-3*difference], :size =>11, :style => :bold
		i=0
	for issues_to_op in @issue
		pdf.draw_text "#{i+1}", :at => [15,670-20*i], :size =>11, :style => :bold
		pdf.draw_text "#{issues_to_op.item_name}", :at => [50,670-20*i], :size =>11, :style => :bold
		pdf.draw_text "#{issues_to_op.issue_qty}", :at => [190,670-20*i], :size =>11, :style => :bold
	    pdf.draw_text "#{issues_to_op.batch_no}", :at => [230,670-20*i], :size =>11, :style => :bold
	    pdf.draw_text "#{issues_to_op.expiry_date.strftime("%b/%Y")}", :at => [270,670-20*i], :size =>11, :style => :bold
		sale_rate=issues_to_op.sale_rate.to_s.split(".")
		if(sale_rate[0].length==1)
			pdf.draw_text "#{number_with_precision(issues_to_op.sale_rate, :precision => 2, :separator =>'.')}", :at => [345,670-20*i], :size =>11, :style => :bold
		elsif(sale_rate[0].length==2)
			pdf.draw_text "#{number_with_precision(issues_to_op.sale_rate, :precision => 2, :separator =>'.')}", :at => [340,670-20*i], :size =>11, :style => :bold
		else
			pdf.draw_text "#{number_with_precision(issues_to_op.sale_rate, :precision => 2, :separator =>'.')}", :at => [335,670-20*i], :size =>11, :style => :bold
		end
		 pdf.draw_text "#{number_with_precision(issues_to_op.vat, :precision => 2, :separator =>'.')}", :at => [400,670-20*i], :size =>11, :style => :bold
		 pdf.draw_text "#{number_with_precision(issues_to_op.discount, :precision => 2, :separator =>'.')}", :at => [440,670-20*i], :size =>11, :style => :bold
		 
		amount=issues_to_op.total.to_s.split(".")
		if(amount[0].length==1)
			pdf.draw_text "#{number_with_precision(issues_to_op.total, :precision => 2, :separator =>'.')}", :at => [510,670-20*i], :size =>11, :style => :bold
		elsif(amount[0].length==2)
			pdf.draw_text "#{number_with_precision(issues_to_op.total, :precision => 2, :separator =>'.')}", :at => [505,670-20*i], :size =>11, :style => :bold
		else	
			pdf.draw_text "#{number_with_precision(issues_to_op.total, :precision => 2, :separator =>'.')}", :at => [500,670-20*i], :size =>11, :style => :bold
		end	
		i=i+1
	end
	if(i>8)
		pdf.move_down(180+(i-8)*20)
		data_line=480-(i-8)*10
	else
		pdf.move_down(10)
	end
	pdf.draw_text "No. of Items :  #{i}", :at =>[10,data_line-24], :size =>11, :style => :bold
	pdf.draw_text "Grand Total  :  #{number_with_precision(@issues_to_op.paid_amt, :precision => 2, :separator =>'.' , :iso_code => "INR",  :html_entity => "&#x20A8;",:locale => 'en-IN', :inr => { :priority => 100, :iso_code => "INR", :name => "Indian Rupee", :symbol => "?",             :subunit => "Paisa",         :subunit_to_unit => 100,  :symbol_first => true, :html_entity => "&#x20A8;", :decimal_mark => ".", :thousands_separator => ","})}",  :at =>[440,data_line-24], :size =>11, :style => :bold
	pdf.draw_text "Signature", :at =>[490,data_line-50], :size =>11, :style => :bold
	pdf.draw_text "Thank You ", :at =>[10,data_line-50], :size =>11, :style => :bold
	
end
  
