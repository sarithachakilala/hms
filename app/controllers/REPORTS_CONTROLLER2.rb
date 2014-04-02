class ReportsController < ApplicationController

def ajax_buildings2
	mr1=params[:q1]
	type=params[:type]
	if(type=="lab_department")
		@tests=Testmaster.find(:all, :conditions=>" department_name	 LIKE '#{mr1}' ")
		str=""
		for tests in @tests
			str<<tests.test_name+"<division>"
		end
		render :text=>str	
	end

end
	def test_wise
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
 item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]     
             item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
              item(:report_name).value "Test Wise Bookings"

        	 item(:image).value "public/images/exleaz.png"
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
        	    	 row.item(:status).value test_booking_child.status
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
		        				item(:image).value "public/images/exleaz.png"
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
		        	    			row.item(:status).value test_booking_child.status
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
		from_date=params[:from_date]
		to_date=params[:to_date]
		service_name=params[:service]
		lab=params[:lab_department]
		consultant=params[:consultant]
		@name =EmployeeMaster.find_by_empid(consultant)
if(from_date!="" && to_date!="" && consultant!="" )
	query=["booking_date  BETWEEN ? AND ?  AND  refferal_doctor LIKE '#{@name.name}' ", from_date,to_date]
elsif(from_date!="" && to_date!="" )
	query=["booking_date  BETWEEN ? AND ? ", from_date,to_date]
end
test_bookings=TestBooking.find(:all, :conditions=> query)
		require 'rubygems'
		  		require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/external.pdf') do
				    use_layout 'app/views/reports/doctorwise_labrefunds.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value "public/images/exleaz.png"
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "External Doctorwise Lab Referals"
				             	s_no=1
				             	total=0
		        		for test_booking in test_bookings
		        			for test_booking_child in test_booking.test_booking_child
		        	  				report.page.list(:list).add_row do |row|
		        	    			row.item(:s_no).value s_no
		        					row.item(:mr_no).value test_booking.mr_no
		        	    			reg=Registration.find_by_mr_no(test_booking.mr_no)
		        	    			row.item(:p_name).value test_booking.patient_name
		        	    			row.item(:age).value reg.age.to_s+"/"+reg.gender
		        	    			row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")+"/"+test_booking.created_at.strftime("%H:%M")
		        	    			row.item(:cons).value test_booking.refferal_doctor
		        	    			row.item(:test_name).value test_booking_child.test_name
		        	    			row.item(:status).value test_booking_child.status

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
		redirect_to("/reports/external/1?format=pdf")
 
end

def external
		send_file "app/views/reports/external.pdf", :type => "application/pdf", :disposition => 'inline'
end

def in_doctorwise_lab
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
		        		
		        				item(:image).value "public/images/exleaz.png"
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
		        		
		        				item(:image).value "public/images/exleaz.png"
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
		        		
		        				item(:image).value "public/images/exleaz.png"
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
						        	    			row.item(:mr_no).value test_booking.admn_no
						        	    			row.item(:p_name).value test_booking.patient_name
						        	    					reg=Registration.find_by_mr_no(test_booking.mr_no)	
						        	    			row.item(:age).value reg.age.to_s+"/"+reg.gender
						        	    			row.item(:case).value test_booking.patient_type
													row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")+"/"+test_booking.created_at.strftime("%H:%M")
					        						row.item(:test_name).value test_booking_child.department
					        						row.item(:status).value test_booking_child.status
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
		from_date=params[:from_date]
		to_date=params[:to_date]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/daily.pdf') do
				    use_layout 'app/views/reports/daily_lab.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value "public/images/exleaz.png"
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Daily Lab Revenue"
				             	s_no=1
				             	total=0
	test_bookings=TestBooking.find(:all,:conditions => "	booking_date BETWEEN '#{from_date}' AND '#{to_date}' ")
						  	for test_booking in test_bookings
				        	  		report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:date).value test_booking.booking_date.strftime("%d-%m-%Y")
		        							row.item(:paid_amt).value "%05.2f" % test_booking.paid_amount
		        						total=total+test_booking.paid_amount
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
	from_date=params[:from_date]
		to_date=params[:to_date]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/casuality_coll.pdf') do
				    use_layout 'app/views/reports/casuality.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value "public/images/exleaz.png"
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
	consultant=params[:consultant]
	from_date=params[:from_date]
	to_date=params[:to_date]
	require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/doctorwise_srgry.pdf') do
				    use_layout 'app/views/reports/doctorwise_srgry.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value "public/images/exleaz.png"
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
	patient_name=params[:patient_name]
	from_date=params[:from_date]
	to_date=params[:to_date]
	require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/patientwise_srgry.pdf') do
				    use_layout 'app/views/reports/patientwise_srgry.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value "public/images/exleaz.png"
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
		from_date=params[:from_date]
		to_date=params[:to_date]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/surgery.pdf') do
				    use_layout 'app/views/reports/srgry_revenues.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value "public/images/exleaz.png"
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
		        		
		        				item(:image).value "public/images/exleaz.png"
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Patientwise Advances"
				
				             	s_no=1
				             	total=0
	advancepaymets=AdvancePayment.find(:all, :conditions =>" advance_date BETWEEN '#{from_date}' AND '#{to_date}' AND admn_no LIKE '#{admn_no}' ")
						  	for advancepaymet in advancepaymets
	admission=Admission.last(:conditions=>"admn_no LIKE '#{advancepaymet.admn_no}%' AND patient_name LIKE '#{patient_name}%' " )
						  			report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:admn_no).value advancepaymet.admn_no
				        	    			row.item(:patient_name).value admission.patient_name
				        	    			row.item(:age).value admission.age.to_s+"/"+admission.gender
				        	    			row.item(:admn_date).value admission.admn_date.strftime("%d-%m-%Y")
				        	    			row.item(:ward).value admission.ward
				        	    			row.item(:total1).value "%05.2f" % advancepaymet.gross_amount	
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
		redirect_to("/reports/advances/1?format=pdf")	
end 
def advances
	send_file "app/views/reports/advances.pdf", :type => "application/pdf", :disposition => 'inline'
end
def patientwise_finalbills
end
def patientwise_final
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
		        		
		        				item(:image).value "public/images/exleaz.png"
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
				        	    			row.item(:due).value "%05.2f" % final_bill.due 
											total=total+final_bill.paid_amount
		        	  					end
		        	  				s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1
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
		        		
		        				item(:image).value "public/images/exleaz.png"
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Patientwise Final Bills"
				
				             	s_no=1
				             	total=0
				ipdues=IpDue.find(:all, :conditions =>" due_date BETWEEN '#{from_date}' AND '#{to_date}' ")
						  	for ipdue in ipdues
								admission=Admission.last(:conditions=>"admn_no LIKE '#{ipdue.admn_no}%' AND patient_name LIKE '#{patient_name}%' " )
						  			report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:admn_no).value ipdue.admn_no
				        	    			row.item(:patient_name).value admission.patient_name
				        	    			row.item(:age).value admission.age.to_s+"/"+admission.gender
				        	    			row.item(:admn_date).value admission.admn_date.strftime("%d-%m-%Y")
				        	    			row.item(:dic_date).value ipdue.due_date.strftime("%d-%m-%Y")
				        	    			row.item(:ward).value admission.ward
				        	    			row.item(:due).value "%05.2f" % ipdue.due 
											total=total+ipdue.due
		        	  					end
		        	  				s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1
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
			str<<pm.sub_category+"<division>"
		end
		render :text=>str	
	end
end
def patientwise_pkg_advances
end 
def patientwis_pkg
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
		        		
		        				item(:image).value "public/images/exleaz.png"
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
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	consultant=ConsultantMaster.all(:conditions => "charge_type = 'Both'")
	@consultant=Array.new
	i=0
	for con in consultant
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		@consultant[i]=con.consultant_id+"-"+employee.name
		i=i+1
	end
end 
def doctorwise_concession_tests
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
		        		
		        				item(:image).value "public/images/exleaz.png"
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
			str<<room.name+"<division>"
		end
		render :text=>str	
	end
end

def wardwise
	from_date=params[:from_date]
		to_date=params[:to_date]
		room=params[:room]
		ward=params[:ward]
		status=params[:status]
			require 'rubygems'
		  	require 'thinreports'
		  		ThinReports::Report.generate_file('app/views/reports/doctorwise_concession_4tests.pdf') do
				    use_layout 'app/views/reports/doctorwise_concession_for_tests.tlf'
				    start_new_page do
		        		org_master_child=OrgMasterChildTable.last
		        		
		        				item(:image).value "public/images/exleaz.png"
		        		  		item(:address1).value org_master_child.address.split(";")[0]
				            	item(:address2).value org_master_child.address.split(";")[1]
				            	item(:address3).value org_master_child.address.split(";")[2]
				            	item(:address4).value org_master_child.address.split(";")[3]     
				             	item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")    
				             	item(:report_name).value "Doctorwise Concession For Tests"
				
				             	s_no=1
				             	total=0

		admissions=RoomMaster.find(:all, :conditions=>" created_at BETWEEN '#{from_date}' AND '#{to_date}' AND status LIKE '#{status}' ")				             	
				
						  	for admission in admissions
						  		 	report.page.list(:list).add_row do |row|
				        	    			row.item(:s_no).value s_no
				        	    			row.item(:consultant).value admission.concession_authority
				        	    			row.item(:admn_no).value admission.admn_no+"/"+testbooking.mr_no
				        	    			row.item(:p_name).value admission.patient_name
				        	    			row.item(:age).value admission.age.to_s+"/"+admission.gender
				        	    			row.item(:case).value admission.patient_type
				        	    			row.item(:test_name).value admission.test_name
				        	    			row.item(:amount).value "%05.2f" % admission.amount
										total=total+admission.amount
		        	  					end
		        	  				s_no=s_no+1
					        	  		item(:count).value s_no-1 	
					        	  		item(:total).value "%05.2f" % total						 
					 					item(:page_no).value 1
		        			
		        			end


			  end
	end
		redirect_to("/reports/doctorwise_concession_4tests/1?format=pdf")	
end 	



	
#saritha..........
	def doctor_wise_admission
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	consultant=ConsultantMaster.all(:conditions => "charge_type = 'Both'")
	@consultant=Array.new
	i=0
	for con in consultant
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		@consultant[i]=con.consultant_id+"-"+employee.name
		i=i+1
	end

end

def doctor_wise_admission_report
	@from_date=params[:from_date]
	@to_date=params[:to_date]
	status=params[:status]
	consultant=ConsultantMaster.find_by_consultant_id(params[:consultant])
	employee=EmployeeMaster.find_by_empid(params[:consultant])
	require 'rubygems'
  	require 'thinreports'
  		ThinReports::Report.generate_file('app/views/reports/readpdf.pdf') do
		    use_layout'app/views/reports/doct_wise_adm_report.tlf' 
      		  start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Doctor Wise Admissions/Discharges"
			   item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
	if(status=="Admitted")
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{params[:consultant]}%'AND admn_status LIKE '#{params[:status]}%'")
    elsif(status=="Discharged")
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{params[:consultant]}%'AND admn_status LIKE '#{params[:status]}%'")

	else
		admission=Admission.find(:all)
	end
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
        	    			row.item(:ward).value admission1.ward
        	    			if(discharge)
	        	    			row.item(:status).value admission1.admn_status
	        	    			row.item(:advance).value final_bill.paid_amount
	        	    			row.item(:total).value final_bill.remaining_amount
	        	    			row.item(:due).value final_bill.balance_amount
	        	    			total=total+final_bill.remaining_amount
						advance_tot=advance_tot+final_bill.paid_amount
						due_tot=due_tot+final_bill.balance_amount
        	    			else
        	    				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
        	    				if(advance)
		        	    			total_amount,advance1,due1=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)
		        	    			row.item(:status).value admission1.admn_status
		        	    			row.item(:advance).value advance1
		        	    			row.item(:total).value total_amount
		        	    			row.item(:due).value due1
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
	consultant=ConsultantMaster.all(:conditions => "charge_type = 'Both'")

	@consultant=Array.new
	i=0
	for con in consultant
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		@consultant[i]=con.consultant_id+"-"+employee.name
		i=i+1
	end


end

def department_wise_report_thin

	@from_date=params[:from_date]
	@to_date=params[:to_date]
	status=params[:status]
	@department=params[:department]
	consultant=ConsultantMaster.find_by_consultant_id(params[:consultant])
	employee=EmployeeMaster.find_by_empid(params[:consultant])
	 if(status=="Admitted")
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{params[:consultant]}%'AND admn_status LIKE '#{params[:status]}%' AND department LIKE '#{params[:department]}%'")
    elsif(status=="Discharged" )
		admission=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{params[:consultant]}%'AND admn_status LIKE '#{params[:status]}%' AND department LIKE '#{params[:department]}%'")

	else
		admission=Admission.find(:all, :conditions=>"(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{params[:consultant]}%'AND department LIKE '#{params[:department]}%'")
	end
	require 'rubygems'
  	require 'thinreports'
  		ThinReports::Report.generate_file('app/views/reports/dept_wise_rpt.pdf') do
		    use_layout'app/views/reports/dept_wise_adm_report.tlf'
      		start_new_page do
        		org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Total Registrations"
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
        	    			row.item(:ward).value admission1.ward
        	    			if(discharge)
	        	    			row.item(:status).value admission1.admn_status
	        	    			row.item(:advance).value final_bill.paid_amount
	        	    			row.item(:total).value final_bill.remaining_amount
	        	    			row.item(:due).value final_bill.balance_amount
	        	    			total=total+final_bill.remaining_amount
						advance_tot=advance_tot+final_bill.paid_amount
						due_tot=due_tot+final_bill.balance_amount
        	    			else
        	    				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
        	    				if(advance)
		        	    			total_amount,advance1,due1=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)
		        	    			row.item(:status).value admission1.admn_status
		        	    			row.item(:advance).value advance1
		        	    			row.item(:total).value total_amount
		        	    			row.item(:due).value due1
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
            item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Package Wise Rrport"
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
	        	    			
	        	    			row.item(:advance).value final_bill.paid_amount
	        	    			row.item(:total).value final_bill.remaining_amount
	        	    			row.item(:due).value final_bill.balance_amount
	        	    			total=total+final_bill.remaining_amount
						advance_tot=advance_tot+final_bill.paid_amount
						due_tot=due_tot+final_bill.balance_amount

        	    			else
        	    				advance=AdvancePayment.find_by_admn_no(admission1.admn_no)
        	    				if(advance)
		        	    			total_amount,advance1,due1=advance.payment_details(admission1.admn_no,admission1.org_code,'',admission1.admn_category)
		        	    	
		        	    			row.item(:advance).value advance1
		        	    			row.item(:total).value total_amount
		        	    			row.item(:due).value due1
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
      patient_type=params[:patient_type]
      if(patient_type=="OP")

        appointment_payments = AppointmentPayment.find(:all, :conditions=>"appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND referral_name LIKE '#{params[:refferal]}'")


      elsif(patient_type=="Lab")
      	appointment_payments = TestBooking.find(:all, :conditions=>"booking_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND refferal_doctor LIKE '#{params[:refferal]}'")
      elsif(patient_type=="IP")
      	appointment_payments = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND consultant_id='appointment_payments[0].consultant_id'")
      elsif(patient_type=="Pharmacy")
        appointment_payments = IssuesToOp.find(:all, :conditions=>"issue_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'AND consultant LIKE '#{params[:refferal]}'")
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/refferal.pdf') do
        use_layout'app/views/reports/refferal_report3.tlf'
        
       start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
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
            s_no=1
            for appointment_payment in appointment_payments
                               
                report.page.list(:list).add_row do |row|
                	if(patient_type=="OP")
                    row.item(:s_no).value s_no
                    row.item(:cons).value appointment_payment.consultant_name
                    row.item(:mr_no).value appointment_payment.mr_no
                    row.item(:patient).value appointment_payment.patient_name
                    row.item(:age).value appointment_payment.age.to_s+"/"+appointment_payment.gender
                    row.item(:date1).value appointment_payment.appt_date
                     row.item(:op).value "%05.2f" % appointment_payment.paid_amount
                     row.item(:ip).value "0"
                     row.item(:lab).value "0"
                     if(appointment_payment.paid_amount!="")
                     total=total+appointment_payment.paid_amount
                      else
                     total=total
                      end
                 elsif(patient_type=="Lab")
                      row.item(:s_no).value s_no
                      row.item(:cons).value appointment_payment.refferal_doctor
                      row.item(:mr_no).value appointment_payment.mr_no
                      appointment=AppointmentPayment.find_by_mr_no(appointment_payment.mr_no)
                      if(appointment)
                      row.item(:patient).value appointment.patient_name
                      row.item(:age).value appointment.age.to_s+"/"+appointment.gender
                    else
                  	 row.item(:patient).value ""
                      row.item(:age).value ""
                      end
                      row.item(:date1).value appointment_payment.booking_date
                      row.item(:lab).value "%05.2f" % appointment_payment.paid_amount
                      row.item(:ip).value ""
                      row.item(:op).value ""
                      row.item(:pharmacy).value ""
                      if(appointment_payment.paid_amount!="")
                     total1=total1+appointment_payment.paid_amount
                      else
                     total1=total1
                      end
                   elsif(patient_type=="IP")
                   	row.item(:s_no).value s_no
                   	row.item(:mr_no).value appointment_payment.mr_no
                   	row.item(:patient).value appointment_payment.patient_name
                    row.item(:age).value appointment_payment.age.to_s+"/"+appointment_payment.gender
                    row.item(:date1).value appointment_payment.admn_date
                    appointment=AppointmentPayment.find_by_mr_no(appointment_payment.mr_no)
                      if(appointment.consultant_id==appointment_payment.consultant_id)
                      	row.item(:cons).value appointment.consultant_name
                      else
                      	row.item(:cons).value ""
                      end
                    row.item(:ip).value "%05.2f" % appointment_payment.amount
                     row.item(:op).value ""
                     row.item(:lab).value ""
                     row.item(:pharmacy).value ""
                     if(appointment_payment.amount!="")
                     total2=total2+appointment_payment.amount
                      else
                     total2=total2
                      end
                elsif(patient_type=="Pharmacy")
                    row.item(:s_no).value s_no
                   	row.item(:mr_no).value appointment_payment.mr_no
                    row.item(:cons).value appointment_payment.consultant
                    row.item(:date1).value appointment_payment.issue_date

                    appointment=AppointmentPayment.find_by_mr_no(appointment_payment.mr_no)
                      if(appointment)
                      row.item(:patient).value appointment.patient_name
                      row.item(:age).value appointment.age.to_s+"/"+appointment.gender
                    else
                  	 row.item(:patient).value ""
                      row.item(:age).value ""
                      end
                    row.item(:pharmacy).value "%05.2f" % appointment_payment.paid_amt
                     row.item(:op).value ""
                     row.item(:lab).value ""
                     row.item(:lab).value ""
                     if(appointment_payment.amount!="")
                     total3=total3+appointment_payment.amount
                      else
                     total3=total3
                      end
                  end
                  grand=total+total1+total2+total3
                end
                	
                     s_no=s_no+1
					 item(:count).value s_no-1 					 
					 item(:total).value "%05.2f" % total
					 item(:total1).value "%05.2f" % total1
					 item(:total2).value "%05.2f" % total2
					 item(:total3).value "%05.2f" % total3
					 item(:grand_tot).value "%05.2f" % grand
					 item(:page_no).value 1
					end	
					 
    end
     end 
     redirect_to("/reports/refferal/1?format=pdf")
    end
     def refferal

      send_file "app/views/reports/refferal.pdf", :type => "application/pdf", :disposition => 'inline'
    end

 

def insurance_registration_report
end

def insurance_registration1

       registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND reg_type='Insurance' ")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/insurance.pdf') do
        use_layout'app/views/reports/insurance_report.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Insurance Registrations"
			   item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
				total=0
            for registration in registrations
                appointment=AppointmentPayment.find_by_mr_no(registration.mr_no)
					 	
				    report.page.list(:list).add_row do |row|			
 	                   row.item(:s_no).value s_no
 	                   row.item(:company).value registration.ins_company_name
 	                   row.item(:policy).value registration.policy_no
 	                   row.item(:mr_no).value registration.mr_no
 	                   row.item(:patient).value registration.patient_name
 	                   
 	                  city1=InsuranceMaster.find_by_company_name(registration.ins_company_name)
 	                   row.item(:date).value registration.reg_date
 	                   row.item(:city).value city1.city
 	                   if(appointment)
 	                   row.item(:cons).value appointment.consultant_name
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
            item(:image).value "public/images/exleaz.png"
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
      case2=params[:case1]
      if(case2=="IP")
      	case3="IP"
      admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND department LIKE '#{params[:department]}'")
    

  elsif(case2=="OP")
  	case3="OP"
      admissions = AppointmentPayment.find(:all, :conditions=>"appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND department LIKE '#{params[:department]}'")
     
     end 
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/department_wise.pdf') do
        use_layout'app/views/reports/department_report.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
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
                     row.item(:case).value case3
                     if(case2=="IP" && admission.amount!="")
                     row.item(:total).value "%05.2f" % admission.amount
                      total=total+admission.amount
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
      admn1=params[:admn_no]
      if(admn1!="")
      insurance_payments = InsurancePayment.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND admn_no LIKE '#{params[:admn_no]}'")
      else
      	insurance_payments = InsurancePayment.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/insurance_payment1.pdf') do
        use_layout'app/views/reports/insurance_payment.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Insurance Payments Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
            for insurance_payment in insurance_payments
           
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:admn_no).value insurance_payment.admn_no
                     admission=Admission.find_by_admn_no(insurance_payment.admn_no)
                     if(admission)
                     row.item(:p_name).value admission.patient_name
                     row.item(:age).value admission.age.to_s+"/"+admission.gender
                 else
                 	row.item(:p_name).value ""
                     row.item(:age).value ""
                 end
                     row.item(:date).value insurance_payment.admn_date
                     row.item(:dis_date).value insurance_payment.dis_date
                      registration=Registration.find_by_mr_no(insurance_payment.mr_no)
                      if(registration)
                      	row.item(:company).value registration.ins_company_name
                      else
                      	row.item(:company).value ""
                      end
                     row.item(:total_amt).value "%05.2f" % insurance_payment.amount
               total=total+insurance_payment.amount
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
      
      registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND reg_type='Insurance' AND ins_company_name LIKE '#{params[:company_name]}'")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/insurance_company_wise1.pdf') do
        use_layout'app/views/reports/insurance_company_wise.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
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
                     if(admission)
                     row.item(:admn_no).value admission.admn_no
                     row.item(:date).value admission.admn_date
                     row.item(:total_amt).value "%05.2f" % admission.amount
                     total=total+admission.amount
                 else 
                 	row.item(:admn_no).value ""
                 	 row.item(:date).value ""
                 	 row.item(:total_amt).value "%05.2f" % "0.0"
                 	 total=total
                 end
                 insurance=InsurancePayment.find_by_mr_no(registration.mr_no)
                 if(insurance)
                 	row.item(:dis_date).value insurance.dis_date
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
    admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND package_category LIKE '#{params[:category]}' AND sub_category LIKE '#{params[:sub_category]}'")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/patient_wise_report1.pdf') do
        use_layout'app/views/reports/patient_wise_report.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Patient Wise Package Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
            for admission in admissions
           
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:admn_no).value admission.admn_no
                      row.item(:p_name).value admission.patient_name
                     row.item(:age).value admission.age.to_s+"/"+admission.gender
                     row.item(:ward).value admission.ward
                     row.item(:date).value admission.admn_date
                     
                     
                ip=IpDue.find_by_admn_no(admission.admn_no)
                if(ip)
                	row.item(:due).value "%05.2f" % ip.due
                	total=total+ip.due
                     else
                     row.item(:due).value "%05.2f" % "0"
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
     redirect_to("/reports/patient_wise_report1/1?format=pdf") 
     end
     def patient_wise_report1

      send_file "app/views/reports/patient_wise_report1.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

    def patientwise_finalbill_cancel
    end
    def patientwise_finalbill_cancel_report
    finalbills = FinalBillCancel.find(:all, :conditions=>"final_bill_cancel_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/patientwise_finalbill_cancel1.pdf') do
        use_layout'app/views/reports/patientwise_finalbill_cancel1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
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
    reports =  MiscellaneousMaster.find(:all, :conditions=>"date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/miscellaneous_report1.pdf') do
        use_layout'app/views/reports/miscellaneous_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
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
                     mis=MiscellaneousChild.find_by_miscellaneous_master_id	(report.id)
                     if(mis)
                     row.item(:service).value mis.service
                     row.item(:amt).value "%05.2f" % mis.amount
                 else
                 	 row.item(:service).value "---"
                     row.item(:amt).value "%05.2f" % "0"
                 end
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
     redirect_to("/reports/miscellaneous_report1/1?format=pdf") 
     end
     def miscellaneous_report1

      send_file "app/views/reports/miscellaneous_report1.pdf", :type => "application/pdf", :disposition => 'inline'
    end	

    def patientwise_package_finalbill
    end
    def patientwise_finalbill_report
    	
      package=params[:package_category]
      sub=params[:sub_category]
      if(package!="" && sub!="")
      	admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND package_category LIKE '#{params[:category]}' AND sub_category LIKE '#{params[:sub_category]}'")
     else
     	admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/patientwise_package_bill.pdf') do
        use_layout'app/views/reports/patientwise_finalbill1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
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
                     	 row.item(:final).value  "%05.2f" % final1.paid_amount
                     	 total1=total1+final1.paid_amount
                     else
                         row.item(:final).value "0"
                         total1=total1
                     end
                     

                ip=IpDue.find_by_admn_no(admission.admn_no)
                
                if(ip)

                	row.item(:due).value "%05.2f" % ip.due
                	total=total+ip.due
                 else
                     row.item(:due).value "0"
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
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/firstaid_report1.pdf') do
        use_layout'app/views/reports/firstaid_report2.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
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
end
 def doctorwise_op_report
	name1=params[:name]
	case2=params[:case1]
    if(name1!="")
      appointment_payments = AppointmentPayment.find(:all, :conditions=>"appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND consultant_name LIKE '#{params[:name]}'")
      else
      appointment_payments = AppointmentPayment.find(:all, :conditions=>"appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/doctorwise_op_report1.pdf') do
        use_layout'app/views/reports/doctorwise_concession_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Doctor Wise Concession Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
            for appointment_payment in appointment_payments
           
            report.page.list(:list).add_row do |row|      
                     
                     if(case2=="OP")
                     row.item(:s_no).value s_no
                     row.item(:mr_no).value appointment_payment.mr_no
                     row.item(:p_name).value appointment_payment.patient_name
                     row.item(:age).value appointment_payment.age.to_s+"/"+appointment_payment.gender
                     row.item(:concession).value appointment_payment.concession
                     row.item(:cons).value appointment_payment.consultant_name
                     row.item(:case).value "OP"
                     total=total+appointment_payment.concession
                 
                 elsif(case2=="Lab")
                 	testbooking=TestBooking.find_by_refferal_doctor(appointment_payments[0].consultant_name)
                 	if(testbooking)
                 	 row.item(:s_no).value s_no
                 	 row.item(:mr_no).value testbooking.mr_no
                     row.item(:p_name).value testbooking.patient_name
                     row.item(:concession).value testbooking.concession
                     row.item(:cons).value testbooking.refferal_doctor
                     row.item(:case).value testbooking.patient_type
                     total=total+testbooking.concession
                
                     if(testbooking.mr_no==appointment_payment.mr_no)
                       row.item(:age).value appointment_payment.age.to_s+"/"+appointment_payment.gender
                     else
                 	   row.item(:age).value ""
                     end
                  else
         	         row.item(:s_no).value ""
         	         row.item(:mr_no).value ""
                     row.item(:p_name).value ""
                     row.item(:concession).value ""
                     row.item(:cons).value ""
                     row.item(:case).value ""
                     total=total
                 end
                     elsif(case2=="Pharmacy")
                        issues=IssuesToOp.find_by_consultant(appointment_payments[0].consultant_name)
                        if(issues)
                        row.item(:s_no).value s_no
                        row.item(:mr_no).value issues.mr_no
	                    row.item(:p_name).value issues.patient_name
	                    row.item(:concession).value issues.concession
	                    row.item(:cons).value issues.consultant

                     total=total+issues.concession
                     if(issues.mr_no==appointment_payment.mr_no)
                       row.item(:age).value appointment_payment.age.to_s+"/"+appointment_payment.gender
                       row.item(:case).value "OP"
                     else
                 	  row.item(:age).value ""
                 	  row.item(:case).value ""
                      end
                   else
         	         row.item(:s_no).value ""
         	         row.item(:mr_no).value ""
                     row.item(:p_name).value ""
                     row.item(:concession).value ""
                     row.item(:cons).value ""
                     row.item(:case).value ""
                     total=total
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
redirect_to("/reports/doctorwise_op_report1/1?format=pdf")
end
 def doctorwise_op_report1
     send_file "app/views/reports/doctorwise_op_report1.pdf", :type => "application/pdf", :disposition => 'inline'
 end

def package_transfer
end
def package_transfer_report
	packages = PakageTransfer.find(:all, :conditions=>"today_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND trans_cat LIKE '#{params[:category]}' AND trans_subcat LIKE '#{params[:sub_category]}'")
      
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/package_transfer_report1.pdf') do
        use_layout'app/views/reports/package_transfer1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
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
                      row.item(:tot_amt).value package.t_amount
                     admission=Admission.find_by_admn_no(package.admn_no)
                     if(admission)
                      row.item(:p_name).value admission.patient_name
                      row.item(:age).value admission.age.to_s+"/"+admission.gender
                      row.item(:date).value admission.admn_date
                      row.item(:status).value admission.admn_status
                      row.item(:adv).value admission.advance
                      total=total+admission.advance
                     else
                  	  row.item(:p_name).value ""
                      row.item(:age).value ""
                      row.item(:date).value ""
                      row.item(:status).value ""
                      row.item(:adv).value ""
                      total=total
                     end
                      total1=total1+package.t_amount
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
str<<pm.sub_category+"<division>"
end
render :text=>str	
end
end
  def registration_report
    end
    def registration_report1

      registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}'")
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/registration_report2.pdf') do
        use_layout'app/views/reports/reg.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
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
           if(appointment)  
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:mr_no).value registration.mr_no
                     row.item(:p_name).value registration.patient_name
                     row.item(:age).value registration.age.to_s+"/"+registration.gender
                     row.item(:date).value registration.reg_date
                     row.item(:case).value "OP"
                     row.item(:c_name).value appointment.consultant_name
                     row.item(:amount).value "%05.2f" % appointment.paid_amount
               total=total+appointment.paid_amount
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:page_no).value 1
          end 
           
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
 	if(room1!="")
    bedtransfers = BedTransfer.find(:all, :conditions=>"transfer_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND from_ward LIKE '#{params[:ward]}'")
     else
     bedtransfers = BedTransfer.find(:all, :conditions=>"transfer_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND from_ward LIKE '#{params[:ward]}'") 
     end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/wardwise_report1.pdf') do
        use_layout'app/views/reports/wardwise_report1.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
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
	str<<room.name+"<division>"
	end
	render :text=>str	
	end
	end

	def arogyasree_registration
    
  end


  def arogyasree_registration_report

      registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND reg_type='Arogyasree'")
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/arogyasree_report.pdf') do
        use_layout'app/views/reports/arogyasree_report.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Arogyasree Registrations"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")            
            s_no=1
        total=0
            for registration in registrations
                appointment=AppointmentPayment.find_by_mr_no(registration.mr_no)
           if(appointment)  
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
                    row.item(:admn_no).value ""
                    row.item(:ward).value "-----"
                  end
                     row.item(:cons).value appointment.consultant_name
                    
                end
           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:page_no).value 1
          end 
           
            end
    end
    end
    redirect_to("/reports/arogyasree_report/1?format=pdf")
 end
     def arogyasree_report

      send_file "app/views/reports/arogyasree_report.pdf", :type => "application/pdf", :disposition => 'inline'
    end



 def consutant_visits1_app
end
 def consultant_visit_report
 	
 	patient_type=params[:patient_type]
 	if(patient_type=="OP")
     appt_payments=AppointmentPayment.find(:all,:conditions => "(appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{params[:consultant]}%'")
    elsif(patient_type=="IP")
    appt_payments=Admission.find(:all,:conditions => "(admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{params[:consultant]}%'")
    else
     appt_payments=Registration.all
    end
    	 require 'rubygems'
  	 require 'thinreports'
  	 ThinReports::Report.generate_file('app/views/reports/consultant1.pdf') do
    use_layout'app/views/reports/consultant_visit.tlf'
    	 start_new_page do
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Consultant Visits Report"
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
status1=params[:status]
room1=params[:room]
if(status1=='Admitted' && room!="")
 admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND admn_status='Admitted' AND ward LIKE '#{params[:ward]}' AND room LIKE '#{params[:room]}'")
     elsif(status1=='Discharged' && room!="")
     admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND admn_status='Discharged' AND ward LIKE '#{params[:ward]}' AND room LIKE '#{params[:room]}'")	
     elsif(status1=='Admitted' && room=="")
 admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND admn_status='Admitted' AND ward LIKE '#{params[:ward]}'")
     elsif(status1=='Discharged' && room=="")
     admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND admn_status='Discharged' AND ward LIKE '#{params[:ward]}'")	
     else
     admissions = Admission.find(:all, :conditions=>"admn_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}' AND ward LIKE '#{params[:ward]}'")	
     end
      require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/reports/wardwise_adm.pdf') do
        use_layout'app/views/reports/wardwise_adm2.tlf'
        
        start_new_page do
            
            org_master_child=OrgMasterChildTable.last
            item(:image).value "public/images/exleaz.png"
            item(:address1).value org_master_child.address.split(";")[0]
            item(:address2).value org_master_child.address.split(";")[1]
            item(:address3).value org_master_child.address.split(";")[2]
            item(:address4).value org_master_child.address.split(";")[3]            
            item(:report_name).value "Wardwise Admissions/Discharges Report"
         item(:to_date).value Time.new.strftime("%d-%m-%Y %H:%M")           
            s_no=1
        total=0
        total1=0
        total2=0
       
            for admission in admissions
                
            report.page.list(:list).add_row do |row|      
                     row.item(:s_no).value s_no
                     row.item(:admn_no).value admission.admn_no
                     row.item(:ward).value admission.ward
                     row.item(:p_name).value admission.patient_name
                     row.item(:age).value admission.age.to_s+"/"+admission.gender
                     row.item(:date).value admission.admn_date
                     row.item(:amt).value admission.amount
                    row.item(:status1).value admission.admn_status
                     row.item(:amount).value admission.advance
                     if(admission.amount!="" && admission.advance!="")

                     total=total+admission.amount
                     total1=total1+admission.advance
                    else
                    	total=total
                    	total1=total1
                    end
                    ip=IssuesToOp.find_by_admn_no(admission.admn_no)
                    if(ip)
                    row.item(:amt1).value ip.due
                    total2=total2+ip.due
                else
                	row.item(:amt1).value ""
                    total2=total2
                end
            end

           s_no=s_no+1
           item(:count).value s_no-1           
           item(:total).value "%05.2f" % total
           item(:total1).value "%05.2f" % total1
           item(:total2).value "%05.2f" % total2
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
        	
        	 item(:image).value "public/images/exleaz.png"
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


end
