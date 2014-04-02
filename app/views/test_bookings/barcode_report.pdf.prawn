
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
if(@no_of_copies)
	al=96
	h=760
	z=0
	move=13
	i=@no_of_copies.to_i
	for j in 1..i

		pdf.rounded_rectangle [0, 810], 580, 420, 10
		prawn_logo = "public/images/barcodeimages/#{@test_booking.lab_no}.png"
		pdf.image prawn_logo, :width => 200, :height => 30, :position => :left
		pdf.draw_text "#{@test_booking.barcode_id}", :at => [96, h-(j-1)*40], :size =>11, :position => :left
		pdf.move_down(move-j)
	end

end
