class AppointmentPaymentsController < ApplicationController
  # GET /appointment_payments
  # GET /appointment_payments.xml
  def index
  	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @appointment_payments = AppointmentPayment.paginate :page => params[:page] || 1, :per_page => 5, :order => "id DESC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @appointment_payments }
    end
  end

  # GET /appointment_payments/1
  # GET /appointment_payments/1.xml
  def show
    @appointment_payment = AppointmentPayment.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @appointment_payment }
    end
  end

  # GET /appointment_payments/new
  # GET /appointment_payments/new.xml
  def new
    @appointment_payment = AppointmentPayment.new
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
    
	
	# Get updated receipt/bill no
	receipt_no=Number.new														# Create object to number table
	@appointment_payment.bill_no11=receipt_no.get_number('receipt',@org_code)  	# Method calling 
	# end
	@referral=""
	if(params[:mr_no])
		@registrations = Registration.find_by_mr_no_and_org_code(params[:mr_no],@org_code)
		@appointment_payment.mr_no=@registrations.mr_no
		@appointment_payment.patient_name=@registrations.title+"."+@registrations.patient_name
		@appointment_payment.age=@registrations.age
		@appointment_payment.gender=@registrations.gender
		@appointment_payment.appt_type="OP"
		@referral=@registrations.referral_name
	end
	respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @appointment_payment }
    end
	 
  end

  # GET /appointment_payments/1/edit
  def edit
  	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @appointment_payment = AppointmentPayment.find(params[:id])
    @registration=Registration.last(:conditions => "mr_no='#{@appointment_payment.mr_no}'")
    @referral=@registration.referral_name
  end

  # POST /appointment_payments
  # POST /appointment_payments.xml
  def create
    	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@appointment_payment = AppointmentPayment.new(params[:appointment_payment])
	@appointment_payment.patient_name=Number.new.change_patient_name(@appointment_payment.patient_name)
    	
	# Get updated receipt/bill no
	receipt_no=Number.new # Create object to number table
	@appointment_payment.bill_no11=receipt_no.get_number('receipt',@appointment_payment.org_code)  	# Method calling 
	# end
    respond_to do |format|
      if @appointment_payment.save
      	@n=Number.find_by_name_and_org_code("receipt",@appointment_payment.org_code)
		@n.value=@appointment_payment.bill_no11
		@n.update_attributes(params[:n])
        format.html { redirect_to("/appointment_payments/report/#{@appointment_payment.id}?print_type=original&format=pdf") }
        format.xml  { render :xml => @appointment_payment, :status => :created, :location => @appointment_payment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @appointment_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /appointment_payments/1
  # PUT /appointment_payments/1.xml
  def update
    @appointment_payment = AppointmentPayment.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)

    respond_to do |format|
      if @appointment_payment.update_attributes(params[:appointment_payment])
        format.html { redirect_to("/appointment_payments/report/#{@appointment_payment.id}?print_type=original&format=pdf") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @appointment_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /appointment_payments/1
  # DELETE /appointment_payments/1.xml
  def destroy
    @appointment_payment = AppointmentPayment.find(params[:id])
    @appointment_payment.destroy
	#appointment_payments_url
    respond_to do |format|
      format.html { redirect_to("/appointment_payments/appt_cancel/1") }
      format.xml  { head :ok }
    end
  end
  
   
  	def select_department
		if(params[:field_id]=="department")
			@department1 = EmployeeMaster.find(:all, :conditions=>"department = '#{params[:query]}' OR visible=1 ")
			str=""
			 
			for department in @department1
				str<< department.empid+" - "+department.name+"<division>"
				
			end
			render :text => str
	   	elsif(params[:field_id]=="consultant_id")
	   		cons_id=params[:consultant_id].split(" - ")
			@charge= ConsultantMaster.find_by_consultant_id(cons_id[0])
			@appointment_payments_all = AppointmentPayment.last(:conditions=>"consultant_id='#{cons_id[0]}' and appt_date='#{params[:appt_date]}'")
			if(@appointment_payments_all)
				new_op_number=@appointment_payments_all.op_number+1
				render :text => new_op_number.to_s+"<division>"+@charge.general_charge.to_s
			else
				new_op_number=1.to_s
				render :text => new_op_number+"<division>"+@charge.general_charge.to_s
			end
	    end
	end
 
 	def ajaxreq
	if(params[:period] == "All")
		@registrations = Registration.find(:all, :conditions=>"patient_name like '#{params[:patient_name]}%' AND father_name like '#{params[:father_name]}%' AND mobile_no like '#{params[:mobile_no]}%' ANd age like '#{params[:age]}%' And gender like '#{params[:gender]}%'", :order => "id DESC")
	else
  		@registrations = Registration.find(:all, :conditions=>"reg_date BETWEEN '#{params[:from_date]}' AND '#{params[:to_date]}' AND patient_name like '#{params[:patient_name]}%' AND father_name like '#{params[:father_name]}%' AND mobile_no like '#{params[:mobile_no]}%' ANd age like '#{params[:age]}%' And gender like '#{params[:gender]}%'", :order => "id DESC")
	end
		if(@registrations)
			render :partial=>"search_mrno"
		else
			render :text=>"No Records"
		end
	end
	def search
		@appointment_payments = AppointmentPayment.find(:all,:conditions => "mr_no = '#{params[:t]}'")
		render :partial => "search_medical_records"
  	end  
  	
  	def report
		@date=Time.now.strftime("%I:%M%p")
		@print_type=params[:print_type]
    	@appointment_payment = AppointmentPayment.find(params[:id])
		@registration=Registration.find_by_mr_no_and_org_code(@appointment_payment.mr_no,@appointment_payment.org_code)
		
    	@to_watds=Number.new.number_to_words(@appointment_payment.paid_amount.to_i)
		prawnto :prawn => {
    	  :page_size => 'A4',
    	  :left_margin => 10,
    	  :right_margin => 5,
    	  :top_margin => 10,
    	  :bottom_margin => 30},
    	  :filename => "report.pdf"
	    render :layout => false
	end
	
  def observe_field_ex
  	@appointment_payments = AppointmentPayment.find(:all,:conditions=>"appt_date LIKE '%#{params[:appt_date]}' AND op_number LIKE '#{params[:registration_id]}%' AND mr_no LIKE '%#{params[:mr_no]}' AND department LIKE '#{params[:department]}%' AND consultant_name LIKE '#{params[:consultant_name]}%'")
	if( @appointment_payments[0])
	   render:partial=>"search_medical_records"
	else
		render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
	end  
		
  end 
  
   def appt_cancel
		@session_id=session[:id]
		@session = Session.find(session[:id])
		@person = Person.find(@session.person_id)	
		@org_code=@person.org_code
   end
		
  def work_list_search
	@date=params[:date1]
	puts @date
	@appt_cancels = AppointmentPayment.find(:all, :conditions =>"appt_date = '#{params[:date1]}%'")
	render :partial => "appt_cancel_search"
 end
  def appointment_report1
      appointment_payment = AppointmentPayment.find(params[:id])
      
      registration=Registration.find_by_mr_no(appointment_payment.mr_no)
           require 'rubygems'
      require 'thinreports'
      ThinReports::Report.generate_file('app/views/appointment_payments/appointment.pdf') do
        use_layout'app/views/appointment_payments/appointment_report4.tlf'
        
        start_new_page do
         
                     item(:mr_no).value appointment_payment.mr_no
                     registration=Registration.find_by_mr_no(appointment_payment.mr_no)
                     item(:patient).value registration.title+"."+appointment_payment.patient_name
                     item(:age).value appointment_payment.age+"/"+appointment_payment.gender
                     item(:date).value appointment_payment.appt_date
                     item(:cons).value appointment_payment.consultant_name
                     if(registration.mr_no==appointment_payment.mr_no)
                     item(:phone).value registration.mobile_no
                     item(:address1).value registration.address.split(";")[0]
                     item(:address2).value registration.address.split(";")[1]
                    else
                      item(:phone).value ""
                     item(:address1).value ""
                     item(:address2).value ""
                   end
                    end 
           
           end
           redirect_to("/appointment_payments/appointment/1?format=pdf") 
    end
      
    
     def appointment

      send_file "app/views/appointment_payments/appointment.pdf", :type => "application/pdf", :disposition => 'inline'
    end

end
