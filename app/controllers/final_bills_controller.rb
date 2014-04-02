class FinalBillsController < ApplicationController
  # GET /final_bills
  # GET /final_bills.xml
  def index
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
    @final_bill = FinalBill.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@org.org_code}'"
   
	
	 respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @final_bill }
    end
  end

  def insurance_index
    @final_bill = FinalBill.all
	 respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @final_bill }
    end
  
  end
  
  # GET /final_bills/1
  # GET /final_bills/1.xml
  def show
	@final_bill = FinalBill.find(params[:id])
	@reg=Registration.find_by_mr_no_and_org_code(@final_bill.mr_no,@final_bill.org_code)
	
	if(@final_bill)
    @ward_changes=BedTransfer.find(:all, :conditions => " admn_no ='#{@final_bill.admn_no}' and org_code = '#{@final_bill.org_code}'")
    @consultation_visit_entries=ConsultantVisit.find(:all, :conditions => " admn_no ='#{@final_bill.admn_no}' and org_code = '#{@final_bill.org_code}'")
    @admission=Admission.find_by_admn_no_and_org_code(@final_bill.admn_no,@final_bill.org_code)
    @total_amount=@final_bill.gross_amount
	@advance=@final_bill.advance
	@due=@final_bill.balance_amount 
    @paid_amount=@final_bill.paid_amount 
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @final_bill }
	 end 
    end
  end

  # GET /final_bills/new
  # GET /final_bills/new.xml
  def new
    @final_bill = FinalBill.new
	#Get the org_code and org_location in people table based on user id.
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	10.times{ @final_bill.final_charges.build }
	
	@charge=ChargeMaster.all(:conditions => "service_group='GeneralServices'")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @final_bill }
    end
  end

  
  def insurance_new
	@final_bill = FinalBill.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	
	10.times{ @final_bill.final_charges.build }
	@admission=Admission.find(:all,:conditions => "org_code='#{@org_code}' and admn_status='Admitted'", :order =>"id DESC")
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @final_bill }
    end
  end
  # GET /final_bills/1/edit
  def edit
	
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
    @final_bill = FinalBill.find(params[:id])
	@registration=Registration.find_by_mr_no_and_org_code(@final_bill.mr_no,@final_bill.org_code)
	@admission1=Admission.find_by_admn_no_and_org_code(@final_bill.admn_no, @final_bill.org_code)
	@admission=Admission.find(:all,:conditions => "org_code='#{@person.org_code}' and admn_status='Admitted'", :order =>"id DESC")
	@first_name=@registration.patient_name
	@charge=ChargeMaster.all(:conditions => "service_group='GeneralServices'")
	@floor=@admission1.floor
	@ward=@admission1.ward
	@room=@admission1.room
	@bed=@admission1.bed
  end

  # POST /final_bills
  # POST /final_bills.xml
  def create
    	@final_bill = FinalBill.new(params[:final_bill])
	
	@charge=ChargeMaster.all(:conditions => "service_group='GeneralServices'")
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	
	respond_to do |format|
      if @final_bill.save
		@n=Number.new
		update_reciept_value=@n.retrive_value("receipt",@final_bill.org_code)
	 	@final_bill.receipt_no=update_reciept_value
		@admission=Admission.find_by_admn_no_and_org_code( @final_bill.admn_no, @final_bill.org_code) 
		@ward=WardMaster.find_by_name_and_org_code(@admission.ward,@admission.org_code) 
		@room=RoomMaster.find_by_ward_master_id_and_name_and_org_code(@ward.id, @admission.room, @admission.org_code) 
		@bed=BedMaster.find_by_room_master_id_and_name_and_org_code(@room.id,@admission.bed,@admission.org_code)
		    @bed.status="Available"
		@beds=@room.no_of_beds
		@room.no_of_beds=@beds.to_i+1
		@admission.admn_status="Discharged"
		@n=Number.find_by_name_and_org_code("receipt",@final_bill.org_code)
		@n.value=@final_bill.receipt_no
		@n.update_attributes(params[:n])
		@admission.update_attributes(params[:admission])
	    	@bed.update_attributes(params[:bed_master])
		@room.update_attributes(params[:room_master])
		if(@final_bill.admn_category=="Package")
			registration=Registration.last(:conditions =>"mr_no='#{@final_bill.mr_no}'")
			if(registration.reg_type=="General")
				format.html { redirect_to("/final_bills/report1/#{@final_bill.id}?print_type=original&format=pdf") }
			else
				format.html { redirect_to("/final_bills/report1/#{@final_bill.id}?print_type=original&format=pdf") }
			end
		else 
			registration=Registration.last(:conditions =>"mr_no='#{@final_bill.mr_no}'")
			if(registration.reg_type=="General")
				format.html { redirect_to("/final_bills/report1/#{@final_bill.id}?print_type=original&format=pdf") }
			else
				format.html { redirect_to("/final_bills/report1/#{@final_bill.id}?print_type=original&format=pdf") }
			end
		end
        format.xml  { render :xml => @final_bill, :status => :created, :location => @final_bill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @final_bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /final_bills/1
  # PUT /final_bills/1.xml
  def update
    @final_bill = FinalBill.find(params[:id])

    respond_to do |format|
      if @final_bill.update_attributes(params[:final_bill])

  if(@final_bill.admn_category=="Package")
			registration=Registration.last(:conditions =>"mr_no='#{@final_bill.mr_no}'")
			if(registration.reg_type=="General")
				format.html { redirect_to("/final_bills/report1/#{@final_bill.id}?print_type=original&format=pdf") }
			else
				format.html { redirect_to("/final_bills/report1/#{@final_bill.id}?print_type=original&format=pdf") }
			end
		else 
			registration=Registration.last(:conditions =>"mr_no='#{@final_bill.mr_no}'")
			if(registration.reg_type=="General")
				format.html { redirect_to("/final_bills/report1/#{@final_bill.id}?print_type=original&format=pdf") }
			else
				format.html { redirect_to("/final_bills/report1/#{@final_bill.id}?print_type=original&format=pdf") }
			end
		end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @final_bill.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  
  def print
     advance=AdvancePayment.new
	 @final_bill = FinalBill.find(params[:id])
	 @admission=Admission.find_by_admn_no_and_org_code(@final_bill.admn_no, @final_bill.org_code)
			@investigation=Investigation.find(:all, :conditions => " admn_no ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")
			@ward_changes=BedTransfer.find(:all, :conditions => " admn_no ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")
			@consultation_visit_entries=ConsultantVisit.find(:all, :conditions => " admn_no ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")
			#@operation_details=OperationDetailsForOt.find(:all, :conditions => " admn_no ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")
			@nurse_charge=NurseCharging.find(:all, :conditions => " admno ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")
			@total_amount,@advance,@due=advance.payment_details(@admission.admn_no,@final_bill.org_code)
			@registration=Registration.find_by_mr_no_and_org_code(@admission.mr_no,params[:org_code])
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @final_bill }
    end
  end
  
  
  # DELETE /final_bills/1
  # DELETE /final_bills/1.xml
  def destroy
    @final_bill = FinalBill.find(params[:id])
    @final_bill.destroy

    respond_to do |format|
      format.html { redirect_to(final_bills_url) }
      format.xml  { head :ok }
    end
  end

def approximate_bill
	
	
	#Get the org_code and org_location in people table based on user id.
	@people=Person.find_by_id(params[:user_id])

	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location

	
  end
  
 
  
    def casesheet
	@final_bill = FinalBill.new
	#Get the org_code and org_location in people table based on user id.
	@people=Person.find_by_id(params[:user_id])
	if(@people.code_option=="0")
		@org_code=@people.org_code
		@org_location=@people.org_location
	else
		transfer_data=TransferData.new
		@org_code=transfer_data.get_org_codes(@people.port_number)
	end
	
  end
  
  def ajax_function
	
	type=params[:type]
	if(type=="concession_authority")
		@authorizationmaster=Authorizationmaster.find_by_org_code_and_emp_name(params[:org_code],params[:concession])
		render :text=>@authorizationmaster.concession_limit
	else
		number=Number.new
		update_reciept_value=number.retrive_value("receipt",params[:org_code])
		advance=AdvancePayment.new
		@nurse_charge=0
		if(params[:type]=="approximate")
		@admission=Admission.find_by_admn_no_and_org_code(params[:admn_no],params[:org_code])
			if(@admission)
				if(@admission.admn_category=="Package")
    					@total_amount=@admission.amount.to_f
    					advance_package=AdvancePayment.sum(:gross_amount,:conditions =>"admn_no = '#{@admission.admn_no}' and org_code = '#{@admission.org_code}'")
    					if(advance_package)
						@advance=advance_package.to_i
    					else
     						@advance=0
    					end
					admn_date=@admission.admn_date+4
					extra_days=(Date.today-admn_date).to_i
					if((Date.today-admn_date).to_i>0)
						ward=WardMaster.find_by_name_and_org_code(@admission.ward,@admission.org_code)
						@total_amount=@admission.amount.to_f+((Date.today-admn_date).to_i*ward.cost.to_f)
						extra_charge=(Date.today-admn_date).to_i*ward.cost.to_f
					end
    					@due=@total_amount-@advance
   				else
    					@total_amount,@advance,@due,@nurse_charge=advance.payment_details(params[:admn_no],params[:org_code],Time.new.strftime("%H:%M"),"general")
					
   				end
				@admission=Admission.find_by_admn_no_and_org_code(params[:admn_no],params[:org_code])
				@investigation=TestBooking.find(:all, :conditions => " admn_no ='#{params[:admn_no]}' and org_code = '#{params[:org_code]}'")
				@ward_changes=BedTransfer.find(:all, :conditions => " admn_no ='#{params[:admn_no]}' and org_code = '#{params[:org_code]}'")
				@consultation_visit_entries=ConsultantVisit.find_by_admn_no(params[:admn_no])
			if(@consultation_visit_entries)
				@consultation_visit_entries1= ConsultantVisitChild.find(:all, :conditions=>"consultant_visit_id='#{@consultation_visit_entries.id}'")
			end
				@issues_to_ip=IssuesToOp.find(:all, :conditions => " admn_no ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")
				render :partial => "approximate_bill_result"
			else
				render :text =>"Invalid Admn.No"
			end
		else
			@admission=Admission.find_by_id_and_org_code(params[:admn_no],params[:org_code])
			@registration=Registration.find_by_mr_no_and_org_code(@admission.mr_no,params[:org_code])
			if(@registration.reg_type=="Arogyasree")
				@total_amount,@advance,@due,nurse_charge,ot,bed,consultant,@investigation_charges,@pharmacy=advance.payment_details(@admission.admn_no,params[:org_code], params[:bill_time],params[:category])
				render :text => @admission.admn_no+"<division>"+@registration.mr_no+"<division>"+update_reciept_value.to_s+"<division>"+@registration.title+"."+@registration.patient_name+"<division>"+@admission.floor+"<division>"+@admission.ward+"<division>"+@admission.room+"<division>"+@admission.bed+"<division>"+(@total_amount.to_i).to_s+"<division>"+(@advance.to_i).to_s+"<division>"+(@due.to_i).to_s+"<division>"+ot.to_s+"<division>"+bed.to_s+"<division>"+consultant.to_s+"<division>"+(@investigation_charges.to_i).to_s+"<division>"+(nurse_charge.to_i).to_s+"<division>"+@pharmacy.to_s+"<division>Arogyasree"

			else
				#@investigation=Investigation.find(:all, :conditions => " admn_no ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")
				@ward_changes=BedTransfer.find(:all, :conditions => " admn_no ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")
				@consultation_visit_entries=ConsultantVisit.find(:all, :conditions => " admn_no ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")
				@issues_to_ip=IssuesToOp.find(:all, :conditions => " admn_no ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")
				if(@admission.admn_category=="Package")
						@total_amount=@admission.amount.to_f
						advance_package=AdvancePayment.sum(:gross_amount, :conditions =>"admn_no = '#{@admission.admn_no}' and org_code = '#{@admission.org_code}'")
						if(advance_package)
						@advance=advance_package.to_i
						else
							@advance=0
						end
					admn_date=@admission.admn_date+@admission.days.to_i
					extra_days=(Date.today-admn_date).to_i
					if((Date.today-admn_date).to_i>0)
						ward=WardMaster.find_by_name_and_org_code(@admission.ward,@admission.org_code)
						 
						@total_amount=@admission.amount.to_f+((Date.today-admn_date).to_i*ward.cost.to_f)
						extra_charge=(Date.today-admn_date).to_i*ward.cost.to_f
					else 
						extra_days=0
					end
					@due=@total_amount-@advance
					render :text => @admission.admn_no+"<division>"+@registration.mr_no+"<division>"+update_reciept_value.to_s+"<division>"+@registration.title+"."+@registration.patient_name+"<division>"+@admission.floor+"<division>"+@admission.ward+"<division>"+@admission.room+"<division>"+@admission.bed+"<division>"+(@total_amount.to_i).to_s+"<division>"+(@advance.to_i).to_s+"<division>"+(@due.to_i).to_s+"<division>"+""+"<division>"+""+"<division>"+""+"<division>"+extra_charge.to_s+"<division>"+extra_days.to_s+"<division>"+"0"+"<division>"+"0"+"<division>"+"0"+"<division>"+"0"+"<division>"+"0"+"<division>"+"0"+"<division>"+"<division>General"	
				else

					@total_amount,@advance,@due,nurse_charge,ot,bed,consultant,@investigation_charges,@pharmacy=advance.payment_details(@admission.admn_no,params[:org_code], params[:bill_time],params[:category])
					render :text => @admission.admn_no+"<division>"+@registration.mr_no+"<division>"+update_reciept_value.to_s+"<division>"+@registration.title+"."+@registration.patient_name+"<division>"+@admission.floor+"<division>"+@admission.ward+"<division>"+@admission.room+"<division>"+@admission.bed+"<division>"+(@total_amount.to_i).to_s+"<division>"+(@advance.to_i).to_s+"<division>"+(@due.to_i).to_s+"<division>"+ot.to_s+"<division>"+bed.to_s+"<division>"+consultant.to_s+"<division>"+(@investigation_charges.to_i).to_s+"<division>"+"0"+"<division>"+@pharmacy.to_s+"<division>General"
				end
			end	
		end
		
	end
  end
   def select_org_code
	transfer_data=TransferData.new
	render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
  end

  def insurance_bills
	advance=AdvancePayment.new
	@admission=Admission.find_by_admn_no_and_org_code(params[:admn_no],params[:org_code])
	@total_amount,@advance,@due=advance.payment_details(params[:admn_no],params[:org_code],Time.new.strftime("%H:%M"),"general")
	@admission=Admission.find_by_admn_no_and_org_code(params[:admn_no],params[:org_code])
	@investigation=TestBooking.find(:all, :conditions => " admn_no ='#{params[:admn_no]}' and org_code = '#{params[:org_code]}'")
	@ward_changes=BedTransfer.find(:all, :conditions => " admn_no ='#{params[:admn_no]}' and org_code = '#{params[:org_code]}'")
	@consultation_visit_entries=ConsultantVisit.find(:all, :conditions => " admn_no ='#{params[:admn_no]}' and org_code = '#{params[:org_code]}'")
	@issues_to_ip=IssuesToOp.find(:all, :conditions => " admn_no ='#{@admission.admn_no}' and org_code = '#{params[:org_code]}'")

  end
  
  def package_report
	@people=Person.find_by_id(params[:user_id])

	
	@final_bill = FinalBill.find_by_id(params[:id])
	@admission = Admission.find_by_admn_no(@final_bill.admn_no)
   	@registration = Registration.find_by_mr_no(@final_bill.mr_no)
	
	@medicine=IssuesToOp.sum(:paid_amt, :conditions => "admn_no = '#{@final_bill.admn_no}' AND org_code = '#{@final_bill.org_code}'")
	@lab_charge=TestBooking.sum(:paid_amount, :conditions => "admn_no = '#{@final_bill.admn_no}'AND org_code = '#{@final_bill.org_code}'")
	@print_type=params[:print_type]
	
	number=Number.new
	@to_watds=number.number_to_words(@final_bill.paid_amount.to_i)
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 10,
      :right_margin => 10,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "#{@final_bill.final_bill_date.strftime("%d-%m-%y")}.pdf"

    render :layout => false
	
  end
  
  def insurance_package_report
	@people=Person.find_by_id(params[:user_id])

	
	@final_bill = FinalBill.find_by_id(params[:id])
	@admission = Admission.find_by_admn_no(@final_bill.admn_no)
   	@registration = Registration.last(:conditions => "mr_no='#{@final_bill.mr_no}'")
	
	@medicine=IssuesToOp.sum(:paid_amt, :conditions => "admn_no = '#{@final_bill.admn_no}' AND org_code = '#{@final_bill.org_code}'")
	@lab_charge=TestBooking.sum(:paid_amount, :conditions => "admn_no = '#{@final_bill.admn_no}'AND org_code = '#{@final_bill.org_code}'")
	@print_type=params[:print_type]
	
	number=Number.new
	@to_watds=number.number_to_words(@final_bill.paid_amount.to_i)
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 10,
      :right_margin => 10,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "#{@final_bill.final_bill_date.strftime("%d-%m-%y")}.pdf"

    render :layout => false
  
  end
  
  def insurance_report
	@people=Person.find_by_id(params[:user_id])

	
	@final_bill = FinalBill.find_by_id(params[:id])
	@admission = Admission.find_by_admn_no(@final_bill.admn_no)
   	@registration = Registration.last(:conditions => "mr_no='#{@final_bill.mr_no}'")
	
	@medicine=IssuesToOp.sum(:paid_amt, :conditions => "admn_no = '#{@final_bill.admn_no}' AND org_code = '#{@final_bill.org_code}'")
	@lab_charge=TestBooking.sum(:paid_amount, :conditions => "admn_no = '#{@final_bill.admn_no}'AND org_code = '#{@final_bill.org_code}'")
	@print_type=params[:print_type]
	
	number=Number.new
	@to_watds=number.number_to_words(@final_bill.paid_amount.to_i)
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 10,
      :right_margin => 10,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "#{@final_bill.final_bill_date.strftime("%d-%m-%y")}.pdf"

    render :layout => false
  
  end
  
def report1
  	@people=Person.find_by_id(params[:user_id])

	@final_bill = FinalBill.find_by_id(params[:id])
	@admission = Admission.find_by_admn_no(@final_bill.admn_no)

   	@registration = Registration.find_by_mr_no(@final_bill.mr_no)
	@medicine=IssuesToOp.sum(:paid_amt, :conditions => "admn_no = '#{@final_bill.admn_no}' AND org_code = '#{@final_bill.org_code}'")
	@lab_charge=TestBooking.sum(:total_amount, :conditions => "admn_no = '#{@final_bill.admn_no}'AND org_code = '#{@final_bill.org_code}'")
	@print_type=params[:print_type]
	number=Number.new
	@to_watds=number.number_to_words(@final_bill.paid_amount.to_i)
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 10,
      :right_margin => 10,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "report1.pdf"

    render :layout => false
	
  end  
  
  def final_charges
	@charge=ChargeMaster.find_by_service_group_and_service_name('GeneralServices',params[:charge_type])
	if(@charge)
		render :text => @charge.charge
	else
		render :text => "error"
	end
  end
  
  def observe_field_ex
  	@final_bill = FinalBill.find(:all,:conditions=>"admn_no LIKE'%#{params[:admn_no]}' AND mr_no LIKE '%#{params[:mr_no]}' AND final_bill_date LIKE '#{params[:final_bill_date]}%' AND gross_amount LIKE '#{params[:gross_amount]}%'AND advance LIKE '#{params[:advance]}%'AND due LIKE '#{params[:due]}%'")
		if( @final_bill[0])
		   render:partial=>"search_final_bills"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  

  end 
end

