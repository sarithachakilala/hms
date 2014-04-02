class TestBookingsController < ApplicationController
  # GET /test_bookings
  # GET /test_bookings.xml
gem 'barby'
gem 'chunky_png'
# some code to generate the png file using 3 of 9 barcode style
require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'
def index
  @admission = Admission.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org = Person.find(@session.person_id)
	@test_bookings = TestBooking.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@org.org_code}'"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @test_bookings }
    end
  end
  
    def observe_field_ex

  	@test_bookings = TestBooking.find(:all,:conditions=>"refferal_doctor LIKE'#{params[:reffered_by_search]}%' AND lab_no LIKE '%#{params[:lab_no_search]}' AND mr_no LIKE '%#{params[:mr_no_search]}' AND patient_type LIKE '%#{params[:type_search]}' AND patient_name LIKE '#{params[:name_search]}%'")
		if( @test_bookings[0])
		   render:partial=>"search_records"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  
		
  end 

  # GET /test_bookings/1
  # GET /test_bookings/1.xml
  def show
  	@admission = Admission.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @test_booking = TestBooking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @test_booking }
    end
  end

  # GET /test_bookings/new
  # GET /test_bookings/new.xml
  def new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
    	@test_booking = TestBooking.new
    
	@item_master=ChargeMaster.all(:conditions => "org_code = '#{@org_code}'")

	10.times{ @test_booking.test_booking_child.build }
	str=""
	str1=""
	@barcode_id=""
	@tb=TestBooking.last(:conditions =>"org_code='#{@org_code}'")
    	if(@tb)
		n=(@tb.lab_no.slice!(3..50).to_i+1).to_s 
		@barcode_id=@tb.barcode_id.next	
       	str="Lab"+n
	else
        n=1.to_s
        @barcode_id="201208001"
		str="Lab"+n
	end
	@test_booking.lab_no=str
	receipt_no=Number.new														# Create object to number table
	@test_booking.bill_no=receipt_no.get_number('receipt',@org_code)  	# Method calling 
	
	# end
	
	@appt_payment = AppointmentPayment.all(:conditions => "appt_date = '#{Date.today}'")
	@admissions = Admission.all(:conditions => "admn_status = 'admitted'", :order => "id DESC")
	@registration=Registration.all(:order => "id DESC")


    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @test_booking }
    end
  end

  # GET /test_bookings/1/edit
  def edit
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	@item_master=ChargeMaster.all
    	@test_booking = TestBooking.find(params[:id])
	10.times{ @test_booking.test_booking_child.build }
	registration=Registration.last(:conditions => "mr_no = '#{@test_booking.mr_no}'")
	@age=registration.age
  end

  # POST /test_bookings
  # POST /test_bookings.xml
  def create
  	@admission = Admission.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
@org_code=@person.org_code
	@org_location=@person.org_location
    @test_booking = TestBooking.new(params[:test_booking])	
	@item_master=ChargeMaster.all(:conditions => "org_code = '#{@org_code}'")
	@admissions = Admission.all(:conditions => "admn_status = 'admitted'", :order => "id DESC")
	@registration=Registration.all(:order => "id DESC")
	# code for barcode
		barcode1= @test_booking.barcode_id
		path= "public/images/barcodeimages/#{@test_booking.lab_no}.png"
		barcode = Barby::Code128B.new(barcode1)
		File.open(path , 'wb'){|f|
		 
		    f.write barcode.to_png(:margin => 3, :xdim => 2, :height => 55) 
		}
    respond_to do |format|
      if @test_booking.save
      	@receipt_number=Number.find_by_name_and_org_code('receipt',@person.org_code)
      	@receipt_number.value=@test_booking.bill_no
      	@receipt_number.update_attributes(params[:receipt_number])
        format.html { redirect_to("/test_bookings/report/#{@test_booking.id}?print_type=original&format=pdf") }
        format.xml  { render :xml => @test_booking, :status => :created, :location => @test_booking }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @test_booking.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /test_bookings/1
  # PUT /test_bookings/1.xml
  def update
    @test_booking = TestBooking.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@item_master=ChargeMaster.all
    respond_to do |format|
      if @test_booking.update_attributes(params[:test_booking])
        format.html { redirect_to("/test_bookings/report/#{@test_booking.id}?print_type=original&format=pdf") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @test_booking.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /test_bookings/1
  # DELETE /test_bookings/1.xml
  def destroy
    @test_booking = TestBooking.find(params[:id])
    @test_booking.destroy

    respond_to do |format|
      format.html { redirect_to(test_bookings_url) }
      format.xml  { head :ok }
    end
  end
  
   def ajax_function
		org_code=params[:org_code]
		admn_no=params[:admn_no]
		mr_no=params[:mr_no]
		query=params[:query]
		selected_type=params[:selected_type]
		main_service=params[:main_service]
		str=""
		if(selected_type=="due")
			@con=Authorizationmaster.find_by_emp_name_and_org_code(query,org_code)
			render :text =>@con.concession_limit.to_s
		elsif(selected_type=="due1")
			@con=Authorizationmaster.find_by_emp_name_and_org_code(query,org_code)
			render :text =>@con.due_limit.to_s
		elsif(selected_type=="services")
			charge=ChargeMaster.find_by_test_name_and_org_code(query,org_code)
			if(charge)
				render :text =>charge.service_name+"<division>"+charge.test_name+"<division>"+charge.charge.to_s+"<division>"+charge.service_group
			else
				render :text => "error"
			end
		elsif(selected_type=="department")
				
				@test=Testmaster.find(:all, :conditions => "department_name = '#{query}' and org_code LIKE '#{org_code}%'")
				str=""
				for test in @test
					str<<test.test_name+"<division>"
				end
				render :text =>str
		end
	end	

 def ajax_function_mr_no
	if(params[:patient_type]=="OP")
		appt_payment=AppointmentPayment.find_by_id(params[:record_id])
		registration=Registration.last(:conditions => "org_code = '#{params[:org_code]}' and mr_no = '#{appt_payment.mr_no}'")
		render :js => " 
					var fill_value=new Array('mr_no','patient_name','age');
					for(i=0;i<fill_value.length;i++)
					{
						document.getElementById(fill_value[i]).style.background='#FEF5CA'
						document.getElementById(fill_value[i]).readOnly=true
					}
					document.getElementById('mr_no').value='#{registration.mr_no}';
					document.getElementById('patient_name').value='#{registration.title+"."+registration.patient_name}';
					document.getElementById('age').value='#{registration.age}';
					"
	elsif(params[:patient_type]=="IP")
		@admissions = Admission.find_by_id(params[:record_id])
		registration=Registration.last(:conditions => "org_code = '#{params[:org_code]}' and mr_no = '#{@admissions.mr_no}'")
		render :js => "
						var fill_value=new Array('mr_no','patient_name','age');
						for(i=0;i<fill_value.length;i++)
						{
							document.getElementById(fill_value[i]).value=''
							document.getElementById(fill_value[i]).style.background='#FEF5CA'
							document.getElementById(fill_value[i]).readOnly=true
						}
						document.getElementById('mr_no').value='#{registration.mr_no}';
						document.getElementById('patient_name').value='#{registration.title+"."+registration.patient_name}';
						document.getElementById('age').value='#{registration.age}';
						document.getElementById('admn_no').value='#{@admissions.admn_no}'
					"
	elsif(params[:patient_type]=="OSP")
		registration=Registration.find_by_id(params[:record_id])
		render :js => " 
					var fill_value=new Array('mr_no','patient_name','age');
					for(i=0;i<fill_value.length;i++)
					{
						document.getElementById(fill_value[i]).style.background='#FEF5CA'
						document.getElementById(fill_value[i]).readOnly=true
					}
					document.getElementById('mr_no').value='#{registration.mr_no}';
					document.getElementById('patient_name').value='#{registration.patient_name}';
					document.getElementById('age').value='#{registration.age}';	
					"
	end
  end
  
 
  
  def search_records
  	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
  end
  
   def search_results
	from_date=params[:from_date]
	to_date=params[:to_date]
	@lab_id=params[:lab_id]
	mr_no=params[:mr_no]
	first_name=params[:first_name]
	@department_name=params[:department]
	org_code=params[:org_code]
	if(@lab_id=="")
		if(from_date!="" && to_date!="")
			@test_bookings = TestBooking.find(:all, :conditions => "
				(booking_date BETWEEN '#{from_date}' AND '#{to_date}') AND
				patient_name LIKE '#{first_name}%' AND
				mr_no  LIKE '#{mr_no}%' AND
				org_code LIKE '#{org_code}'", :order => "id DESC")
		else
			@test_bookings = TestBooking.find(:all, :conditions => "
				patient_name LIKE '#{first_name}%' AND
				mr_no  LIKE '#{mr_no}%' AND
				org_code LIKE '#{org_code}'", :order => "id DESC")
		end
	else
		@test_bookings = TestBooking.find(:all, :conditions => "lab_no  = '#{@lab_id}'", :order => "id DESC")
	end
  end
  
  
   def report
   	@date=Time.now.strftime("%I:%M%p")
	@test_booking = TestBooking.find_by_id(params[:id])
	@registration=Registration.find_by_mr_no_and_org_code(@test_booking.mr_no,@test_booking.org_code)
	@people=Person.find_by_id(params[:user_id])
	@print_type=params[:print_type]
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 10,
      :right_margin => 10,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "report.pdf"

    render :layout => false
  end
  
  def test_cancel
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
  end
  
  def test_cancel_result
	from_date=params[:from_date]
	to_date=params[:to_date]
	@lab_id=params[:lab_id]
	@mr_no=params[:mr_no]
	@first_name=params[:first_name]
	@department_name=params[:department]
	@f_date=from_date
	@t_date=to_date
	org_code=params[:org_code]
	if(@lab_id=="" || !@lab_id)
		if(from_date!="" && to_date!="")
			@test_bookings = TestBooking.find(:all, :conditions => "
				(booking_date BETWEEN '#{from_date}' AND '#{to_date}') AND
				patient_name LIKE '#{@first_name}%' AND
				mr_no  LIKE '#{@mr_no}%' AND
				org_code LIKE '#{org_code}'", :order => "id DESC")
		else
			@test_bookings = TestBooking.find(:all, :conditions => "
				patient_name LIKE '#{@first_name}%' AND
				mr_no  LIKE '#{@mr_no}%' AND
				org_code LIKE '#{org_code}'", :order => "id DESC")
		end
	else
		@test_bookings = TestBooking.find(:all, :conditions => "lab_no  = '#{@lab_id}'", :order => "id DESC")
	end
  end
  
    def report_generate
		@form_date=params[:from_date]
		@too_date=params[:to_date]
		org_code=params[:org_code]
		@amount=Array.new
		@date=Array.new
		j=0
		for i in @form_date.to_date..@too_date.to_date
			@date[j]=i.to_s
			@amount[j]=TestBooking.sum(:paid_amount,:conditions => "booking_date = '#{i.to_s}' AND org_code LIKE '#{params[:org_code]}%'")
			j+=1
		end
		render :partial => "total_test_collection_report"
	end	
	
	def test_booking_report_def
		form_date=params[:from_date]
		to_date=params[:to_date]
		
		patient=params[:patient]
		org_code=params[:org_code]
		reffered_by=params[:reffered_by]
		patient_type=params[:patient_type]
		
		@testbooking=TestBooking.find(:all, :conditions => "
					(booking_date BETWEEN '#{form_date}' AND '#{to_date}') AND
					patient_name LIKE '#{patient}%' AND
					patient_type LIKE '#{patient_type}%' AND
					refferal_doctor LIKE '#{reffered_by}%' AND 
					org_code LIKE '#{org_code}%'")
		render :partial => "test_booking_reporting"
    end
	
	def test_report
		from_date=params[:from_date]
		to_date=params[:to_date]
		org_code=params[:org_code]
		service_name=params[:service]
		lab=params[:lab_department]
		if(from_date!="" && to_date!="" &&  service_name!="")
			query=["created_at BETWEEN ? AND ? AND  department like '#{lab}' and test_name  LIKE '#{service_name}%'", from_date,to_date]
			@tname=params[:service]
		elsif(from_date!="" && to_date!="" )
			query=["created_at  BETWEEN ? AND ? ", from_date,to_date]
			@tname= "Lab Investigations"
		end
		@total=TestBookingChild.sum(:amount,:conditions => query)
		@test_amount=TestBookingChild.find(:all, :conditions => query)
		prawnto :prawn => {
			:page_size => 'A4',
			:left_margin => 10,
			:right_margin => 0,
			:top_margin => 10,
			:bottom_margin => 30},
			:filename => "sa.pdf"
		render :layout => false
	end
	
	def test_cancels_report_form
		from_date=params[:from_date]
		to_date=params[:to_date]
		org_code=params[:org_code]
		if(from_date!="" && to_date!="" )
			query=["created_at BETWEEN ? AND ? AND org_code LIKE '#{org_code}%'", from_date,to_date]
		end
		@test_cancel=TestCancel.find(:all, :conditions => query)
		render :partial =>"test_cancel"
    end


   def barcode_report
   	@date=Time.now.strftime("%I:%M%p")

    @user_id= params[:user_id]
    @barcode_no= params[:barcode_no]
 	@no_of_copies=params[:no_of_copies1]
	@test_booking = TestBooking.find_by_lab_no(params[:user_id])
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 10,
      :right_margin => 10,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "report.pdf"

    render :layout => false
  end

  def barcode_print
  	 @user_id= params[:user_id]
  	 puts @user_id 

  end

  def check_test
   	test_master=Testmaster.find_by_test_name_and_org_code(params[:test_name],params[:org_code])
   	if(test_master)
   		render :text => "sucess"
   	else
   		render :text => "error"
   	end	
  end
end

