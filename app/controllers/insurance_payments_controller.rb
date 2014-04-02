class InsurancePaymentsController < ApplicationController
  # GET /insurance_payments
  # GET /insurance_payments.xml
  def index
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@insurance_payments = InsurancePayment.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@person.org_code}'"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @insurance_payments }
    end
  end

  # GET /insurance_payments/1
  # GET /insurance_payments/1.xml
  def show
    @insurance_payment = InsurancePayment.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @registration=Registration.find_by_ins_no_and_org_code(@insurance_payment.ins_no,@insurance_payment.org_code)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @insurance_payment }
    end
  end

  # GET /insurance_payments/new
  # GET /insurance_payments/new.xml
  def new
    @insurance_payment = InsurancePayment.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location

	@registration=Registration.find(:all, :conditions =>"org_code ='#{@org_code}' and reg_type='Insurance'", :order =>"id DESC")
	@admission1=Admission.last(:conditions =>"admn_status!= 'Waiting To Admit' and org_code='#{@org_code}'")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @insurance_payment }
    end
  end

  # GET /insurance_payments/1/edit
  def edit
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @insurance_payment = InsurancePayment.find(params[:id])
	@registration=Registration.find_by_mr_no(@insurance_payment.mr_no)
	@user_id = params[:user_id]
  end

  # POST /insurance_payments
  # POST /insurance_payments.xml
  def create
    @insurance_payment = InsurancePayment.new(params[:insurance_payment])
	
    respond_to do |format|
      if @insurance_payment.save
        format.html { redirect_to("/insurance_payments/new", :notice => 'InsurancePayment was successfully created.') }
        format.xml  { render :xml => @insurance_payment, :status => :created, :location => @insurance_payment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @insurance_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /insurance_payments/1
  # PUT /insurance_payments/1.xml
  def update
    @insurance_payment = InsurancePayment.find(params[:id])
	@user_id = params[:user_id]
    respond_to do |format|
      if @insurance_payment.update_attributes(params[:insurance_payment])
        format.html { redirect_to("/insurance_payments/new", :notice => 'InsurancePayment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @insurance_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /insurance_payments/1
  # DELETE /insurance_payments/1.xml
  def destroy
    @insurance_payment = InsurancePayment.find(params[:id])
    @insurance_payment.destroy

    respond_to do |format|
      format.html { redirect_to(insurance_payments_url) }
      format.xml  { head :ok }
    end
  end
  
  def insurance_payment_report
	@people=Person.find_by_id(params[:user_id])
	if(@people.code_option=="0")
		@org_code1=@people.org_code
		@org_location=@people.org_location
		@org_codes=Array.new
		@person=Person.find(:all, :select =>"DISTINCT org_code")
		@org_codes[0]=@org_code
		i=1
		for person in @person
			@org_codes[i]=person.org_code
			i=i+1
		end
	else
		transfer_data=TransferData.new
		@org_codes=transfer_data.get_org_codes(@people.port_number)
	end
  end
  
  
  
  def ajax_buildings
	@admission=Admission.find_by_id(params[:admn_id])
	@registration=Registration.find_by_id(params[:reg_id])
	@discharge=DischargeSummary.find_by_admn_no_and_org_code(@admission.admn_no,@admission.org_code)
	dis_date=""
	if(@discharge)
		dis_date=@discharge.discharge_date.to_s
	end
	render :text => @registration.ins_company_name+"<division>"+@admission.admn_no+"<division>"+@registration.mr_no+"<division>"+@registration.title+"."+@registration.patient_name+"<division>"+dis_date.to_s+"<division>"+@admission.admn_date.to_s
  
  end
  
  def insurance_payments_report_ajax
	
	@insurance_payment = InsurancePayment.find(:al, :conditions => 
		"(admn_date BETWEEN '#{params[:date1]}' AND '#{params[:date2]}') AND
		 org_code LIKE '#{params[:org_code]}%' AND
		 status LIKE '#{params[:status]}'");
	
    render :partial => "insurance_payment"
  end
  
  def search
	@user_id=params[:user_id]
	@insurance_payments = InsurancePayment.find(:all,:conditions => "admn_no = '#{params[:t]}'")
	render :partial => "search_admission_records"
  end
end
