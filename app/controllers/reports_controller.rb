class ReportsController < ApplicationController


def doctorwise_labrefunds

@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	
	 consultant=ConsultantMaster.all
	@consultant1=Array.new
	i=0
	for con in consultant
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		@consultant1[i]=con.consultant_id+"-"+employee.name
		i=i+1
	end
end

def ajax_buildings2
	mr1=params[:q1]
	type=params[:type]
	if(type=="lab_department")
		@tests=Testmaster.find(:all, :conditions=>" department_name LIKE '#{mr1}' ")
		str=""
		for tests in @tests
			str << tests.test_name+"<division>"
		end
		render :text=>str	
	end

end
def test_wise
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
from_date=params[:from_date]
to_date=params[:to_date]
service_name=params[:service]
lab=params[:lab_department]
if(from_date!="" && to_date!="" &&  service_name!="")
	query=["created_at BETWEEN ? AND ? AND  department like '#{lab}' and test_name  LIKE '#{service_name}%'", from_date,to_date]
elsif(from_date!="" && to_date!="" )
	query=["created_at  BETWEEN ? AND ? ", from_date,to_date]
end
test_booking_children=TestBookingChild.find(:all, :conditions => query )
require 'rubygems'
  	 require 'thinreports'
  	 ThinReports::Report.generate_file('app/views/reports/readpdf.pdf') do
    use_layout 'app/views/reports/testwise.tlf'
    start_new_page do
        	 org_master_child=OrgMasterChildTable.last
 item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]     
             item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
              item(:report_name).value "Test Wise Bookings"

        	 item(:image).value prawn_logo
        	 s_no=1
        	 total=0
        	 for test_booking_child in test_booking_children
        	  	 report.page.list(:list).add_row do |row|
        	    	 row.item(:s_no).value s_no
         test_booking=TestBooking.find_by_id(test_booking_child.test_booking_id)
        	    	 row.item(:mr_no).value test_booking.mr_no
        	    	 reg=Registration.find_by_mr_no(test_booking.mr_no)
        	    	 row.item(:lab_no).value test_booking.lab_no
        	    	 row.item(:p_name).value test_booking.patient_name
        	    	 row.item(:age).value reg.age.to_s+"/"+reg.gender
        	    	 row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")+"/"+test_booking.created_at.strftime("%H:%M")
        	    	 row.item(:test_name).value test_booking_child.test_name
        	    	 
        	    	 row.item(:paid_amt).value "%05.2f" % test_booking_child.amount
end
        	  	 total=total+test_booking_child.amount
        	  	 s_no=s_no+1
        	  	 item(:count).value s_no-1 	  
 	 item(:total).value "%05.2f" % total
 	 item(:page_no).value 1
     	 end
  end
end
redirect_to("/reports/readpdf/1?format=pdf")
  end 


def group_wise
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
		from_date=params[:from_date_]
		to_date=params[:to_date_]
		lab=params[:lab_department]
		test_booking_children=TestBookingChild.find(:all, :conditions => "created_at BETWEEN '#{from_date}' AND '#{to_date}' AND  department LIKE '#{lab}%' ")
				require 'rubygems'
		  		require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/groupwise.pdf') do
				    use_layout 'app/views/reports/groupwise.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Service Group Wise Bookings"
		        		s_no=1
		        		total=0
		        		for test_booking_child in test_booking_children
		        	  		report.page.list(:list).add_row do |row|
		        	    			row.item(:s_no).value s_no
		        	    		test_booking=TestBooking.find_by_id(test_booking_child.test_booking_id)
									row.item(:mr_no).value test_booking.mr_no
		        	    		reg=Registration.find_by_mr_no(test_booking.mr_no)
		        	    			row.item(:p_name).value test_booking.patient_name
		        	    			row.item(:age).value reg.age.to_s+"/"+reg.gender
		        	    			row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")+"/"+test_booking.created_at.strftime("%H:%M")
		        	    			row.item(:test_name).value test_booking_child.department
		        	    			
		        	    			row.item(:paid_amt).value "%05.2f" % test_booking_child.amount
		        	    			total=total+test_booking_child.amount
		        	  		end
		        	    				s_no=s_no+1
					        	  		item(:count).value s_no-1 					 
					 					item(:total).value "%05.2f" % total
					 					item(:page_no).value 1
		        		end
			  end
	end
		redirect_to("/reports/groupwise/1?format=pdf")
  end

def groupwise
	send_file "app/views/reports/groupwise.pdf", :type => "application/pdf", :disposition => 'inline'
end


def doctorwise_lab
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
		from_date=params[:from_date]
		to_date=params[:to_date]
		service_name=params[:service]
		lab=params[:lab_department]

		consultant=params[:consultant]

 cons_id=params[:consultant].split("-")

		@name =EmployeeMaster.find_by_empid(consultant)
if(from_date!="" && to_date!="" && consultant!="" )
	query=["booking_date  BETWEEN ? AND ?  AND  refferal_doctor LIKE '#{cons_id[1]}' ", from_date,to_date]
elsif(from_date!="" && to_date!="" )
	query=["booking_date  BETWEEN ? AND ? ", from_date,to_date]
end
test_bookings=TestBooking.find(:all, :conditions=> query)

		require 'rubygems'
		  		require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/internal.pdf') do
				    use_layout 'app/views/reports/doctorwise_labrefunds.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Doctorwise Lab Referals"
				             	s_no=1
				             	total=0
		        		for test_booking in test_bookings
 test_booking_child1=TestBookingChild.find(:all,:conditions=>"test_booking_id LIKE '#{test_booking.id}'")
			      if(lab!="")

			  	test_booking_child1=TestBookingChild.find(:all,:conditions=>"test_booking_id LIKE '#{test_booking.id}' AND department like '#{lab}%' AND test_name LIKE '#{service_name}%'")
		        	  			
end	
		        	  			for test_booking_child in test_booking_child1
		        	  				report.page.list(:list).add_row do |row|
		        	    			row.item(:s_no).value s_no
		        					row.item(:mr_no).value test_booking.mr_no
		        	    			reg=Registration.find_by_mr_no(test_booking.mr_no)
		        	    			row.item(:p_name).value test_booking.patient_name
		        	    			row.item(:age).value reg.age.to_s+"/"+reg.gender
		        	    			row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")+"/"+test_booking.created_at.strftime("%H:%M")
		        	    			row.item(:cons).value test_booking.refferal_doctor
		        	    			row.item(:test_name).value test_booking_child.test_name
		        	   
		        	    			row.item(:paid_amt).value "%05.2f" % test_booking_child.amount
		        	    			total=total+test_booking_child.amount
		        	  		end
		        	    				s_no=s_no+1
					        	  		item(:count).value s_no-1 					 
					 					item(:total).value "%05.2f" % total
					 					item(:page_no).value 1
					 	  end
		        		end
			  end
	end
		redirect_to("/reports/internal/1?format=pdf")
 
end

def internal
		send_file "app/views/reports/internal.pdf", :type => "application/pdf", :disposition => 'inline'
end

def in_doctorwise_lab
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	from_date=params[:from_date]
		to_date=params[:to_date]
		service_name=params[:service]
		lab=params[:lab_department]
		consultant=params[:consultant]
		@name =EmployeeMaster.find_by_empid(consultant)
	

		test_booking = TestBooking.find_by_refferal_doctor(@name.name)
		test_booking_children=TestBookingChild.find(:all, :conditions => "created_at BETWEEN '#{from_date}' AND '#{to_date}'  AND  department like '#{lab}' AND test_booking_id = '#{test_booking.id}'")

		require 'rubygems'
		  		require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/internal.pdf') do
				    use_layout 'app/views/reports/doctorwise_labrefunds.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "External Doctorwise Lab Referals"
				             	s_no=1
		        		for test_booking_child in test_booking_children
		        	  		report.page.list(:list).add_row do |row|
		        	    			row.item(:s_no).value s_no
		        	    			row.item(:mr_no).value test_booking.mr_no
		        	    			reg=Registration.find_by_mr_no(test_booking.mr_no)
		        	    			row.item(:p_name).value test_booking.patient_name
		        	    			row.item(:age).value reg.age.to_s+"/"+reg.gender
		        	    			row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")+"/"+test_booking.created_at.strftime("%H:%M")
		        	    			row.item(:cons).value test_booking.refferal_doctor
		        	    			row.item(:test_name).value test_booking_child.department
		        	    			row.item(:status).value test_booking_child.status

		        	    			row.item(:paid_amt).value "%05.2f" % test_booking_child.amount

		        	  		end
		        	    			total=TestBookingChild.sum(:amount, :conditions=>" id = '#{test_booking_child.id}' ")
		        	  			s_no=s_no+1
					        	  		item(:count).value s_no-1 					 
					 					item(:total).value "%05.2f" % total
					 					item(:page_no).value 1
		        		end
			  end
	end
		redirect_to("/reports/internal/1?format=pdf")
 
end

def internal
		send_file "app/views/reports/internal.pdf", :type => "application/pdf", :disposition => 'inline'
end
def test_cancels_report
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
		from_date=params[:from_date]
		to_date=params[:to_date]
		org_code=params[:org_code]
		if(from_date!="" && to_date!="" )
			query=["created_at BETWEEN ? AND ? ", from_date,to_date]
		end
		test_cancel=TestCancel.find(:all, :conditions => query)
		
		require 'rubygems'
		  		require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/test_cancels.pdf') do
				    use_layout 'app/views/reports/test_cancels.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Test Cancels"
				            s_no=1
						  	for test_cancel in test_cancel
				        	  		report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			test_book=TestBooking.find_by_lab_no(test_cancel.lab_id)
				        	    			row.item(:mr_no).value test_book.mr_no
				        	    			row.item(:p_name).value test_book.patient_name
				        	    			row.item(:lab_no).value test_book.lab_no
		        							row.item(:test_name).value test_cancel.service_name
		        							row.item(:date).value test_cancel.created_at.strftime("%d-%m-%Y")
		        							row.item(:reason).value test_cancel.reason
		        	  		end
		        	    			s_no=s_no+1
					        	  		item(:count).value s_no-1 					 
					 					item(:page_no).value 1
		        		end
			  end
	end
		redirect_to("/reports/test_cancels/1?format=pdf")
  end

def test_cancels
		send_file "app/views/reports/test_cancels.pdf", :type => "application/pdf", :disposition => 'inline'
end
def test_bookings
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
		from_date=params[:from_date]
		to_date=params[:to_date]
		patient_type=params[:patient_type]
		if(from_date!="" && to_date!="" &&  patient_type!="")
			query=["booking_date BETWEEN ? AND ? AND  patient_type like '#{patient_type}' ", from_date,to_date]
		elsif(from_date!="" && to_date!="" )
			query=["booking_date  BETWEEN ? AND ? ", from_date,to_date]
		end
		
		patient_type=params[:patient_type]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/test_book.pdf') do
				    use_layout 'app/views/reports/test_book.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Test Bookings"
				            
				         
				        			test_bookings=TestBooking.find(:all, :conditions=> query )	
						            s_no=1
						        	  total=0
								  	for test_booking in test_bookings
								  	     for test_booking_child in test_booking.test_booking_child
						        	  		report.page.list(:list).add_row do |row|
						        	    			row.item(:s_no).value s_no
						        	    			row.item(:mr_no).value test_booking.mr_no
						        	    			row.item(:p_name).value test_booking.patient_name
						        	    					reg=Registration.find_by_mr_no(test_booking.mr_no)	
						        	    			row.item(:age).value reg.age.to_s+"/"+reg.gender
						        	    			row.item(:case).value test_booking.patient_type
													row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")+"/"+test_booking.created_at.strftime("%H:%M")
					        						row.item(:test_name).value test_booking_child.department
					        						
						        	    			row.item(:paid_amt).value "%05.2f" % test_booking_child.amount
						        	    			total=total+test_booking_child.amount
				        	  				end
				        	  				
				        	    				s_no=s_no+1
								        	  	item(:count).value s_no-1 					 
								 				item(:total).value "%05.2f" % total					 
							 					item(:page_no).value 1
							 				end	
				        			end
				        	
			 		 end
				end
		redirect_to("/reports/test_book/1?format=pdf")
end
def test_book
	send_file "app/views/reports/test_book.pdf", :type => "application/pdf", :disposition => 'inline'
end
def daily_rev
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
		from_date=params[:from_date]
		to_date=params[:to_date]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/daily.pdf') do
				    use_layout 'app/views/reports/daily_lab.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Daily Lab Revenue"
				             	s_no=1
				             	total=0
	test_bookings=TestBooking.find(:all,:conditions => "booking_date BETWEEN '#{from_date}' AND '#{to_date}' ")
						  	for test_booking in test_bookings
				        	  		report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")
		        						row.item(:paid_amt).value "%05.2f" % test_booking.grand_total
		        						total=total+test_booking.grand_total
		        	  					end
		        	    			s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 				item(:page_no).value 1
		        			end
			  end
	end
		redirect_to("/reports/daily/1?format=pdf")

end
def daily
	send_file "app/views/reports/daily.pdf", :type => "application/pdf", :disposition => 'inline'
end
def casuality_collection
end
def casuality_collect
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	from_date=params[:from_date]
		to_date=params[:to_date]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/casuality_coll.pdf') do
				    use_layout 'app/views/reports/casuality.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Daily Lab Revenue"
				             	s_no=1
				             	total=0
	casuality=Casuality.find(:all,:conditions => "	booking_date BETWEEN '#{from_date}' AND '#{to_date}' ")
						  	for test_booking in test_bookings
				        	  		report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:p_name).value casuality.p_name
				        	    			row.item(:cas_no).value casuality.casuality_no
				        	    			row.item(:age).value casuality.age
				        	    			row.item(:city).value casuality.address
		        							row.item(:paid_amt).value "%05.2f" % casuality.paid_amount
		        						total=total+casuality.paid_amount
		        	  					end
		        	    			s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1
		        			end
			  end
	end
		redirect_to("/reports/casuality_coll/1?format=pdf")

end
def casuality_coll
	send_file "app/views/reports/casuality_coll.pdf", :type => "application/pdf", :disposition => 'inline'
end

def doctorwise_surgery
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	consultant=params[:consultant]
	from_date=params[:from_date]
	to_date=params[:to_date]
	require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/doctorwise_srgry.pdf') do
				    use_layout 'app/views/reports/doctorwise_srgry.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Doctorwise Surgeries"
				             	s_no=1
				             	total=0
	operation_details=OperationDetailsForOTs.find(:all,:conditions => "	surgery_date BETWEEN '#{from_date}' AND '#{to_date}' AND consultant '#{consultant}' ")
						  	for operation_detail in operation_details
				        	  		report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:consultant).value operation_detail.consultant
				        	    			row.item(:date).value operation_detail.surgery_date.strftime("%d-%m-%Y")+"/"+operation_detail..created_at.strftime("%H:%M")
				        	    			row.item(:s_name).value operation_detail.surgery_name
				        	    			row.item(:duration).value operation_detail.surgery_duration
		        							row.item(:amount).value "%05.2f" % operation_detail.surgery_amount

		        						total=total+operation_detail.surgery_amount
		        	  					end
		        	    			s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1
		        			end
			  end
	end
		redirect_to("/reports/doctorwise_srgry/1?format=pdf")

end 
def doctorwise_srgry
	send_file "app/views/reports/doctorwise_srgry.pdf", :type => "application/pdf", :disposition => 'inline'
end

def patientwise_surgery
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	patient_name=params[:patient_name]
	from_date=params[:from_date]
	to_date=params[:to_date]
	require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/patientwise_srgry.pdf') do
				    use_layout 'app/views/reports/patientwise_srgry.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Patientwise Surgeries"
				             	s_no=1
				             	total=0
	operation_details=OperationDetailsForOTs.find(:all,:conditions => "	surgery_date BETWEEN '#{from_date}' AND '#{to_date}' AND patient_name '#{patient_name}' ")
						  	for operation_detail in operation_details
				        	  		report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:admn_no).value operation_detail.admn_no
				        	    			row.item(:p_name).value operation_detail.patient_name
				        	    			row.item(:age).value operation_detail.age+"/"+operation_detail.gender
				        	    			row.item(:ward).value operation_detail.ward
				        	    			row.item(:date).value operation_detail.surgery_date.strftime("%d-%m-%Y")+"/"+operation_detail..created_at.strftime("%H:%M")
				        	    			row.item(:s_name).value operation_detail.surgery_name
				        	    			row.item(:amount).value operation_detail.surgery_amount


		        						total=total+operation_detail.surgery_amount
		        	  					end
		        	    			s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1
		        			end
			  end
	end
		redirect_to("/reports/patientwise_srgry/1?format=pdf")

end 
def patientwise_srgry
	send_file "app/views/reports/patientwise_srgry.pdf", :type => "application/pdf", :disposition => 'inline'
end

def surgery_rev
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
		from_date=params[:from_date]
		to_date=params[:to_date]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/surgery.pdf') do
				    use_layout 'app/views/reports/srgry_revenues.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Daily Lab Revenue"
				             	s_no=1
				             	total=0
	operation_details=OperationDetailsForOTs.find(:all,:conditions => "	surgery_date BETWEEN '#{from_date}' AND '#{to_date}' ")
						  	for operation_detail in operation_details
				        	  		report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:date).value operation_detail.surgery_date
				        	    			row.item(:type).value operation_detail.surgery_type
				        	    			row.item(:datetime).value operation_detail.surgery_date.strftime("%d-%m-%Y")+"/"+operation_detail..created_at.strftime("%H:%M")
				        	    			row.item(:s_name).value operation_detail.surgery_name
				        	    			row.item(:amount).value operation_detail.surgery_amount
		        						total=total+operation_detail.surgery_amount
		        	  					end
		        	    			s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1
		        			end
			  end
	end
		redirect_to("/reports/surgery/1?format=pdf")

end
def surgery
	send_file "app/views/reports/surgery.pdf", :type => "application/pdf", :disposition => 'inline'
end
def patientwise_advances

end
def patientwise_adv
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
from_date=params[:from_date]
to_date=params[:to_date]
admn_no=params[:admn_no]
patient_name=params[:patient_name]
require 'rubygems'
  	require 'thinreports'
  	 ThinReports::Report.generate_file('app/views/reports/advances.pdf') do
    use_layout 'app/views/reports/patientwidse_advances.tlf'
    start_new_page do
        	 org_master_child=OrgMasterChildTable.last
        	
        	 item(:image).value prawn_logo
        	   	 item(:address1).value org_master_child.address.split(";")[0]
            	item(:address2).value org_master_child.address.split(";")[1]
            	item(:address3).value org_master_child.address.split(";")[2]
            	item(:address4).value org_master_child.address.split(";")[3]     
             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
             	item(:report_name).value "Patientwise Advances"

             	s_no=1
             	total=0
             	if(admn_no!="")
     advancepaymets=AdvancePayment.find(:all, :conditions =>" advance_date BETWEEN '#{from_date}' AND '#{to_date}' AND admn_no LIKE '#{admn_no}' ")
     else
 	advancepaymets=AdvancePayment.find(:all, :conditions =>" advance_date BETWEEN '#{from_date}' AND '#{to_date}'")
      end
  	for advancepaymet in advancepaymets
     admission=Admission.last(:conditions=>"admn_no LIKE '#{advancepaymet.admn_no}%' AND patient_name LIKE '#{patient_name}%'" )
if(admission)
  	 report.page.list(:list).add_row do |row|
        	    	 row.item(:s_no).value s_no
        	    	 row.item(:admn_no).value advancepaymet.admn_no
        	    	 row.item(:patient_name).value admission.patient_name
        	    	 row.item(:age).value admission.age.to_s+"/"+admission.gender
        	    	 row.item(:admn_date).value admission.admn_date.strftime("%d-%m-%Y")
        	    	 row.item(:ward).value admission.ward
        	    	
        	    	 row.item(:advance).value "%05.2f" % advancepaymet.already_paid_amount 
			total=total+advancepaymet.already_paid_amount
        	  	 end
        	  	 s_no=s_no+1
        	  	 item(:count).value s_no-1 	
        	  	 item(:total).value "%05.2f" % total	  
 	 item(:page_no).value 1
        	 end
 end
  end
end
redirect_to("/reports/advances/1?format=pdf")	
end 
def advances
send_file "app/views/reports/advances.pdf", :type => "application/pdf", :disposition => 'inline'
end


def patientwise_finalbills
end
def patientwise_final
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
		from_date=params[:from_date]
		to_date=params[:to_date]
		admn_no=params[:admn_no]
		patient_name=params[:patient_name]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/final.pdf') do
				    use_layout 'app/views/reports/patientwise_final_bills.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Patientwise Final Bills"
				
				             	s_no=1
				             	total=0
				final_bills=FinalBill.find(:all, :conditions =>" final_bill_date BETWEEN '#{from_date}' AND '#{to_date}' ")
						  	for final_bill in final_bills
								admission=Admission.last(:conditions=>"admn_no LIKE '#{final_bill.admn_no}%' AND patient_name LIKE '#{patient_name}%' " )
								if(admission)
						  			report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:admn_no).value final_bill.admn_no
				        	    			row.item(:patient_name).value admission.patient_name
				        	    			row.item(:age).value admission.age.to_s+"/"+admission.gender
				        	    			row.item(:admn_date).value admission.admn_date.strftime("%d-%m-%Y")
				        	    			row.item(:dic_date).value final_bill.final_bill_date.strftime("%d-%m-%Y")
				        	    			row.item(:ward).value admission.ward
				        	    			row.item(:final_bill).value "%05.2f" % final_bill.gross_amount	
				        	    			row.item(:paid_amount).value "%05.2f" % final_bill.paid_amount	 
				        	    			row.item(:due).value "%05.2f" % final_bill.balance_amount	 
											total=total+final_bill.paid_amount
		        	  					end
		        	  				s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1

							end
		        			end
			  end
	end
		redirect_to("/reports/final/1?format=pdf")	
end
def final
	send_file "app/views/reports/final.pdf", :type => "application/pdf", :disposition => 'inline'
end 

def patientwise_dues
end

def patientwis_due
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	from_date=params[:from_date]
		to_date=params[:to_date]
		admn_no=params[:admn_no]
		patient_name=params[:patient_name]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/due.pdf') do
				    use_layout 'app/views/reports/patientwise_dues.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Patientwise Final Bills"
				
				             	s_no=1
				             	total=0
				ipdues=FinalBill.find(:all, :conditions =>" final_bill_date BETWEEN '#{from_date}' AND '#{to_date}' AND admn_no LIKE '#{admn_no}%'")
					if(ipdues)
						
						  	for ipdue in ipdues
							due_amount=ipdue.balance_amount
					if(due_amount.to_i > 0)
								admission=Admission.last(:conditions=>"admn_no LIKE '#{ipdue.admn_no}%' AND patient_name LIKE '#{patient_name}%'" )
								if(admission)
						  			report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:admn_no).value ipdue.admn_no
				        	    			row.item(:patient_name).value admission.patient_name
				        	    			row.item(:age).value admission.age.to_s+"/"+admission.gender
				        	    			row.item(:admn_date).value admission.admn_date.strftime("%d-%m-%Y")
				
				        	    			row.item(:ward).value admission.ward
				        	    			row.item(:due).value "%05.2f" % due_amount
											total=total+due_amount
		        	  					end
		        	  				s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1
							end
		        			end
end
				end
			  end
	end
		redirect_to("/reports/due/1?format=pdf")	
end 
def due
		send_file "app/views/reports/due.pdf", :type => "application/pdf", :disposition => 'inline'
end

 def ajax_buildings
	mr1=params[:q1]
	type=params[:type]
	if(type=="package_category")
		@pm=PackageMasterMajestic.find(:all,:conditions => "category='#{mr1}'")	
		puts @pm[0].sub_category
		str=""
		for pm in @pm
			str << pm.sub_category+"<division>"
		end
		render :text=>str	
	end
end
def patientwise_pkg_advances
end 
def patientwis_pkg
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
		from_date=params[:from_date]
		to_date=params[:to_date]
		package_category=params[:package_category]
		sub_category=params[:sub_category]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/pkg_advances.pdf') do
				    use_layout 'app/views/reports/patientwise_pkg_advances.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Patientwise Package Advances"
				
				             	s_no=1
				             	total=0
	admissions=Admission.find(:all, :conditions=>"admn_date BETWEEN '#{from_date}' AND '#{to_date}' AND  package_category LIKE '#{package_category}' " )
				
						  	for admission in admissions
						  			report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:admn_no).value admission.mr_no+"/"+admission.admn_no
				        	    			row.item(:patient_name).value admission.patient_name
				        	    			row.item(:age).value admission.age.to_s+"/"+admission.gender
				        	    			row.item(:package).value admission.package_category
				        	    			row.item(:admn_date).value admission.admn_date.strftime("%d-%m-%Y")
				        	    			row.item(:ward).value admission.ward
				        	    			row.item(:advance).value "%05.2f" % admission.advance 
											total=total+admission.advance
		        	  					end
		        	  				s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1
		        			end
			  end
	end
		redirect_to("/reports/pkg_advances/1?format=pdf")	
end	
def pkg_advances
	send_file "app/views/reports/pkg_advances.pdf", :type => "application/pdf", :disposition => 'inline'
end	

def doctorwise_concession_for_tests
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	consultant=ConsultantMaster.all
	@consultant=Array.new
	i=0
	for con in consultant
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		@consultant[i]=con.consultant_id+"-"+employee.name
		i=i+1
	end
end 
def doctorwise_concession_tests
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
		from_date=params[:from_date]
		to_date=params[:to_date]
		consultant=params[:consultant]
		patient_type=params[:patient_type]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/doctorwise_concession_4tests.pdf') do
				    use_layout 'app/views/reports/doctorwise_concession_for_tests.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Doctorwise Concession For Tests"
				
				             	s_no=1
				             	total=0

	testbookings=TestBooking.find(:all, :conditions=>"booking_date BETWEEN '#{from_date}' AND '#{to_date}' AND concession_authority LIKE '#{consultant}%' AND patient_type LIKE '#{patient_type}' ")				             	
				
				
		  	for testbooking in testbookings
						  		 for test_booking_child in testbooking.test_booking_child
						  			report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:consultant).value testbooking.concession_authority
				        	    			row.item(:admn_no).value testbooking.admn_no+"/"+testbooking.mr_no
				        	    			row.item(:p_name).value testbooking.patient_name
				        	    			reg=Registration.find_by_mr_no(testbooking.mr_no)
				        	    			row.item(:age).value reg.age.to_s+"/"+reg.gender
				        	    			row.item(:case).value testbooking.patient_type
				        	    			row.item(:test_name).value test_booking_child.test_name
				        	    			row.item(:amount).value "%05.2f" % test_booking_child.amount
										total=total+test_booking_child.amount
		        	  					end
		        	  				s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1
		        				end
		        			end


			  end
	end
		redirect_to("/reports/doctorwise_concession_4tests/1?format=pdf")	
end 

def doctorwise_concession_4tests
	send_file "app/views/reports/doctorwise_concession_4tests.pdf", :type => "application/pdf", :disposition => 'inline'
end	
def wardwise_bed_status

end
 def ajax_buildings1	
	mr1=params[:q1]
	type=params[:type]
	if(type=="ward")
		@ward=WardMaster.find_by_name(mr1)
		@room=RoomMaster.find(:all, :conditions => "ward_master_id = '#{@ward.id}'") 
		puts @room[0].name
		str=""
		for room in @room
			str<< room.name+"<division>"
		end
		render :text=>str	
	end
end

def wardwise111
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
room2=params[:room]
ward2=params[:ward]
status1=params[:status]
require 'rubygems'
  	require 'thinreports'
   ThinReports::Report.generate_file('app/views/reports/wardwise_bed.pdf') do
    use_layout 'app/views/reports/wardwise_bed1.tlf'
    start_new_page do
        	 org_master_child=OrgMasterChildTable.last
        	
        	 item(:image).value prawn_logo
        	   	 item(:address1).value org_master_child.address.split(";")[0]
            	item(:address2).value org_master_child.address.split(";")[1]
            	item(:address3).value org_master_child.address.split(";")[2]
            	item(:address4).value org_master_child.address.split(";")[3]     
             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
             	item(:report_name).value "Wardwise Bed Status Report"

             	s_no=1
             	total=0
ward1=WardMaster.find_by_name(ward2)
if(ward1)
ward11=ward1.id
	room1=RoomMaster.find_by_name_and_ward_master_id(room2,ward1.id)
	if(room1)
	romm=room1.id
end

end
	if(status1=="All")
	admissions=BedMaster.find(:all, :conditions=>" ward_master_id LIKE '#{ward11}' AND room_master_id LIKE '#{romm}'")	              	            	

	else
	admissions=BedMaster.find(:all, :conditions=>" status LIKE '#{status1}%' AND  ward_master_id LIKE '#{ward1.id}' AND room_master_id LIKE '#{romm}'")	              	
	end


    	for admission in admissions
  	               	report.page.list(:list).add_row do |row|
        	    	 row.item(:s_no).value s_no
        	    	 row.item(:ward).value ward2
        	    	 row.item(:room).value room2
        	    	 row.item(:bed).value admission.name
        	    	 row.item(:status).value admission.status
        	    end
        	  	 s_no=s_no+1
        	  	 item(:count).value s_no-1 	
        	  	 item(:page_no).value 1
        	
        	 end


  end
end
redirect_to("/reports/wardwise_bed/1?format=pdf")	
end 
def wardwise_bed

      send_file "app/views/reports/wardwise_bed.pdf", :type => "application/pdf", :disposition => 'inline'
    end

	
#saritha..........
	def doctor_wise_admission
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	consultant=ConsultantMaster.all
	@consultant=Array.new
	i=0
	for con in consultant
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		@consultant[i]=con.consultant_id+"-"+employee.name
		i=i+1
	end

end

def doctor_wise_admission_report
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	@from_date=params[:from_date]
	@to_date=params[:to_date]
	status=params[:status]
	consultant=ConsultantMaster.find_by_consultant_id(params[:consultant])
	employee=EmployeeMaster.find_by_empid(params[:consultant])
cons_id=params[:consultant].split("-")
name1=params[:consultant]

if(status=="Admitted")
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{cons_id[0]}%'AND admn_status LIKE '#{params[:status]}%'")
    elsif(status=="Discharged")
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{cons_id[0]}%'AND admn_status LIKE '#{params[:status]}%'")

	else
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' and consultant_id LIKE '#{cons_id[0]}%')")
	end

	require 'rubygems'
  	require 'thinreports'
  		ThinReports::Report.generate_file('app/views/reports/readpdf.pdf') do
		    use_layout'app/views/reports/doct_wise_adm_report.tlf' 
      		  start_new_page do
if(name1 != "")
item(:doct).value "("+employee.name.to_s+")"
end
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Doctor Wise Admissions/Discharges"
			   item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
   
	
	s_no=1
	total=0
	advance_tot=0
	due_tot=0
        	for admission1 in admission
        		if(admission1.admn_status == 'Discharged')
        			discharge=DischargeSummary.find_by_admn_no(admission1.admn_no)
        			if(discharge)
        				final_bill=FinalBill.find_by_admn_no(admission1.admn_no)

        			else
        				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
					if(advance)
        				total_amount,advance,due,nurse_charge,ot,bed,consultant,investigation_charges,pharmacy=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)
					end

        			end
        		end
        	  		report.page.list(:list).add_row do |row|
        	    			row.item(:s_no).value s_no
        	    			row.item(:admn_no).value admission1.admn_no
        	    			row.item(:p_name).value admission1.patient_name
        	    			row.item(:age).value admission1.age.to_s+"/"+admission1.gender
        	    			row.item(:date).value admission1.admn_date
        	    			row.item(:status).value admission1.admn_status
        	    			row.item(:ward).value admission1.ward	

        	    			if(discharge)

        	    				row.item(:dis_dt).value discharge.discharge_date
        	    			
	        	    			row.item(:status).value admission1.admn_status
	        	    			row.item(:advance).value "%05.2f" % final_bill.paid_amount
	        	    			row.item(:total).value "%05.2f" % final_bill.remaining_amount
	        	    			row.item(:due).value "%05.2f" % final_bill.balance_amount
	        	    			total=total+final_bill.remaining_amount
								advance_tot=advance_tot+final_bill.paid_amount
								due_tot=due_tot+final_bill.balance_amount
        	    			else
        	    				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
        	    				if(advance)
		        	    			total_amount,advance1,due1=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)
		        	    			row.item(:status).value admission1.admn_status
		        	    			row.item(:advance).value "%05.2f" % advance1
		        	    			row.item(:total).value "%05.2f" % total_amount
		        	    			row.item(:due).value "%05.2f" % due1
		        	    			total=total+total_amount
							        advance_tot=advance_tot+advance1
							if(due1)
								due_tot=due_tot+due1
							end
        	    				end
        	    			end
        	    			
        	  		end
        	  		
        	  			s_no=s_no+1
					 item(:count).value s_no-1 					 
					 item(:total1).value "%05.2f" % total
					 item(:advsnce).value "%05.2f" % advance_tot
 					item(:due).value "%05.2f" % due_tot
					 item(:page_no).value 1
        		end

      end
      
   end
   redirect_to("/reports/readpdf/1?format=pdf")
end

 def readpdf
      send_file "app/views/reports/readpdf.pdf", :type => "application/pdf", :disposition => 'inline'
  end

def department_wise_report

	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	consultant=ConsultantMaster.all

	@consultant=Array.new
	i=0
	for con in consultant
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		@consultant[i]=con.consultant_id+"-"+employee.name
		i=i+1
	end


end

def department_wise_report_thin
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	@from_date=params[:from_date]
	@to_date=params[:to_date]
	status=params[:status]
	@department=params[:department]
	consultant=ConsultantMaster.find_by_consultant_id(params[:consultant])
	employee=EmployeeMaster.find_by_empid(params[:consultant])
	cons_id=params[:consultant].split("-")
	 if(status=="Admitted")
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{cons_id[0]}%'AND admn_status LIKE '#{params[:status]}%' AND department LIKE '#{params[:department]}%'")
    elsif(status=="Discharged" )
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{cons_id[0]}%'AND admn_status LIKE '#{params[:status]}%' AND department LIKE '#{params[:department]}%'")

	else
		admission=Admission.find(:all, :conditions=>"(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{cons_id[0]}%'AND department LIKE '#{params[:department]}%'")
	end
	require 'rubygems'
  	require 'thinreports'
  		ThinReports::Report.generate_file('app/views/reports/dept_wise_rpt.pdf') do
		    use_layout'app/views/reports/dept_wise_adm_report.tlf'
      		start_new_page do
        		org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Department wise Registration Report"
		  item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")  
   
		s_no=1
		total=0
		advance_tot=0
		due_tot=0
        	for admission1 in admission
        		if(admission1.admn_status == 'Discharged')
        			discharge=DischargeSummary.find_by_admn_no(admission1.admn_no)
        			if(discharge)
        				final_bill=FinalBill.find_by_admn_no(admission1.admn_no)
        			else
        				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
					if(advance)
        				total_amount,advance,due,nurse_charge,ot,bed,consultant,investigation_charges,pharmacy=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)
					end

        			end
        		end
        	  		report.page.list(:list).add_row do |row|
        	    			row.item(:s_no).value s_no
        	    			row.item(:admn_no).value admission1.admn_no
        	    			row.item(:p_name).value admission1.patient_name
        	    			row.item(:age).value admission1.age.to_s+"/"+admission1.gender
        	    			row.item(:date).value admission1.admn_date
        	    			row.item(:status).value admission1.admn_status
        	    			if(discharge)
        	    				row.item(:dis_dt).value discharge.discharge_date
        	    			end
        	    			row.item(:ward).value admission1.department
        	    			if(discharge)
	        	    			row.item(:status).value admission1.admn_status
	        	    			row.item(:advance).value "%05.2f" % final_bill.paid_amount
	        	    			row.item(:total).value "%05.2f" % final_bill.remaining_amount
	        	    			row.item(:due).value "%05.2f" % final_bill.balance_amount
	        	    			total=total+final_bill.remaining_amount
						advance_tot=advance_tot+final_bill.paid_amount
						due_tot=due_tot+final_bill.balance_amount
        	    			else
        	    				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
        	    				if(advance)
		        	    			total_amount,advance1,due1=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)
		        	    			row.item(:status).value admission1.admn_status
		        	    			row.item(:advance).value "%05.2f" % advance1
		        	    			row.item(:total).value "%05.2f" % total_amount
		        	    			row.item(:due).value "%05.2f" % due1
							total=total+total_amount
							advance_tot=advance_tot+advance1
							if(due1)
								due_tot=due_tot+due1
							end

        	    				end
        	    				
        	    			end
        	    			
        	  		end
        	  		s_no=s_no+1
					 item(:count).value s_no-1 					 					 
					 item(:total1).value "%05.2f" % total
					 item(:advance).value "%05.2f" % advance_tot
 					item(:due).value "%05.2f" % due_tot
					 item(:page_no).value 1
        		end

      end
      
   end
   redirect_to("/reports/dept_wise_rpt/1?format=pdf")
end
 def dept_wise_rpt
      send_file "app/views/reports/dept_wise_rpt.pdf", :type => "application/pdf", :disposition => 'inline'
  end

# package wise treport ....saritha


def package_wise_report
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@people = Person.find(@session.person_id)
	@org_code=@org.org_code
	@org_location=@org.org_location
end

def package_wise_report_thin
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	@from_date=params[:from_date]
	@to_date=params[:to_date]
	status=params[:status]
	package1=params[:package1]
	sub_package=params[:sub_package]
	
	 if(status=="Admitted")
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and package_category LIKE '#{params[:package1]}%'AND sub_category LIKE '#{params[:sub_package]}%' AND admn_status LIKE '#{params[:status]}%'")
    elsif(status=="Discharged" )
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and package_category LIKE '#{params[:package1]}%'AND sub_category LIKE '#{params[:sub_package]}%' AND admn_status LIKE '#{params[:status]}%'")

	else
	
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and package_category LIKE '#{params[:package1]}%'AND sub_category LIKE '#{params[:sub_package]}%' AND admn_category='Package'")
		puts admission.length
	end
	require 'rubygems'
  	require 'thinreports'
  		ThinReports::Report.generate_file('app/views/reports/package_wise.pdf') do
		    use_layout'app/views/reports/package_wise_report_thin_tmplt.tlf'
      		start_new_page do
        		org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Package Wise Admissions / Discharges"
		  item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")  
		s_no=1
		total=0
		advance_tot=0
		due_tot=0
		for admission1 in admission
        		if(admission1.admn_status == 'Discharged')
        			discharge=DischargeSummary.find_by_admn_no(admission1.admn_no)
        			if(discharge)
        				final_bill=FinalBill.find_by_admn_no(admission1.admn_no)
        			else
        				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
        				total_amount,advance,due,nurse_charge,ot,bed,consultant,investigation_charges,pharmacy=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)

        			end
        		end
        	  		report.page.list(:list).add_row do |row|
        	    			row.item(:s_no).value s_no
        	    			row.item(:admn_no).value admission1.admn_no
        	    			row.item(:p_name).value admission1.patient_name
        	    			row.item(:age).value admission1.age.to_s+"/"+admission1.gender
        	    			row.item(:date).value admission1.admn_date
        	    			if(discharge)
        	    				row.item(:dis_dt).value discharge.discharge_date
        	    			end
      						row.item(:package).value admission1.package_category
        	    			if(discharge)
	        	    			
	        	    			row.item(:advance).value "%05.2f" % final_bill.paid_amount
	        	    			row.item(:total).value "%05.2f" % final_bill.remaining_amount
	        	    			row.item(:due).value "%05.2f" % final_bill.balance_amount
	        	    			total=total+final_bill.remaining_amount
						advance_tot=advance_tot+final_bill.paid_amount
						due_tot=due_tot+final_bill.balance_amount

        	    			else
        	    				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
        	    				if(advance)
		        	    			total_amount,advance1,due1=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)
		        	    	
		        	    			row.item(:advance).value "%05.2f" % advance1
		        	    			row.item(:total).value "%05.2f" % total_amount
		        	    			row.item(:due).value "%05.2f" % due1
		        	    		total=total+total_amount
							advance_tot=advance_tot+advance1
							if(due1)
								due_tot=due_tot+due1
							end
        	    				end
        	    				
        	    			end
        	    			
        	  		end
        	  		s_no=s_no+1
					 item(:count).value s_no-1 					 
					 item(:total).value "%05.2f" % total
					 item(:advance).value "%05.2f" % advance_tot
 					item(:due).value "%05.2f" % due_tot
					 item(:page_no).value 1
        		end

      end
      
   end
   redirect_to("/reports/package_wise/1?format=pdf")
end
 def package_wise
      send_file "app/views/reports/package_wise.pdf", :type => "application/pdf", :disposition => 'inline'
  end

	def refferal_report2
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
    referral=params[:refferal]      

       	appointment_payments = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND referral='Referral' AND referral_name like '#{params[:refferal]}%'")

          opamt=0
       labamt=0
       ipamt=0
       pamt=0
       for app in appointment_payments
       	opamt=opamt+AppointmentPayment.sum(:paid_amount, :conditions =>"mr_no='#{app.mr_no}'")
		 labamt=labamt+TestBooking.sum(:grand_total, :conditions =>"mr_no='#{app.mr_no}'")
		 ipamt=ipamt+FinalBill.sum(:paid_amount, :conditions =>"mr_no='#{app.mr_no}'")
		 pamt=pamt+IssuesToOp.sum(:paid_amt, :conditions =>"mr_no='#{app.mr_no}'")
       end
      

      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/refferal.pdf') do
        use_layout'app/views/reports/refferal_report4.tlf'
        
       start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Referral Registration Report"
			   item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            
            total=0
            total1=0
            total2=0
            total3=0
            grand_tot1=0
            s_no=1
            for appointment_payment in appointment_payments
                               
                report.page.list(:list).add_row do |row|
                	
                    row.item(:s_no).value s_no
                    if(appointment_payment.referral_name!="")
                    row.item(:cons).value appointment_payment.referral_name
                    else
                	row.item(:cons).value ""
                    end
                    row.item(:mr_no).value appointment_payment.mr_no
                    row.item(:p_name).value appointment_payment.patient_name
                    row.item(:age).value appointment_payment.age.to_s+"/"+appointment_payment.gender
                    row.item(:date).value appointment_payment.reg_date
                     row.item(:op).value "%05.2f" % opamt
                     row.item(:ip).value "%05.2f" % ipamt
                     row.item(:lab).value "%05.2f" % labamt
				row.item(:pharmacy).value "%05.2f" % pamt
			total=total+opamt
			total1=total1+ipamt
			total2=total2+labamt
			total3=total3+pamt
grand_tot1=total+total1+total2+total3
                     s_no=s_no+1
					 item(:count).value s_no-1 					 
					 item(:total).value "%05.2f" % total
					 item(:total1).value "%05.2f" % total1
					 item(:total2).value "%05.2f" % total2
					 item(:total3).value "%05.2f" % total3
					 item(:grand_tot).value "%05.2f" % grand_tot1
					 item(:page_no).value 1
			end		
		end			 
    end
     end
     redirect_to("/reports/refferal/1?format=pdf")
    end

 

def insurance_registration_report
end

def insurance_registration1
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
       registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND reg_type='Insurance' and ins_company_name Like '#{params[:company]}%' ")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/insurance.pdf') do
        use_layout'app/views/reports/insurance_report.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Insurance Companywise Registrations"
			   item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
				total=0
            for registration in registrations
                admission=Admission.find_by_mr_no(registration.mr_no)
					 	
				    report.page.list(:list).add_row do |row|			
 	                   row.item(:s_no).value s_no
 	                   row.item(:company).value registration.ins_company_name
 	                   row.item(:policy).value registration.policy_no
 	                   row.item(:mr_no).value registration.mr_no
 	                   row.item(:patient).value registration.patient_name
 	                   
 	                  city1=InsuranceMaster.find_by_company_name(registration.ins_company_name)
 	                   row.item(:date).value registration.reg_date
 	                   row.item(:city).value city1.city
 	                   if(admission)
 	                   		emp=EmployeeMaster.find_by_empid(admission.consultant_id)
 	                   row.item(:cons).value emp.name
 	               else
 	               	   row.item(:cons).value " ----"
 	                  end
 	                   
							 
                end
					 s_no=s_no+1
					 item(:count).value s_no-1 					 
					
					 item(:page_no).value 1
					end	
					 
            end
    end
    redirect_to("/reports/insurance/1?format=pdf")
   end
  
    def insurance
    	send_file "app/views/reports/insurance.pdf", :type => "application/pdf", :disposition => 'inline'
    end
   
    
 def admissions_report
 
 end

def admissions_report_1
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
      name1=params[:name]
      if(name1!="")
      admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND consultant_name LIKE '#{params[:name]}'")
      else
      	admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/admission.pdf') do
        use_layout'app/views/reports/admission_report2.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Admissions Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
            for admission in admissions
           
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:admn_no).value admission.admn_no
                     row.item(:p_name).value admission.patient_name
                     row.item(:age).value admission.age.to_s+"/"+admission.gender
                     row.item(:date).value admission.admn_date
                      row.item(:ward).value admission.ward
                       row.item(:status).value admission.admn_status
                     row.item(:advance).value "%05.2f" % admission.advance
                     row.item(:total).value "%05.2f" % admission.amount
               total=total+admission.amount
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:page_no).value 1
          end 
      end
end
redirect_to("/reports/admission/1?format=pdf")
end
 def admission
     send_file "app/views/reports/admission.pdf", :type => "application/pdf", :disposition => 'inline'
 end

def deparment_wise_report
end

 def department_wise_report_1
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
      case2=params[:case1]
   if(case2=="IP")
case3="IP"
	if(params[:department] != "")
	      	
	      admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND department LIKE '#{params[:department]}'")
	else
		 admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
	end
    elsif(case2=="OP")
  	case3="OP"
if (params[:department] != "")
      admissions = AppointmentPayment.find(:all, :conditions=>"appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND department LIKE '#{params[:department]}'")
else

	admissions = AppointmentPayment.find(:all, :conditions=>"appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
end
     
     end 
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/department_wise.pdf') do
        use_layout'app/views/reports/department_report.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Department Wise Report"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")         
            s_no=1
        total=0
            for admission in admissions
           
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:mr_no).value admission.mr_no
                     row.item(:p_name).value admission.patient_name
                     row.item(:age).value admission.age.to_s+"/"+admission.gender
		     row.item(:dept).value admission.department
                     row.item(:case).value case3
                     if(case2=="IP" && admission.amount!="")
		if(admission.advance)
                     row.item(:total).value "%05.2f" % admission.advance
                      total=total+admission.advance
		end
                    elsif(case2=="OP"  && admission.paid_amount!="")
                    	 row.item(:total).value "%05.2f" % admission.paid_amount
                      total=total+admission.paid_amount
                  else
                 	row.item(:total).value "%05.2f" % "0"
                 	total=total
                   end
              
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:page_no).value 1
          end 
           
           
    end
    end
     redirect_to("/reports/department_wise/1?format=pdf") 
     end
     def department_wise

      send_file "app/views/reports/department_wise.pdf", :type => "application/pdf", :disposition => 'inline'
    end
 def insurance_payment
 end

 def insurance_payment_report
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
      admn1=params[:admn_no]
	 patient_name=params[:patient_name]
      if(admn1!="")
      insurance_payments = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND admn_no LIKE '#%{params[:admn_no]}' AND patient_name LIKE '#{params[:patient_name]}%'")
      else
      	insurance_payments = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'AND patient_name LIKE '#{params[:patient_name]}%'")
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/insurance_payment1.pdf') do
        use_layout'app/views/reports/insurance_payment.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Insurance Payments Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
            for insurance_payment in insurance_payments

          admin=InsurancePayment.find_by_mr_no(insurance_payment.mr_no)
if(admin)
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:admn_no).value insurance_payment.admn_no
              
                     row.item(:p_name).value insurance_payment.patient_name
                     row.item(:age).value insurance_payment.age.to_s+"/"+insurance_payment.gender
     
                     row.item(:date).value insurance_payment.admn_date

                     row.item(:dis_date).value admin.dis_date

                      registration=Registration.find_by_mr_no(insurance_payment.mr_no)
                      if(registration)
                      	row.item(:company).value registration.ins_company_name
                      else
                      	row.item(:company).value ""
                      end

                     row.item(:total_amt).value "%05.2f" % admin.amount
               total=total+admin.amount
end
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:page_no).value 1
          end 
           
           
    end
    end
     redirect_to("/reports/insurance_payment1/1?format=pdf") 
     end
     def insurance_payment1

      send_file "app/views/reports/insurance_payment1.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def insurance_company_wise
end
def insurance_company_report
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
      company=params[:company_name]
      if(company!="")
      registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND reg_type='Insurance' AND ins_company_name LIKE '#{params[:company_name]}'")
      else
      	registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND reg_type='Insurance'")
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/insurance_company_wise1.pdf') do
        use_layout'app/views/reports/insurance_company_wise.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Insurance Company Wise Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
            for registration in registrations
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:company).value registration.ins_company_name
                     admission=Admission.find_by_mr_no(registration.mr_no)
				 final=FinalBill.find_by_mr_no(registration.mr_no)
				 dis=DischargeSummary.find_by_mr_no(registration.mr_no)
           if(admission)
                     row.item(:admn_no).value admission.admn_no
                     row.item(:date).value admission.admn_date
		if(final)
                     row.item(:total_amt).value "%05.2f" % final.balance_amount
                     total=total+final.balance_amount.to_f
		end
                 else 
                 	row.item(:admn_no).value ""
                 	 row.item(:date).value ""
                 	 row.item(:total_amt).value "%05.2f" % "0.0"
                 	 total=total
                 end
              
                 if(dis)
                 	row.item(:dis_date).value dis.discharge_date
                 else
                 	row.item(:dis_date).value "-----"
                 end
                     row.item(:p_name).value registration.patient_name
                     row.item(:age).value registration.age.to_s+"/"+registration.gender
                
                     
               
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:page_no).value 1
          end 
           
           
    end
    end
     redirect_to("/reports/insurance_company_wise1/1?format=pdf") 
     end
     def insurance_company_wise1

      send_file "app/views/reports/insurance_company_wise1.pdf", :type => "application/pdf", :disposition => 'inline'
    end
    def patient_wise_package
    end
    def patient_wise_report

home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end

    admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND package_category LIKE '#{params[:package_category]}%' AND sub_category LIKE '#{params[:sub_category]}%'")
 
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/patient_wise_report1.pdf') do
        use_layout'app/views/reports/patient_wise_report.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Patient Wise Package Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
            for admission in admissions
           final_bill=FinalBill.find_by_mr_no(admission.mr_no)
		
		if(final_bill)
due=final_bill.due
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:admn_no).value admission.admn_no
                      row.item(:p_name).value admission.patient_name
                     row.item(:age).value admission.age.to_s+"/"+admission.gender
                     row.item(:ward).value admission.ward
                     row.item(:date).value admission.admn_date
                	row.item(:due).value "%05.2f" % due
                	total=total+due
            
             
                end
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           
           item(:page_no).value 1
          end 
           
           
    end
    end
     redirect_to("/reports/patient_wise_report1/1?format=pdf") 
     end
     def patient_wise_report1

      send_file "app/views/reports/patient_wise_report1.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

    def patientwise_finalbill_cancel
    end
    def patientwise_finalbill_cancel_report
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
    finalbills = FinalBillCancel.find(:all, :conditions=>"final_bill_cancel_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/patientwise_finalbill_cancel1.pdf') do
        use_layout'app/views/reports/patientwise_finalbill_cancel1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Patient Wise FinalBill Cancel Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
        total1=0
            for finalbill in finalbills
           
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:admn_no).value finalbill.admn_no
                     row.item(:final).value "%05.2f" % finalbill.final_bill_amount
                     row.item(:cancel).value "%05.2f" % finalbill.final_bill_cancel_amount	
                     admission=Admission.find_by_admn_no(finalbill.admn_no)
                     if(admission)
                      row.item(:p_name).value admission.patient_name
                     row.item(:age).value admission.age.to_s+"/"+admission.gender
                     row.item(:ward).value admission.ward
                     row.item(:date).value admission.admn_date
                     else
                     	row.item(:p_name).value ""
                     row.item(:age).value ""
                     row.item(:ward).value ""
                     row.item(:date).value ""
                    
                  end
                       final=FinalBill.find_by_admn_no(finalbill.admn_no)
                    if(final)
                    	row.item(:authority).value final.concession_authority
                    else
                    	row.item(:authority).value "-----"
                    end
               total=total+finalbill.final_bill_cancel_amount
               total1=total1+finalbill.final_bill_amount
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
            item(:total1).value "%05.2f" % total1
           item(:page_no).value 1
          end 
           
           
    end
    end
     redirect_to("/reports/patientwise_finalbill_cancel1/1?format=pdf") 
     end
     def patientwise_finalbill_cancel1

      send_file "app/views/reports/patientwise_finalbill_cancel1.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

def miscellaneous_report
end
def miscellaneous_report_1
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
    reports1 =  MiscellaneousMaster.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/miscellaneous_report1.pdf') do
        use_layout'app/views/reports/miscellaneous_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Miscellaneous Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
        total1=0
            for report2 in reports1
           
              report.page.list(:list).add_row do |row|          
                     row.item(:s_no).value s_no
                     row.item(:date1).value report2.date
                     mis=MiscellaneousChild.find_by_miscellaneous_master_id(report2.id)
                     if(mis)
                     row.item(:service).value mis.service
                     row.item(:amt).value "%05.2f" % mis.amount
                 else
                 	 row.item(:service).value "---"
                     row.item(:amt).value "%05.2f" % "0.0"
                 end
                     row.item(:total_amt).value "%05.2f" % report2.total_amount	
                    
               total=total+report2.total_amount
               total1=total1+mis.amount
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:page_no).value 1
          end 
           
           
    end
    end
     redirect_to("/reports/miscellaneous_report1/1?format=pdf") 
     end
     def miscellaneous_report1

      send_file "app/views/reports/miscellaneous_report1.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

    def patientwise_package_finalbill
    end
    def patientwise_finalbill_report
    	home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
      package=params[:package_category]
      sub=params[:sub_category]
      admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND package_category LIKE '#{params[:package_category]}%' AND sub_category LIKE '#{params[:sub_category]}%' and admn_category='Package'")
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/patientwise_package_bill.pdf') do
        use_layout'app/views/reports/patientwise_finalbill1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Patient Wise Package Final Bill Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
        total1=0
            for admission in admissions
           
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:admn_no).value admission.admn_no
                      row.item(:p_name).value admission.patient_name
                     row.item(:age).value admission.age.to_s+"/"+admission.gender
                     row.item(:date).value admission.admn_date
                     row.item(:ward).value admission.ward
                     row.item(:package).value admission.package_category
                     final1=FinalBill.find_by_admn_no(admission.admn_no)
                     if(final1)
                     	 row.item(:final).value  "%05.2f" % final1.paid_amount.to_f
					 row.item(:due).value "%05.2f" % final1.balance_amount.to_f
                     	 total1=total1+final1.paid_amount.to_f
					total=total+final1.balance_amount.to_f

                     else
                         row.item(:final).value "0.0"
					 row.item(:due).value "%05.2f" % "0.0"
                         total1=total1
					total=total
                     end
 
               
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total1).value "%05.2f" % total1
           item(:total).value "%05.2f" % total
           item(:page_no).value 1
          end 
      end     
           
   
    end
     redirect_to("/reports/patientwise_package_bill/1?format=pdf") 
     end
     def patientwise_package_bill

      send_file "app/views/reports/patientwise_package_bill.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

def firstaid_report
end
def firstaid_report_1
	reports =  FirstAid.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/firstaid_report1.pdf') do
        use_layout'app/views/reports/firstaid_report2.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Miscellaneous Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
        total1=0
            for report in reports
           
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:date1).value report.date
                     
                     row.item(:service).value mis.service
                     row.item(:amt).value "%05.2f" % mis.amount
                 
                     row.item(:total_amt).value "%05.2f" % report.total_amount	
                    
               total=total+report.total_amount
               total1=total1+mis.amount
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:page_no).value 1
          end 
           
           
    end
    end
     redirect_to("/reports/firstaid_report1/1?format=pdf") 
     end
     def firstaid_report1

      send_file "app/views/reports/firstaid_report1.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

def doctorwise_concession_op
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	consultant=ConsultantMaster.all
	@consultant=Array.new
	i=0
	for con in consultant
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		@consultant[i]=con.consultant_id+"-"+employee.name
		i=i+1
	end

end
 def doctorwise_op_report
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
cons_id=params[:name].split("-")
	name1=params[:name]
	case2=params[:case1]
     appointment_payments = AppointmentPayment.find(:all, :conditions=>"appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND consultant_name LIKE '#{cons_id[1]}%'")
     require 'rubygems'
     require 'thinreports'
     ThinReports::Report.generate_file('app/views/reports/doctorwise_op_report1.pdf') do
        use_layout'app/views/reports/doctorwise_concession_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Doctor Wise Concession Report"
         	  item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
            total=0.0
            for appointment_payment in appointment_payments
                    
                     
                 if(case2=="OP")
				report.page.list(:list).add_row do |row|
                     row.item(:s_no).value s_no
                     row.item(:mr_no).value appointment_payment.mr_no
                     row.item(:p_name).value appointment_payment.patient_name
                     row.item(:age).value appointment_payment.age.to_s+"/"+appointment_payment.gender
                     row.item(:concession).value "%05.2f" % appointment_payment.concession
                     row.item(:cons).value appointment_payment.consultant_name
                     row.item(:case).value "OP"
                     total=total+appointment_payment.concession
				end
			     s_no=s_no+1                 
                 elsif(case2=="Lab")
                 	testbooking=TestBooking.sum(:concession,:conditions => "refferal_doctor like '#{cons_id[1]}%' and mr_no = '#{appointment_payment.mr_no}'")
				if(testbooking.to_f!=0)
				   report.page.list(:list).add_row do |row|
		            	 row.item(:s_no).value s_no
		            	 row.item(:mr_no).value appointment_payment.mr_no
		                row.item(:p_name).value appointment_payment.patient_name
		                row.item(:concession).value testbooking
		                row.item(:cons).value appointment_payment.consultant_name
		                row.item(:case).value "OP"
		                total=total+testbooking
                		 reg=Registration.find_by_mr_no(appointment_payment.mr_no)
                     	 if(reg)
                       		row.item(:age).value reg.age.to_s+"/"+reg.gender
                     	 else
                 	   		row.item(:age).value ""
                     	 end
				   end
 			        s_no=s_no+1
				end
                 elsif(case2=="Pharmacy")
                    issues=IssuesToOp.sum(:concession_amount,:conditions => "consultant like '#{cons_id[1]}%' and mr_no = '#{appointment_payment.mr_no}'")
                    if(issues.to_i!=0)
				  report.page.list(:list).add_row do |row|
                        row.item(:s_no).value s_no
                        row.item(:mr_no).value appointment_payment.mr_no
	                   row.item(:p_name).value appointment_payment.patient_name
	                   row.item(:concession).value "%05.2f" % issues
	                   row.item(:cons).value appointment_payment.consultant_name
                        total=total+issues
                        row.item(:age).value appointment_payment.age.to_s+"/"+appointment_payment.gender
                        row.item(:case).value "OP"
                      end
				   s_no=s_no+1
				end  
                 end   
          
          
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:page_no).value 1
          end 
      end
end
redirect_to("/reports/doctorwise_op_report1/1?format=pdf")
end
 def doctorwise_op_report1
     send_file "app/views/reports/doctorwise_op_report1.pdf", :type => "application/pdf", :disposition => 'inline'
 end

def package_transfer
end
def package_transfer_report
	home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	pack=params[:package_category]
	subpack=params[:sub_category]
	if(pack!="")
	  packages = PakageTransfer.find(:all, :conditions=>"today_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND trans_cat LIKE '#{params[:package_category]}'")
     elsif(subpack!="")
      packages = PakageTransfer.find(:all, :conditions=>"today_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND trans_subcat LIKE '#{params[:sub_category]}'")
     else
      packages = PakageTransfer.find(:all, :conditions=>"today_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
     end 
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/package_transfer_report1.pdf') do
        use_layout'app/views/reports/package_transfer1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Package Transfers Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
        total1=0
            for package in packages
           
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:admn_no).value package.admn_no
                     row.item(:today_date).value package.today_date
                     if(package.t_amount!="")
                      row.item(:tot_amt).value "%05.2f" % package.t_amount
                      total1=total1+(package.t_amount).to_f
                     else
                  	  row.item(:tot_amt).value ""
                      total1=total1
                     end
                      row.item(:trans_pac).value package.trans_cat
                     admission=Admission.find_by_admn_no(package.admn_no)
                     if(admission)
                      row.item(:p_name).value admission.patient_name
                      row.item(:age).value admission.age.to_s+"/"+admission.gender
                      row.item(:date).value admission.admn_date
                      row.item(:status).value admission.admn_status
	                      if(admission.advance!="")
	                      row.item(:adv).value admission.advance
	                      total=total+admission.advance
	                      else
	                      row.item(:adv).value ""
	                      total=total
	                      end
                     else
                  	  row.item(:p_name).value ""
                      row.item(:age).value ""
                      row.item(:date).value ""
                      row.item(:status).value ""
                      
                     end
                     
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:page_no).value 1
          end 
           
           
    end
    end
     redirect_to("/reports/package_transfer_report1/1?format=pdf") 
     end
     def package_transfer_report1

      send_file "app/views/reports/package_transfer_report1.pdf", :type => "application/pdf", :disposition => 'inline'
    end	
    def ajax_buildings
mr1=params[:q1]
type=params[:type]
if(type=="package_category")
@pm=PackageMasterMajestic.find(:all,:conditions => "category='#{mr1}'")	
puts @pm[0].sub_category
str=""
for pm in @pm
str << pm.sub_category+"<division>"
end
render :text=>str	
end
end
  def registration_report
    end
    def registration_report1
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
      registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/registration_report2.pdf') do
        use_layout'app/views/reports/reg.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Total Registrations"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
           total=0
             for registration in registrations
              appointment=AppointmentPayment.find_by_mr_no(registration.mr_no)
               admission=Admission.find_by_mr_no(registration.mr_no)
                    report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:mr_no).value registration.mr_no
                     row.item(:p_name).value registration.patient_name
                     row.item(:age).value registration.age.to_s+"/"+registration.gender
                     row.item(:date).value registration.reg_date
                     if(appointment)
                     row.item(:case).value "OP"
                     row.item(:c_name).value appointment.consultant_name
                     row.item(:amount).value "%05.2f" % appointment.paid_amount
                     total=total+appointment.paid_amount
                      elsif(admission)
                      	row.item(:case).value "IP"
                      	emp=EmployeeMaster.find_by_empid(admission.consultant_id)
		             	 if(emp)
                        row.item(:c_name).value emp.name
		                end
                     row.item(:amount).value "%05.2f" % admission.advance
                     total=total+admission.advance
					end
                end
		           s_no=s_no+1
		           item(:count).value s_no-1           
		           item(:total).value "%05.2f" % total
		           item(:page_no).value 1
          end 
           
            
    end
      
    end
    redirect_to("/reports/registration_report2/1?format=pdf") 
 end
     def registration_report2

      send_file "app/views/reports/registration_report2.pdf", :type => "application/pdf", :disposition => 'inline'
    end



 def wardwise_bedtransfer
 end

 def wardwise_report
 	room1=params[:room]
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end

if (room1 != "")

     bedtransfers = BedTransfer.find(:all, :conditions=>"transfer_date BETWEEN '#{params[:from_date]}' AND '#{params[:to_date]}' AND from_ward LIKE '#{params[:ward]}' AND from_room Like '#{params[:room]}'") 
else

	bedtransfers = BedTransfer.find(:all, :conditions=>"transfer_date BETWEEN '#{params[:from_date]}' AND '#{params[:to_date]}'") 
end

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/wardwise_report1.pdf') do
        use_layout'app/views/reports/wardwise_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Ward Wise Report"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
        total1=0
            for bedtransfer in bedtransfers
           
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:admn_no).value bedtransfer.admn_no
                     row.item(:trans_date).value bedtransfer.transfer_date
                     row.item(:from).value bedtransfer.from_ward
                     row.item(:to).value bedtransfer.to_ward	
                     admission=Admission.find_by_admn_no(bedtransfer.admn_no)
                     if(admission)
                      row.item(:p_name).value admission.patient_name
                      row.item(:age).value admission.age.to_s+"/"+admission.gender
                      row.item(:date).value admission.admn_date
                      row.item(:status).value admission.admn_status
                     
                      
                     else
                  	  row.item(:p_name).value ""
                      row.item(:age).value ""
                      row.item(:date).value ""
                      row.item(:status).value ""
                     
                     end
                      
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           
           item(:page_no).value 1
          end 
           
           
    end
    end
     redirect_to("/reports/wardwise_report1/1?format=pdf") 
     end
     def wardwise_report1

      send_file "app/views/reports/wardwise_report1.pdf", :type => "application/pdf", :disposition => 'inline'
    end	
   def ajax_buildings1	
	mr1=params[:q1]
	type=params[:type]
	if(type=="ward")
	@ward=WardMaster.find_by_name(mr1)
	@room=RoomMaster.find(:all, :conditions => "ward_master_id = '#{@ward.id}'") 
	puts @room[0].name
	str=""
	for room in @room
	str << room.name+"<division>"
	end
	render :text=>str	
	end
	end

	def arogyasree_registration
    
  end


  def arogyasree_registration_report
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
       patient=params[:patient_name]
       if(patient!="")
      registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND reg_type='Arogyasree' AND patient_name LIKE '#{params[:patient_name]}%'")
      else
      registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND reg_type='Arogyasree'")	
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/arogyasree_report.pdf') do
        use_layout'app/views/reports/arogyasree_report.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Arogyasree Registrations"
            item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
       
            for registration in registrations
                 
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:mr_no).value registration.mr_no
                     row.item(:p_name).value registration.patient_name
                     row.item(:age).value registration.age.to_s+"/"+registration.gender
                     row.item(:date).value registration.reg_date
                     admission=Admission.find_by_mr_no(registration.mr_no)
                     if(admission)
                     	
                      row.item(:admn_no).value admission.admn_no
                      row.item(:ward).value admission.ward
                      
                           
                    else 
                    	row.item(:cons).value "----"
	                    row.item(:admn_no).value "----"
	                    row.item(:ward).value "-----"
	                    
                     end
                     appointment=AppointmentPayment.find_by_mr_no(registration.mr_no)
                     if(appointment) 
                     row.item(:cons).value appointment.consultant_name
                    
                    elsif(admission)
                    	emp=EmployeeMaster.last(admission.consultant_id)
                     	
                      row.item(:cons).value emp.name
                    end
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           
           item(:page_no).value 1
          end 
           
            
    end
    end
    redirect_to("/reports/arogyasree_report/1?format=pdf")
 end
     def arogyasree_report

      send_file "app/views/reports/arogyasree_report.pdf", :type => "application/pdf", :disposition => 'inline'
    end




 def consutant_visits1_app
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	consultant=ConsultantMaster.all
	@consultant=Array.new
	i=0
	for con in consultant
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		@consultant[i]=con.consultant_id+"-"+employee.name
		i=i+1
	end


end
 def consultant_visit_report
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
 	
 	patient_type=params[:patient_type]
name1=params[:name]
 	cons_id=params[:name].split("-")
 	if(patient_type=="OP")
     appt_payments=AppointmentPayment.find(:all,:conditions => "(appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_name LIKE '#{cons_id[1]}%'")
    elsif(patient_type=="IP")
    appt_payments=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{cons_id[0]}%'")
    else
     appt_payments=Registration.all
    end
    	 require 'rubygems'
  	 require 'thinreports'
  	 ThinReports::Report.generate_file('app/views/reports/consultant1.pdf') do
    use_layout'app/views/reports/consultant_visit.tlf'
    	 start_new_page do
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Doctor wise Registration Report"
if(name1 != "")
item(:con).value "("+cons_id[1].to_s+")"
end
			item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
            total=0
        	 for appt_payment in appt_payments
                       report.page.list(:list).add_row do |row|	
 	                   row.item(:s_no).value s_no
 	                   row.item(:mr_no).value appt_payment.mr_no
 	                   row.item(:p_name).value appt_payment.patient_name
 	                   
 	                    row.item(:age).value appt_payment.age.to_s+"/"+appt_payment.gender
 	                  
 	                   if(patient_type=="OP")
 	                   	 row.item(:case).value "OP"
 	                   	row.item(:date).value appt_payment.appt_date
					
 	                   row.item(:amount).value "%05.2f" % appt_payment.paid_amount
 			  total=total+appt_payment.paid_amount
	elsif(patient_type=="IP")
				 row.item(:case).value "IP"
				    row.item(:date).value appt_payment.admn_date
				if(appt_payment.advance)	 
				row.item(:amount).value "%05.2f" % appt_payment.advance
				 total=total+appt_payment.advance
				end
			else

		end
                end
                
 s_no=s_no+1
 item(:count).value s_no-1 	  
 item(:total).value "%05.2f" % total
 item(:page_no).value 1
end	
 
           
    end
      
    end
    redirect_to("/reports/consultant1/1?format=pdf")
end
def consultant1
    send_file "app/views/reports/consultant1.pdf", :type => "application/pdf", :disposition => 'inline'	
    end

#ward wise admission and discharges

def wardwise_admissions
end
def wardwise_admission_report
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
status1=params[:status]
room1=params[:room]
ward=params[:ward]
admission = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
if(ward!="")
admission = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND ward LIKE '#{params[:ward]}'")
end
if(status1=='Admitted')
 admission = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND admn_status='Admitted' AND ward LIKE '#{params[:ward]}' AND room = '#{params[:room]}'")
 elsif(status1=='Discharged')
 admission = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND admn_status='Discharged' AND ward LIKE '#{params[:ward]}' AND room Like '#{params[:room]}'")	
     
     end

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/wardwise_adm.pdf') do
        use_layout'app/views/reports/wardwise_adm2.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Wardwise Admissions/Discharges Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
           s_no=1
	total=0
	advance_tot=0
	due_tot=0
        	for admission1 in admission
        		if(admission1.admn_status == 'Discharged')
        			discharge=DischargeSummary.find_by_admn_no(admission1.admn_no)
        			if(discharge)
        				final_bill=FinalBill.find_by_admn_no(admission1.admn_no)

        			else
        				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
					if(advance)
        				total_amount,advance,due,nurse_charge,ot,bed,consultant,investigation_charges,pharmacy=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)
					end

        			end
        		end
        	  		report.page.list(:list).add_row do |row|
        	    			row.item(:s_no).value s_no
        	    			row.item(:admn_no).value admission1.admn_no
        	    			row.item(:p_name).value admission1.patient_name
        	    			row.item(:age).value admission1.age.to_s+"/"+admission1.gender
        	    			row.item(:date).value admission1.admn_date
        	    			row.item(:status1).value admission1.admn_status
        	    			row.item(:ward).value admission1.ward	

        	    			if(discharge)

        	    				row.item(:dis_dt).value discharge.discharge_date
        	    			
	        	    			row.item(:status1).value admission1.admn_status
	        	    			row.item(:amount).value "%05.2f" % final_bill.paid_amount
	        	    			row.item(:amt).value "%05.2f" % final_bill.remaining_amount
	        	    			row.item(:amt1).value "%05.2f" % final_bill.balance_amount
	        	    			total=total+final_bill.remaining_amount
								advance_tot=advance_tot+final_bill.paid_amount
								due_tot=due_tot+final_bill.balance_amount
        	    			else
        	    				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
        	    				if(advance)
		        	    			total_amount,advance1,due1=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)
		        	    			row.item(:status1).value admission1.admn_status
		        	    			row.item(:amount).value "%05.2f" % advance1
		        	    			row.item(:amt).value "%05.2f" % total_amount
		        	    			row.item(:amt1).value "%05.2f" % due1
		        	    			total=total+total_amount
							        advance_tot=advance_tot+advance1
							if(due1)
								due_tot=due_tot+due1
							end
        	    				end
        	    			end
        	    			
        	  		end
        	  		
        	  			s_no=s_no+1
					 item(:count).value s_no-1 					 
					 item(:total).value "%05.2f" % total
					 item(:total1).value "%05.2f" % advance_tot
 					item(:total2).value "%05.2f" % due_tot
					 item(:page_no).value 1
        		end

      end

    end
    redirect_to("/reports/wardwise_adm/1?format=pdf")
 end
     def wardwise_adm

      send_file "app/views/reports/wardwise_adm.pdf", :type => "application/pdf", :disposition => 'inline'
    end
def wardwise
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
from_date=params[:from_date]
to_date=params[:to_date]
room=params[:room]
ward=params[:ward]
status=params[:status]
require 'rubygems'
  	require 'thinreports'
   ThinReports::Report.generate_file('app/views/reports/wardwise_bed.pdf') do
    use_layout 'app/views/reports/wardwise_bed1.tlf'
    start_new_page do
        	 org_master_child=OrgMasterChildTable.last
        	
        	 item(:image).value prawn_logo
        	   	 item(:address1).value org_master_child.address.split(";")[0]
            	item(:address2).value org_master_child.address.split(";")[1]
            	item(:address3).value org_master_child.address.split(";")[2]
            	item(:address4).value org_master_child.address.split(";")[3]     
             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
             	item(:report_name).value "Wardwise Bed Status Report"

             	s_no=1
             	total=0
ward1=WardMaster.find_by_name(ward)
room1=RoomMaster.find_by_name_and_ward_master_id(room,ward1.id)
if(status=="ALL")
admissions=BedMaster.find(:all, :conditions=>" created_at BETWEEN '#{from_date}' AND '#{to_date}' AND ward_master_id LIKE '#{ward1.id}' AND room_master_id LIKE '#{room1.id}'")	              	
else
admissions=BedMaster.find(:all, :conditions=>" created_at BETWEEN '#{from_date}' AND '#{to_date}' AND status LIKE '#{status}' AND  ward_master_id LIKE '#{ward1.id}' AND room_master_id LIKE '#{room1.id}'")	              	
end


  	for admission in admissions
  	  	report.page.list(:list).add_row do |row|
        	    	 row.item(:s_no).value s_no
        	    	 row.item(:ward).value ward
        	    	 row.item(:room).value room
        	    	 row.item(:bed).value admission.name
        	    	 row.item(:status).value admission.status
        	    end
        	  	 s_no=s_no+1
        	  	 item(:count).value s_no-1 	
        	  	 item(:page_no).value 1
        	
        	 end


  end
end
redirect_to("/reports/wardwise_bed/1?format=pdf")	
end 
def wardwise_bed

      send_file "app/views/reports/wardwise_bed.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def external_doctor_labrefunds
end
def externaldoctorwise_lab
	
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
		from_date=params[:from_date]
		to_date=params[:to_date]
		service_name=params[:service]
		lab=params[:lab_department]

		refferal=params[:refferal]

 cons_id=params[:refferal].split("-")

		
		require 'rubygems'
		  		require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/external.pdf') do
				    use_layout 'app/views/reports/externaldoctorwise_labrefunds.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value prawn_logo
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "External Doctorwise Lab Referals"
				             	s_no=1
				             	total=0

				       if(refferal!="")  

                 registrations=Registration.find(:all, :conditions=>"referral_name ='#{refferal}'")
 for registration in registrations
test_bookings=TestBooking.find(:all, :conditions=>"booking_date  BETWEEN '#{from_date}' AND '#{to_date}' and  mr_no = '#{registration.mr_no}' ")

		        		for test_booking in test_bookings


                           test_booking_child1=TestBookingChild.find(:all,:conditions=>"test_booking_id = '#{test_booking.id}' and department like '#{lab}%' and  test_name like '#{service_name}%' ")

    	  					for test_booking_child in test_booking_child1
		        	  				report.page.list(:list).add_row do |row|
		        	    			row.item(:s_no).value s_no
		        					row.item(:mr_no).value test_booking.mr_no
		        	    			row.item(:p_name).value test_booking.patient_name
		        	    			row.item(:age).value registration.age.to_s+"/"+registration.gender
		        	    			row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")+"/"+test_booking.created_at.strftime("%H:%M")
		        	    			row.item(:cons).value refferal
		        	    		    row.item(:test_name).value test_booking_child.test_name
		        	    			
		        	    			row.item(:paid_amt).value "%05.2f" % test_booking_child.amount
		        	    			total=total+test_booking_child.amount
		        	    		     end
		        	   end
		        	end
		     end
		        	  	else
		        	  		test_bookings=TestBooking.find(:all, :conditions=>"booking_date  BETWEEN '#{from_date}' AND '#{to_date}'")

		        	  			for test_booking in test_bookings
                         registration=Registration.find_by_mr_no_and_referral(test_booking.mr_no,'Referral')
                          
                       test_booking_child1=TestBookingChild.find(:all,:conditions=>"test_booking_id = '#{test_booking.id}' and department like '#{lab}%'  and test_name like '#{service_name}%' ")
				refferal_doctor="" 
if(registration)
                        if(registration.referral_name!="")
			  				registration1=Registration.find_by_mr_no(test_booking.mr_no)
			    	  		refferal_doctor=registration1.referral_name
			    	  	end	
		        				

		        	  				for test_booking_child in test_booking_child1
		        	  				report.page.list(:list).add_row do |row|
		        	    			row.item(:s_no).value s_no
		        					row.item(:mr_no).value test_booking.mr_no
		        	    			row.item(:p_name).value test_booking.patient_name
		        	    			row.item(:age).value registration.age.to_s+"/"+registration.gender
		        	    			row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")+"/"+test_booking.created_at.strftime("%H:%M")
		        	    			row.item(:cons).value refferal_doctor
		        	    		    row.item(:test_name).value test_booking_child.test_name
		        	    			
		        	    			row.item(:paid_amt).value "%05.2f" % test_booking_child.amount
		        	    			total=total+test_booking_child.amount
		        	    		     end	
 end
		        	    end	
		        	    end	     
		        	    				s_no=s_no+1
					        	  		item(:count).value s_no-1 					 
					 					item(:total).value "%05.2f" % total
					 					item(:page_no).value 1
					 	  end
		        		
			 
			end
			
	end
		redirect_to("/reports/external/1?format=pdf")
 
end
def external
		send_file "app/views/reports/external.pdf", :type => "application/pdf", :disposition => 'inline'
end

def purchase_return
	end
	def purchase_return_report
	home=Home.last
	if(home)
	prawn_logo = "public/images/#{home.image_path}"

	else
	prawn_logo = "public/images/hs-gol.png"
	end
	  purchases = PurchaseOrderReturn.find(:all, :conditions=>"return_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchase_ret1.pdf') do
        use_layout'app/views/reports/purchasereturns.tlf'
        start_new_page do
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Purchase Return Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        net_amount=0
       
       
            for purchase in purchases

               
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:inv_no).value purchase.return_no
                     row.item(:date).value purchase.return_date.to_s
                     row.item(:customer).value purchase.agency_names
                     row.item(:city).value purchase.address.to_s
                     row.item(:net_amount).value  "%05.2f" % purchase.amount
                     
                	net_amount=net_amount+(purchase.amount.to_f)
           end
           
           

           s_no=s_no+1
           item(:count).value s_no-1           
           
           item(:net_amt1).value "%05.2f" % net_amount

           item(:page_no).value 1
          end 
        end   
           
   
    end
    redirect_to("/reports/purchase_ret1/1?format=pdf")
 end
     def purchase_ret1

      send_file "app/views/reports/purchase_ret1.pdf", :type => "application/pdf", :disposition => 'inline'
    end

    #--------------Sales Repport------------------------------
   
  
    def sale_report
    	home=Home.last
	if(home)
	prawn_logo = "public/images/#{home.image_path}"

	else
	prawn_logo = "public/images/hs-gol.png"
	end
	patient=params[:patient_name]

	issues = IssuesToOp.find(:all, :conditions=>"issue_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' and patient_name like '#{params[:patient_name]}%'")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/sales.pdf') do
        use_layout'app/views/reports/salesreport.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Sales Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        sub_total=0
        dis=0
        net_amount=0
      
        net_amount=0
       
            for issue in issues

                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:inv_no).value issue.receipt_no
                     row.item(:date).value issue.issue_date
                     row.item(:customer).value issue.patient_name
                     row.item(:sub_total).value issue.paid_amt.to_s
                     row.item(:dis).value issue.concession_amount.to_s
                     row.item(:net_amount).value issue.total_amount.to_s
                         
                    
                   		sub_total=sub_total+(issue.paid_amt)
                        dis=dis+(issue.concession_amount)
                        net_amount=net_amount+(issue.total_amount)
               
           end
            s_no=s_no+1
           

           
           item(:count).value s_no-1           
           item(:sub_total1).value "%05.2f" % sub_total
           item(:dis1).value "%05.2f" % dis
           item(:net_amt1).value "%05.2f" % net_amount
            item(:page_no).value 1
           end
          end 
    end
    redirect_to("/reports/sales/1?format=pdf")
 end
     def sales

      send_file "app/views/reports/sales.pdf", :type => "application/pdf", :disposition => 'inline'
    end

    #------------------------Sales By Invoice No-----------------------

    def sales_by_invoice
    end
    def sale_invoice_report
    	home=Home.last
	if(home)
	prawn_logo = "public/images/#{home.image_path}"

	else
	prawn_logo = "public/images/hs-gol.png"
	end
    	issues = IssuesToOp.find(:all, :conditions=>"receipt_no BETWEEN '#{params[:from_invoice]}' and '#{params[:to_invoice]}'")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/salesinvoice.pdf') do
        use_layout'app/views/reports/salesinvreport.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Sales Report by Invoice No"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        sub_total=0
        dis=0
        net_amount=0
      
        net_amount=0
       
            for issue in issues

                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:inv_no).value issue.receipt_no
                     row.item(:date).value issue.issue_date
                    row.item(:sub_total).value issue.paid_amt.to_s
                     row.item(:dis).value issue.concession_amount.to_s
                     row.item(:net_amount).value issue.total_amount.to_s
                     	sub_total=sub_total+(issue.paid_amt)
                        dis=dis+(issue.concession_amount)
                        net_amount=net_amount+(issue.total_amount)
               
           end
            s_no=s_no+1
            item(:count).value s_no-1           
           item(:sub_total1).value "%05.2f" % sub_total
           item(:dis1).value "%05.2f" % dis
           item(:net_amt1).value "%05.2f" % net_amount
           item(:page_no).value 1
          end 
      end
    end
    redirect_to("/reports/salesinvoice/1?format=pdf")
 end
     def salesinvoice

      send_file "app/views/reports/salesinvoice.pdf", :type => "application/pdf", :disposition => 'inline'
    end

#------------------------Doctor Wise Sales Register----------------------------------

def doctorwise_sales
	end
	def doctor_wise_sales
			home=Home.last
	if(home)
	prawn_logo = "public/images/#{home.image_path}"

	else
	prawn_logo = "public/images/hs-gol.png"
	end
	patient=params[:name]
	
	 	issues = IssuesToOp.find(:all, :conditions=>"issue_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND consultant LIKE '#{params[:name]}%'")
	
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/doctorwise.pdf') do
        use_layout'app/views/reports/doctorwise_salesreport.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Sales Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        sub_total=0
        dis=0
        net_amount=0
      
        net_amount=0
       
            for issue in issues

                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:inv_no).value issue.receipt_no
                     row.item(:doctor).value issue.consultant
                     row.item(:sub_total).value issue.paid_amt.to_s
                     row.item(:dis).value issue.concession_amount.to_s
                     row.item(:net_amount).value issue.total_amount.to_s
                     sub_total=sub_total+(issue.paid_amt)
                     dis=dis+(issue.concession_amount)
                     net_amount=net_amount+(issue.total_amount)
               
           end
            s_no=s_no+1
           
           item(:count).value s_no-1           
           item(:sub_total1).value "%05.2f" % sub_total
           item(:dis1).value "%05.2f" % dis
           item(:net_amt1).value "%05.2f" % net_amount

           item(:page_no).value 1
       end
          end 
    end
    redirect_to("/reports/doctorwise/1?format=pdf")
 end
     def doctorwise

      send_file "app/views/reports/doctorwise.pdf", :type => "application/pdf", :disposition => 'inline'
    end

    #-------------Doctor Wise Product Sales-------------------------------------

    def doctorwise_product_sales
    end
    def doctorwise_productsales
    			home=Home.last
	if(home)
	prawn_logo = "public/images/#{home.image_path}"

	else
	prawn_logo = "public/images/hs-gol.png"
	end
	patient=params[:name]
	if(patient)
	 	issues = IssuesToOp.find(:all, :conditions=>"issue_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND consultant LIKE '#{params[:name]}%'")
		else
	issues = IssuesToOp.find(:all, :conditions=>"issue_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/doctorwiseproduct.pdf') do
        use_layout'app/views/reports/doctorwiseproduct_report.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Doctor Wise Product Sales Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        sub_total=0
        dis=0
        net_amount=0
      
        net_amount=0
       
            for issue in issues
          issues_child=IssueOpChild.find(:all, :conditions=>"issues_to_op_id 	LIKE '#{issue.id}'")
               for child in issues_child
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:inv_no).value issue.receipt_no
                     row.item(:doctor).value issue.consultant
                    
                     row.item(:item).value child.item_name
                     
                     row.item(:sub_total).value issue.paid_amt.to_s
                     row.item(:dis).value issue.concession_amount.to_s
                     row.item(:net_amount).value issue.total_amount.to_s
                     sub_total=sub_total+(issue.paid_amt)
                     dis=dis+(issue.concession_amount)
                     net_amount=net_amount+(issue.total_amount)
              end 
           end
            s_no=s_no+1
           

           
           item(:count).value s_no-1           
           item(:sub_total1).value "%05.2f" % sub_total
           item(:dis1).value "%05.2f" % dis
           item(:net_amt1).value "%05.2f" % net_amount

           item(:page_no).value 1
          end 
    end
    end
    redirect_to("/reports/doctorwiseproduct/1?format=pdf")
 end
     def doctorwiseproduct

      send_file "app/views/reports/doctorwiseproduct.pdf", :type => "application/pdf", :disposition => 'inline'
    end

    #-------------------Monthly Sales--------------------------------------------

    def monthly_sales
    end
    def monthly_sales_report
    	home=Home.last
	if(home)
	prawn_logo = "public/images/#{home.image_path}"

	else
	prawn_logo = "public/images/hs-gol.png"
	end
    	issues = IssuesToOp.find(:all, :conditions=>"issue_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/monthlysales.pdf') do
        use_layout'app/views/reports/monthlysale.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Monthly Sales Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        sub_total=0
        dis=0
        net_amount=0
         adjust=0
         round=0
       
            for issue in issues

                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                
                     row.item(:date).value issue.issue_date
                     row.item(:sub_total).value issue.paid_amt.to_s
                     row.item(:dis).value issue.concession_amount.to_s
                     row.item(:net_amount).value issue.total_amount.to_s
                     row.item(:adj).value issue.adjust.to_s
                     row.item(:round).value issue.round.to_s    
                     sub_total=sub_total+(issue.paid_amt)
	                 dis=dis+(issue.concession_amount)
	                 net_amount=net_amount+(issue.total_amount)
                     adjust=adjust+(issue.adjust)
                     round=round+(issue.round)
           end
            s_no=s_no+1
           item(:count).value s_no-1           
           item(:sub_total1).value "%05.2f" % sub_total
           item(:dis1).value "%05.2f" % dis
           item(:net_amt1).value "%05.2f" % net_amount
			item(:adjust).value "%05.2f" % adjust
			item(:round).value "%05.2f" % round
           item(:page_no).value 1
          end 
          end
    end
    redirect_to("/reports/monthlysales/1?format=pdf")
 end
     def monthlysales

      send_file "app/views/reports/monthlysales.pdf", :type => "application/pdf", :disposition => 'inline'
    end
	 #-----------------Purchase Register Report-------------------------------------------

    
    def purchase_register_report
    home=Home.last
	if(home)
	prawn_logo = "public/images/#{home.image_path}"

	else
	prawn_logo = "public/images/hs-gol.png"
	end
	agency=params[:agency_name]
	if(agency)
	 	goods = Goodsrecieptnotemaster.find(:all, :conditions=>"invoice_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND agency_name LIKE '#{params[:agency_name]}%'")
		else
	goods = Goodsrecieptnotemaster.find(:all, :conditions=>"invoice_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchaseregister.pdf') do
        use_layout'app/views/reports/purchaseregister_report.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Purchase Register Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        sub_total=0
        dis=0
        net_amount=0
      
        net_amount=0
       
            for good in goods
          
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:inv_no).value good.invoice_number
                     row.item(:city).value good.address
                    row.item(:agency).value good.agency_name
                     row.item(:net_amount).value good.net_amount.to_s
                    
                     net_amount=net_amount+(good.net_amount)
            
           end
            s_no=s_no+1
           

           
           item(:count).value s_no-1           
           
           item(:net_amt1).value "%05.2f" % net_amount

           item(:page_no).value 1
          end 
    end
    end
    redirect_to("/reports/purchaseregister/1?format=pdf")
 end
     def purchaseregister

      send_file "app/views/reports/purchaseregister.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

    #---------------------Supplier Wise Purchase Report--------------------------------------------

    def supplier_wise_purchase
    end
    def supplierwise_purchase_report
    	home=Home.last
	if(home)
	prawn_logo = "public/images/#{home.image_path}"

	else
	prawn_logo = "public/images/hs-gol.png"
	end
	agency=params[:agency_name]
	if(agency)
	 	goods = Goodsrecieptnotemaster.find(:all, :conditions=>"invoice_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND agency_name LIKE '#{params[:agency_name]}%'")
		else
	goods = Goodsrecieptnotemaster.find(:all, :conditions=>"invoice_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/supplier_wisepurchase.pdf') do
        use_layout'app/views/reports/supplier_wisepurchase_rp.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Supplier Wise Purchase Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        sub_total=0
        discount=0
        net_amount=0
      
       gross=0
       
            for good in goods
          
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:inv_no).value good.invoice_number
                     row.item(:city).value good.address
                     row.item(:date).value good.invoice_date	
                     row.item(:agency).value good.agency_name
                     row.item(:gross).value good.net_invoice_amount
                     row.item(:dis).value good.dis_amount
                     row.item(:net_amt).value good.net_amount.to_s
                    gross=gross+(good.net_invoice_amount)
                    discount=discount+(good.dis_amount)
                     net_amount=net_amount+(good.net_amount)
            
           end
            s_no=s_no+1
            item(:count).value s_no-1           
           item(:gro).value "%05.2f" % gross
           item(:discount).value "%05.2f" % discount
           item(:net_amount).value "%05.2f" % net_amount
           item(:page_no).value 1
          end 
    end
    end
    redirect_to("/reports/supplier_wisepurchase/1?format=pdf")
 end
     def supplier_wisepurchase

      send_file "app/views/reports/supplier_wisepurchase.pdf", :type => "application/pdf", :disposition => 'inline'
    end	
    
    #-----------------------Supplier Wise Product Purchase----------------------------------------
   
    def supplierwise_productpurchase_report
    	home=Home.last
	if(home)
	prawn_logo = "public/images/#{home.image_path}"

	else
	prawn_logo = "public/images/hs-gol.png"
	end
	agency=params[:agency_name]
	if(agency)
	 	goods = Goodsrecieptnotemaster.find(:all, :conditions=>"invoice_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND agency_name LIKE '#{params[:agency_name]}%'")
		else
	goods = Goodsrecieptnotemaster.find(:all, :conditions=>"invoice_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/supplierwise_productpurchase.pdf') do
        use_layout'app/views/reports/supplier_wise_pp.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Supplier Wise Purchase Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        free=0
        rate=0
        quantity=0
        net_amount=0
      
            for good in goods
          store_child=StoreChild.find(:all, :conditions=>"goodsrecieptnotemaster_id LIKE '#{good.id}'")
                for store in store_child
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:invno).value good.invoice_number
                    
                     row.item(:date).value good.invoice_date	
                     row.item(:supply).value good.agency_name
                     row.item(:product).value store.item_name
                     row.item(:batch).value store.batch_no
                     row.item(:pack).value store.packing
                     row.item(:qty).value store.quantity.to_s
                     row.item(:free).value store.free.to_s
                     row.item(:expdt).value store.sale_rate.to_s
                     row.item(:amt).value good.net_amount.to_s
                    free=free+(store.free.to_f)
                    rate=rate+(store.sale_rate.to_f)
                    quantity=quantity+(store.quantity.to_f)
                     net_amount=net_amount+(good.net_amount.to_f)
            
           end
            s_no=s_no+1
            item(:count).value s_no-1           
           item(:free).value "%05.2f" % free
           item(:rate).value "%05.2f" % rate
           item(:quantity).value "%05.2f" % quantity
           item(:net_amount).value "%05.2f" % net_amount
           item(:page_no).value 1
          end 
    end
end
    end
    redirect_to("/reports/supplierwise_productpurchase/1?format=pdf")
 end
     def supplierwise_productpurchase

      send_file "app/views/reports/supplierwise_productpurchase.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

# end of chythu reports
# rajshekar reports starts


def product_wise__supplier_list
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
item_name=params[:item_name]
 
require 'rubygems'
  	require 'thinreports'
   ThinReports::Report.generate_file('app/views/reports/product_wise_supplier.pdf') do
    use_layout 'app/views/reports/product_wise_supplier1.tlf'
    start_new_page do
        	 org_master_child=OrgMasterChildTable.last
        	
        	 item(:image).value prawn_logo
        	   	 item(:address1).value org_master_child.address.split(";")[0]
            	item(:address2).value org_master_child.address.split(";")[1]
            	item(:address3).value org_master_child.address.split(";")[2]
            	item(:address4).value org_master_child.address.split(";")[3]     
             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
             	item(:report_name).value "Productwise Supplier List Report"

             	s_no=1
             	total=0
item_names=StoreChild.find(:all, :conditions=>"item_name like '#{item_name}%'")

  	for item in item_names
good_receipt=Goodsrecieptnotemaster.find_by_id(item.goodsrecieptnotemaster_id)
agency_master=""
if(good_receipt)
agency_master1=AgencyMaster.find_by_agency_name(good_receipt.agency_name)
agency_master=agency_master1.contact_no.to_s
end
  	  	report.page.list(:list).add_row do |row|
        	    	 row.item(:s_no).value s_no
        	    	 row.item(:product).value item.item_name
        	    	 row.item(:supplier).value good_receipt.agency_name
        	    	 row.item(:city).value good_receipt.address
        	    	 row.item(:phone).value agency_master

			row.item(:mrp).value item.mrp
			  total=total+item.mrp
        	    end
        	  	 s_no=s_no+1
        	  	 item(:count).value s_no-1 	
        	  	 item(:page_no).value 1
        		 item(:total).value "%05.2f" % total
        	 end


  end
end
redirect_to("/reports/product_wise_supplier/1?format=pdf")	
end 
def product_wise_supplier

      send_file "app/views/reports/product_wise_supplier.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def expiry_product_list1
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end


 store_children = StoreChild.find(:all, :conditions=>"expiry_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/expiry_product_list21.pdf') do
        use_layout'app/views/reports/expiry_product_list1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Expiry Product List Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total1=0
        total2=0
       
            for store_child in store_children
                item_name1=Itemmaster.find_by_product_name(store_child.item_name)
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value store_child.item_name
                     row.item(:batch_no).value store_child.batch_no
                     row.item(:packing).value store_child.packing
                     row.item(:expiry_date).value store_child.expiry_date
                     comp=""
                     if(item_name1)
                     	comp=item_name1.manufacturer
                     end
                     row.item(:company).value comp
                    
                      row.item(:qty).value store_child.quantity
                      row.item(:mrp).value store_child.mrp   
              total_qty=(store_child.quantity.to_f)*(store_child.mrp.to_f)
                     row.item(:total).value total_qty.to_s
                    total1=total1+((store_child.quantity.to_f)*(store_child.mrp.to_f))
                end
            end

           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total1

           item(:page_no).value 1
          end 
           
           
   
    end
    redirect_to("/reports/expiry_product_list21/1?format=pdf")
 end
     def expiry_product_list21

      send_file "app/views/reports/expiry_product_list21.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def sales_return1
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end


 op_patient_returns = OpPatientReturn.find(:all, :conditions=>"return_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/sales_returns_report12.pdf') do
        use_layout'app/views/reports/sales_returns_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Sales Return Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total1=0
        total2=0
       
            for op_patient_return in op_patient_returns
                issues_to_op=IssuesToOp.find_by_receipt_no(op_patient_return.receipt_no)
            
                  report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:date).value op_patient_return.return_date
                     row.item(:inv_no).value op_patient_return.receipt_no
                     row.item(:cos_name).value issues_to_op.patient_name.to_s
                     
                     row.item(:age).value issues_to_op.age.to_s
                     row.item(:total).value op_patient_return.paid_amt.to_s
                    
                    total1=total1+((op_patient_return.paid_amt))
                end
s_no=s_no+1
            end

           
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total1

           item(:page_no).value 1
          end 
           
           
   
    end
    redirect_to("/reports/sales_returns_report12/1?format=pdf")
 end
     def sales_returns_report12

      send_file "app/views/reports/sales_returns_report12.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def datewise_payment_report11
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end


  pharmacy_payments = PharmacyPayment.find(:all, :conditions=>"payment_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' and agency_name Like '#{params[:agency_name]}%'")

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/datewise_payment_report12.pdf') do
        use_layout'app/views/reports/datewise_payment_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "DateWise Payment Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        gross=0
        adjust=0
        total_vat=0
        round=0
        net_amount=0
       
            for pharmacy_payment in pharmacy_payments
pharmacy_payment_children=PharmacyPaymentChild.find(:all, :conditions=>"pharmacy_payment_id='#{pharmacy_payment.id}' AND balance=0")
                for pharmacy_payment_child in pharmacy_payment_children 

                goodsrecieptnotemaster =Goodsrecieptnotemaster.find_by_invoice_number(pharmacy_payment_child.invoice_no)
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:date).value pharmacy_payment.payment_date
                     row.item(:inv_no).value pharmacy_payment_child.invoice_no
                     row.item(:supplier).value pharmacy_payment.agency_name.to_s
                     
                     row.item(:gross).value goodsrecieptnotemaster.sub_total.to_s

                     row.item(:adjust).value goodsrecieptnotemaster.adjust.to_s
                     row.item(:vat).value goodsrecieptnotemaster.total_vat.to_s
                         row.item(:round).value goodsrecieptnotemaster.round.to_s
                         row.item(:total).value goodsrecieptnotemaster.net_amount.to_s
                         
                    
                   		gross=gross+(goodsrecieptnotemaster.sub_total)
                        adjust=adjust+(goodsrecieptnotemaster.adjust)
                        total_vat=total_vat+(goodsrecieptnotemaster.total_vat)
                        round=round+(goodsrecieptnotemaster.round)
                        net_amount=net_amount+(goodsrecieptnotemaster.net_amount)
                end
                end

            end

           s_no=s_no+1
           item(:count).value s_no-1           
           item(:gross1).value "%05.2f" % gross
item(:adjust1).value "%05.2f" % adjust
item(:total_vat).value "%05.2f" % total_vat
item(:round1).value "%05.2f" % round
item(:net_amt1).value "%05.2f" % net_amount

           item(:page_no).value 1
          end 
           
           
   
    end
    redirect_to("/reports/datewise_payment_report12/1?format=pdf")
 end
     def datewise_payment_report12

      send_file "app/views/reports/datewise_payment_report12.pdf", :type => "application/pdf", :disposition => 'inline'
    end



def sales_vat_report1

home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end


  issues_to_ops = IssuesToOp.find(:all, :conditions=>"issue_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/sales_vat_report12.pdf') do
        use_layout'app/views/reports/sales_vat_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Sales Vat Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        sub_total=0
        dis=0
        vat=0
      
        net_amount=0
       
            for issues_to_op in issues_to_ops
issues_to_op_children=IssueOpChild.find(:all, :conditions=>"issues_to_op_id='#{issues_to_op.id}'")
   reg=Registration.find_by_mr_no(issues_to_op.mr_no)          
                 for issues_to_op_child in issues_to_op_children
              
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:inv_no).value issues_to_op.receipt_no
                     row.item(:date).value issues_to_op.issue_date
                     row.item(:customer).value issues_to_op.patient_name.to_s
                     if(reg)
                     row.item(:city).value reg.address.to_s
                     end
                     row.item(:sub_total).value issues_to_op.total_amount.to_s
                     row.item(:dis).value issues_to_op.concession_amount.to_s
                         row.item(:vat).value issues_to_op_child.vat.to_s
                         row.item(:net_amount).value issues_to_op.paid_amt.to_s
                         
                    
                   		sub_total=sub_total+(issues_to_op.total_amount)
                        dis=dis+(issues_to_op.concession_amount)
                        vat=vat+(issues_to_op_child.vat)
                       
                        net_amount=net_amount+(issues_to_op.paid_amt)
                end

                s_no=s_no+1

           end
           end

           
           item(:count).value s_no-1           
           item(:sub_total1).value "%05.2f" % sub_total
item(:dis1).value "%05.2f" % dis
item(:vat1).value "%05.2f" % vat

item(:net_amt1).value "%05.2f" % net_amount

           item(:page_no).value 1
          end 
           
           
   
    end
    redirect_to("/reports/sales_vat_report12/1?format=pdf")
 end
     def sales_vat_report12

      send_file "app/views/reports/sales_vat_report12.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def purchase_vat_report1

home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end


  goodsrecieptnotemasters = Goodsrecieptnotemaster.find(:all, :conditions=>"invoice_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchase_vat_report12.pdf') do
        use_layout'app/views/reports/purchase_vat_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Purchase Vat Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        sub_total=0
        dis=0
        vat=0
      
        net_amount=0
       
            for goodsrecieptnotemaster in goodsrecieptnotemasters
store_children=StoreChild.find(:all, :conditions=>"goodsrecieptnotemaster_id='#{goodsrecieptnotemaster.id}'")
               
               
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:inv_no).value goodsrecieptnotemaster.invoice_number
                     row.item(:date).value goodsrecieptnotemaster.invoice_date.to_s
                     row.item(:customer).value goodsrecieptnotemaster.agency_name
                    
                     row.item(:city).value goodsrecieptnotemaster.address.to_s
                   
                     row.item(:sub_total).value goodsrecieptnotemaster.sub_total.to_s
                     row.item(:dis).value goodsrecieptnotemaster.dis_amount.to_s
                         row.item(:vat).value (goodsrecieptnotemaster.total_vat.to_f).to_s
                         row.item(:net_amount).value goodsrecieptnotemaster.net_amount.to_s
                         
                    
                   		sub_total=sub_total+(goodsrecieptnotemaster.sub_total.to_f)
                        dis=dis+(goodsrecieptnotemaster.dis_amount.to_f)
                        vat=vat+(goodsrecieptnotemaster.total_vat.to_f)
                       
                        net_amount=net_amount+(goodsrecieptnotemaster.net_amount.to_f)
                
           end
s_no=s_no+1
           end

           
           item(:count).value s_no-1           
           item(:sub_total1).value "%05.2f" % sub_total
item(:dis1).value "%05.2f" % dis
item(:vat1).value "%05.2f" % vat

item(:net_amt1).value "%05.2f" % net_amount

           item(:page_no).value 1
          end 
           
           
   
    end
    redirect_to("/reports/purchase_vat_report12/1?format=pdf")
 end
     def purchase_vat_report12

      send_file "app/views/reports/purchase_vat_report12.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def customer_patient_wise_product_list_report1
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end


  issues_to_ops = IssuesToOp.find(:all, :conditions=>"issue_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' and patient_name like '#{params[:patient_name]}%' and mr_no like '#{params[:mr_no]}%' ")

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/customer_patient_wise_product_list_report12.pdf') do
        use_layout'app/views/reports/customer_patient_wise_product_list_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Customer/Patient Wise Product List Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        gross1=0
        dis=0
        net_amount=0
       
            for issues_to_op in issues_to_ops
issues_op_children=IssueOpChild.find(:all, :conditions=>"issues_to_op_id='#{issues_to_op.id}'")
                 for issues_op_child in issues_op_children
               
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:patient_name).value issues_to_op.patient_name
                 if(issues_to_op.admn_no!="")
                     row.item(:mr_no).value issues_to_op.mr_no.to_s+"/"+issues_to_op.admn_no.to_s
                 else
                     row.item(:mr_no).value issues_to_op.mr_no.to_s+"           "
                 end
                     row.item(:item_name).value issues_op_child.item_name
                    gross=(issues_op_child.total).to_f+((issues_op_child.total.to_f)*(issues_op_child.discount.to_f)/100)
                     row.item(:gross).value gross.to_s
                   
                     row.item(:dis).value issues_op_child.discount.to_s
                        row.item(:net_amount).value issues_op_child.total.to_s
                         
                    
                   		gross1=gross1+(gross)
                        dis=dis+(issues_op_child.discount.to_f)
                        net_amount=net_amount+(issues_op_child.total.to_f)
                end
           end
			s_no=s_no+1
           item(:count).value s_no-1             
           end

           s_no=s_no+1
           item(:count).value s_no-1           
           item(:gross1).value "%05.2f" % gross1
item(:dis1).value "%05.2f" % dis
item(:net_amt1).value "%05.2f" % net_amount

           item(:page_no).value 1
          end 
           
           
   
    end
    redirect_to("/reports/customer_patient_wise_product_list_report12/1?format=pdf")
 end
     def customer_patient_wise_product_list_report12

      send_file "app/views/reports/customer_patient_wise_product_list_report12.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def companywise_product_list1
	home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end


  manufacturers = Itemmaster.find(:all, :conditions=>"manufacturer like '#{params[:manufacturer]}%' ")

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/companywise_product_list12.pdf') do
        use_layout'app/views/reports/companywise_product_list1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Companywise Product List Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        gross1=0
        dis=0
        net_amount=0
       
            for manufacturer in manufacturers
               
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:manufacturer).value manufacturer.manufacturer
                     row.item(:product_name).value manufacturer.product_name
                     row.item(:package).value manufacturer.packing
                   
             
           end
           s_no=s_no+1
           item(:count).value s_no-1           
          
		   end

          
           item(:page_no).value 1
          end 
           
           
   
    end
    redirect_to("/reports/companywise_product_list12/1?format=pdf")
 end
     def companywise_product_list12

      send_file "app/views/reports/companywise_product_list12.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def categorywise_report1
	home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end


  drug_types = StoreChild.find(:all, :conditions=>"drug_type like '#{params[:drug_type]}%' ")

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/categorywise_report12.pdf') do
        use_layout'app/views/reports/categorywise_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Categorywise Stock List Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        gross1=0
        dis=0
        net_amount=0
       
            for drug_type in drug_types
               goodsrecieptnotemaster=Goodsrecieptnotemaster.find_by_id(drug_type.goodsrecieptnotemaster_id)
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:drug_type).value drug_type.drug_type
                     row.item(:product_name).value drug_type.item_name
                     row.item(:stock).value drug_type.quantity
                   row.item(:pur_rate).value drug_type.purchase_rate
                   row.item(:mrp).value drug_type.mrp
                   row.item(:supplier).value goodsrecieptnotemaster.agency_name
             
           end
           s_no=s_no+1
           item(:count).value s_no-1           
          
		   end

          
           item(:page_no).value 1
          end 
           
           
   
    end
    redirect_to("/reports/categorywise_report12/1?format=pdf")
 end
     def categorywise_report12

      send_file "app/views/reports/categorywise_report12.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

    def productwise_stock_report1


	home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end


  drug_types = StoreChild.find(:all, :conditions=>"item_name like '#{params[:product]}%' ")

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/productwise_stock_report12.pdf') do
        use_layout'app/views/reports/productwise_stock_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Productwise Stock Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        gross1=0
        dis=0
        net_amount=0
       
            for drug_type in drug_types
               goodsrecieptnotemaster=Goodsrecieptnotemaster.find_by_id(drug_type.goodsrecieptnotemaster_id)
               item_name=Itemmaster.find_by_product_name(drug_type.item_name)
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                    
                     row.item(:product).value drug_type.item_name
                     row.item(:batch_no).value drug_type.batch_no
                   row.item(:exp_date).value drug_type.expiry_date
                   row.item(:units).value item_name.units
                   row.item(:quntity).value drug_type.quantity
             row.item(:pur_rate).value drug_type.purchase_rate
             row.item(:mrp).value drug_type.mrp
             row.item(:supplier).value goodsrecieptnotemaster.agency_name
           end
           s_no=s_no+1
           item(:count).value s_no-1           
          
		   end

          
           item(:page_no).value 1
          end 
           
           
   
    end
    redirect_to("/reports/productwise_stock_report12/1?format=pdf")
 end
     def productwise_stock_report12

      send_file "app/views/reports/productwise_stock_report12.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

def datewise_purchases1
home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end


  goodsrecieptnotemasters = Goodsrecieptnotemaster.find(:all, :conditions=>"invoice_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")

      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/datewise_purchases12.pdf') do
        use_layout'app/views/reports/datewise_purchases1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "DateWise Purchase Report"
           item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        round=0
        dis=0
        vat=0
      gross=0
      cr_note=0
      dr_note=0
      adjust=0

        net_amount=0
       
            for goodsrecieptnotemaster in goodsrecieptnotemasters
store_children=StoreChild.find(:all, :conditions=>"goodsrecieptnotemaster_id='#{goodsrecieptnotemaster.id}'")
               
                
                report.page.list(:list).add_row do |row|    

                     row.item(:s_no).value s_no
                     row.item(:date).value goodsrecieptnotemaster.invoice_date.to_s
                     row.item(:gross).value goodsrecieptnotemaster.sub_total
                    
                     row.item(:cr_note).value goodsrecieptnotemaster.cr_note.to_s
                   
                     row.item(:dr_note).value goodsrecieptnotemaster.dr_note.to_s
                     row.item(:adjust).value goodsrecieptnotemaster.adjust.to_s
                         row.item(:dis).value goodsrecieptnotemaster.dis_amount.to_s
                         row.item(:vat).value goodsrecieptnotemaster.total_vat.to_s
                         row.item(:round).value goodsrecieptnotemaster.round.to_s
                         row.item(:net_amount).value goodsrecieptnotemaster.net_amount.to_s

                    
                   		gross=gross+(goodsrecieptnotemaster.sub_total.to_f)
                        dis=dis+(goodsrecieptnotemaster.dis_amount.to_f)
                        vat=vat+(goodsrecieptnotemaster.total_vat.to_f)
                        cr_note=cr_note+(goodsrecieptnotemaster.cr_note.to_f)

                        dr_note=dr_note+(goodsrecieptnotemaster.dr_note.to_f)
                        adjust=adjust+(goodsrecieptnotemaster.adjust.to_f)

                        round=round+(goodsrecieptnotemaster.round.to_f)
                        net_amount=net_amount+(goodsrecieptnotemaster.net_amount.to_f)
                
           end
           end

           s_no=s_no+1
           item(:gross1).value "%05.2f" % gross
item(:dis1).value "%05.2f" % dis
item(:vat1).value "%05.2f" % vat
item(:cr_note1).value "%05.2f" % cr_note
item(:dr_note1).value "%05.2f" % dr_note
item(:adjust1).value "%05.2f" % adjust
item(:round1).value "%05.2f" % round
item(:net_amount1).value "%05.2f" % net_amount

           item(:page_no).value 1
          end 
           
           
   
    end
    redirect_to("/reports/datewise_purchases12/1?format=pdf")
 end
     def datewise_purchases12

      send_file "app/views/reports/datewise_purchases12.pdf", :type => "application/pdf", :disposition => 'inline'
    end

#end of rajshekar 
# sales thin report by chaythanya
def sales_thin_report
 issue = IssuesToOp.find(params[:id])
 home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end

    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/salesthin.pdf') do
        use_layout'app/views/reports/sale_18.tlf'
        
        start_new_page do
             org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
       
                
            s_no=1
            total=0
            total2=0
            total1=0
           
              
        
                salechild= IssueOpChild.find(:all,:conditions=>"issues_to_op_id='#{issue.id}'") 
                for child in salechild
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value child.item_name   
                     row.item(:batch).value child.batch_no
                     row.item(:expiry).value child.expiry_date
                     row.item(:amt).value child.total
                     row.item(:mfg).value ""
                      row.item(:sch).value ""
                      row.item(:qty).value child.issue_qty
                     row.item(:rate).value child.sale_rate
                     
                 end  
                item(:gross).value issue.total_amount 
             item(:bill).value issue.receipt_no
              item(:patient).value issue.title+"."+issue.patient_name
              item(:doctor).value issue.consultant 
               item(:date).value issue.issue_date
     
  s_no=s_no+1
              end
           
            
                     
      end       
      
    end
    redirect_to("/reports/salesthin/1?format=pdf") 
 end
     def salesthin

      send_file "app/views/reports/salesthin.pdf", :type => "application/pdf", :disposition => 'inline'
    end


def purchase_invoice_20
      
  sale = Goodsrecieptnotemaster.find_by_id(params[:id])
  home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchaseinvoice.pdf') do
        use_layout'app/views/reports/product_invoice20.tlf'
        
        start_new_page do
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
       
            s_no=1
            total=0
            total2=0
            total1=0
            purchasechild=StoreChild.find(:all,:conditions=>"goodsrecieptnotemaster_id='#{sale.id}'") 
               
                for child in purchasechild
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value child.item_name   
                     row.item(:batch).value child.batch_no
                     row.item(:expdt).value child.expiry_date
                     row.item(:amt).value "%05.2f" % child.amount
                     row.item(:mrp).value "%05.2f" % child.mrp
                     row.item(:vat).value child.vat
                     row.item(:mfg).value ""
                      row.item(:pack).value child.packing
                      row.item(:qty).value child.quantity
                     row.item(:rate).value "%05.2f" % child.purchase_rate
                     
                 end  
                 s_no=s_no+1
                 item(:item_no).value s_no-1      
                item(:date).value sale.invoice_date
                item(:tin).value sale.entry_no
                item(:name).value sale.agency_name
                item(:text).value sale.invoice_number
                item(:dl).value sale.address
                item(:inv_no).value sale.entry_date
                item(:sub).value "%05.2f" % sale.sub_total
                item(:dis).value "%05.2f" % sale.discount
                item(:vat).value "%05.2f" % sale.total_vat
                item(:tot).value "%05.2f" % sale.net_amount
              end
      
    end
      
    end
    redirect_to("/reports/purchaseinvoice/1?format=pdf") 
 	end
   def purchaseinvoice
      send_file "app/views/reports/purchaseinvoice.pdf", :type => "application/pdf", :disposition => 'inline'
    end

	 def payment_thin_report
  
  		payment =PharmacyPayment.find_by_id(params[:id])
 home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
 
  		require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/payment.pdf') do
        use_layout'app/views/reports/payment21.tlf'
        
        start_new_page do
             org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]        
                
            s_no=1
            total=0
            total2=0
            total1=0
           paymentchild=PharmacyPaymentChild.find(:all,:conditions=>"pharmacy_payment_id LIKE '#{payment.id}'") 
             
                for child in paymentchild
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:bill).value child.invoice_no 
                     row.item(:discount).value child.discount
                     row.item(:date).value  child.invoice_date
				row.item(:paid).value "%05.2f" % child.received
                     row.item(:amt).value "%05.2f" % child.amount
                    
                    
                     
                 end  
                
                      s_no=s_no+1
                 item(:item_no).value s_no-1      
                item(:date).value payment.payment_date
              
                item(:name).value payment.agency_name
            
                item(:pay_no).value payment.payment_no 
                item(:total).value "%05.2f" % payment.net_amount 
                item(:gross).value "%05.2f" % payment.gross
          
                item(:adj).value payment.adjust
               
              end
      
    end
      
    end
    redirect_to("/reports/payment/1?format=pdf") 
   end
     def payment

      send_file "app/views/reports/payment.pdf", :type => "application/pdf", :disposition => 'inline'
    end



def sales_thin_report_return
 issue = OpPatientReturn.find(params[:id])
 home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end

    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/salesthin_return.pdf') do
        use_layout'app/views/reports/sale_19.tlf'
        
        start_new_page do
             org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            s_no=1
            total=0
            total2=0
            total1=0

        
                salechild= OpreturnChild.find(:all,:conditions=>"op_patient_return_id='#{issue.id}'") 
                for child in salechild
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value child.item_name   
                     row.item(:batch).value child.batch_no
                     row.item(:expiry).value child.expiry_date
                     row.item(:amt).value  "%05.2f" % child.return_amt
                     row.item(:mfg).value ""
                      row.item(:sch).value ""
                      row.item(:qty).value child.return_qty
                     row.item(:rate).value "%05.2f" % child.return_rate
                     
                 end  
if(issue)
	patient_name=Registration.find_by_mr_no(issue.mr_No)
end
                item(:gross).value  "%05.2f" % issue.return_amount
             item(:bill).value issue.return_no
              item(:patient).value patient_name.title+"."+issue.patient_name
			  item(:date).value issue.return_date
  s_no=s_no+1
              end
       
      end       
      
    end
    redirect_to("/reports/salesthin_return/1?format=pdf") 
 end

 def salesthin_return

      send_file "app/views/reports/salesthin_return.pdf", :type => "application/pdf", :disposition => 'inline'
    end

def purchase_invoice_20_return
      
  sale = PurchaseOrderReturn.find_by_id(params[:id])
  home=Home.last
if(home)
prawn_logo = "public/images/#{home.image_path}"

else
prawn_logo = "public/images/hs-gol.png"
end
    
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/purchaseinvoice_return.pdf') do
        use_layout'app/views/reports/product_invoice20_return.tlf'
        
        start_new_page do
            org_master_child=OrgMasterChildTable.last
            item(:image).value prawn_logo
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
       
            s_no=1
            total=0
            total2=0
            total1=0
            purchasechild=PurchaseOrderReturnChild.find(:all,:conditions=>"purchase_order_return_id='#{sale.id}'") 
               
                for child in purchasechild
                     report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:product).value child.item_name   
                     row.item(:batch).value child.batch_no
                     row.item(:expdt).value child.expiry_date
                     row.item(:amt).value  "%05.2f" % child.return_amt
                     row.item(:mrp).value   "%05.2f" % child.purchase_rate
                     row.item(:mfg).value ""
                      row.item(:qty).value child.return_qty
                     row.item(:rate).value  "%05.2f" % child.return_rate
                     
                 end  
                 s_no=s_no+1
                
                item(:date).value sale.return_date
                item(:name).value sale.agency_names
                item(:inv_no).value sale.return_no
                item(:total_amt).value  "%05.2f" % sale.amount

              end
      
    end
      
    end
    redirect_to("/reports/purchaseinvoice_return/1?format=pdf") 
 	end
   def purchaseinvoice_return
      send_file "app/views/reports/purchaseinvoice_return.pdf", :type => "application/pdf", :disposition => 'inline'
    end


end
