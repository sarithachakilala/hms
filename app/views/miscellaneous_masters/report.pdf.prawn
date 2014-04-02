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
pdf.rounded_rectangle [-4, 810], 585, 420, 10
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
line_no=680
	k=-1
	difference=20
	
	pdf.line [0,735], [580,735]
	
	pdf.move_down(7)

	pdf.text "<b>Payment Voucher</b>", :align => :center, :inline_format => true

	pdf.draw_text "   No", :at => [0, line_no-k*difference], :size =>10
	
	pdf.line [30,line_no-k*difference], [380,line_no-k*difference]
	
	pdf.draw_text "   Date", :at => [400, line_no-k*difference] , :size =>10
	pdf.draw_text "#{@miscellaneous_master.date.strftime("%d-%m-%Y")}", :at => [440, line_no-(k*difference-3)] , :size =>10
	pdf.line [430,line_no-k*difference], [530,line_no-k*difference]
	
	pdf.draw_text "   DEBIT A/C", :at => [0, line_no-(k+1)*difference] , :size =>10
	
	pdf.line [60,line_no-(k+1)*difference], [530,line_no-(k+1)*difference]
	
	pdf.draw_text "   PAID TO", :at => [0, line_no-(k+2)*difference] , :size =>10
	pdf.draw_text "#{@miscellaneous_master.miscellaneous_child[0].service}", :at => [70, line_no-((k+2)*difference-3)] , :size =>10
	pdf.line [60,line_no-(k+2)*difference], [530,line_no-(k+2)*difference]
	
	pdf.draw_text "   TOWARDS", :at => [0, line_no-(k+3)*difference], :size =>10
	pdf.draw_text "#{@miscellaneous_master.reason}", :at => [70, line_no-((k+3)*difference-3)] , :size =>10
	pdf.line [60,line_no-(k+3)*difference], [530,line_no-(k+3)*difference]
	
	pdf.draw_text "   RUPEES", :at => [0, line_no-(k+4)*difference], :size =>10
	pdf.draw_text "#{@to_watds.capitalize}rupees only.", :at => [70, line_no-((k+4)*difference-3)] , :size =>10
	pdf.line [60,line_no-(k+4)*difference], [530,line_no-(k+4)*difference]
	
	pdf.rounded_rectangle [29, 595], 100, 20, 10
	pdf.draw_text "   RS", :at => [30, line_no-(k+6)*difference], :size =>10
	pdf.draw_text "  #{number_with_precision(@miscellaneous_master.total_amount, :precision => 2,:separator=>".")}", :at => [60, line_no-((k+6)*difference-3)], :size =>10
	pdf.line [55,line_no-(k+6)*difference], [113,line_no-(k+6)*difference]

	
	pdf.draw_text "Authorised Signature", :at => [400, line_no-(k+6)*difference], :size =>10
	
	
	
	
end