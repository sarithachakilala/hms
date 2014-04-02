class InsuranceMastersController < ApplicationController
  # GET /insurance_masters
  # GET /insurance_masters.xml
  require 'csv'
  def index
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @insurance_masters = InsuranceMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@person.org_code}'"
	

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @insurance_masters }
    end
  end

  
  def insurance_reporting
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
  end
  
  # GET /insurance_masters/1
  # GET /insurance_masters/1.xml
  def show
	  @insurance_master = InsuranceMaster.find(params[:id])
	
    if(params[:call_from])
      @call_from="registrations"
    else
      @call_from="new"
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @insurance_master }
    end
  end
  def print
	@insurance_master = InsuranceMaster.find(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @companies_master }
    end
  end

  # GET /insurance_masters/new
  # GET /insurance_masters/new.xml
  def new
	
    @insurance_master = InsuranceMaster.new
  	@session_id=session[:id]
	  @session = Session.find(session[:id])
	  @person = Person.find(@session.person_id)
	  @org_code=@person.org_code
	  @org_location=@person.org_location
	  if(params[:call_from])
      @call_from="registrations"
    else
      @call_from="new"
    end

	@cde=InsuranceMaster.last
	if(@cde)
		@t_no=(@cde.code.to_i+1).to_s
		
	else
		@t_no="666000"
	end
	@insurance_master.code=@t_no
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @insurance_master }
    end
  end

  # GET /insurance_masters/1/edit
  def edit
	@insurance_master = InsuranceMaster.find(params[:id])
  end

  # POST /insurance_masters
  # POST /insurance_masters.xml
  def create
    @insurance_master = InsuranceMaster.new(params[:insurance_master])
	
	@cde=InsuranceMaster.last(:conditions =>"org_code='#{@insurance_master.org_code}'")
	if(@cde)
		@t_no=(@cde.code.to_i+1).to_s
	else
		@t_no="666000"
	end
  if(params[:call_from])
      @call_from="registrations"
  else
    @call_from="new"
  end
	@insurance_master.code=@t_no
	
    respond_to do |format|
      if @insurance_master.save
        format.html { redirect_to("/insurance_masters/show/#{@insurance_master.id}?call_from=#{@call_from}", :notice => 'InsuranceMaster was successfully created.') }
        format.xml  { render :xml => @insurance_master, :status => :created, :location => @insurance_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @insurance_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /insurance_masters/1
  # PUT /insurance_masters/1.xml
  def update
    @insurance_master = InsuranceMaster.find(params[:id])

    respond_to do |format|
      if @insurance_master.update_attributes(params[:insurance_master])
        format.html { redirect_to("/insurance_masters/new?user_id=#{params[:user_id]}", :notice => 'InsuranceMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @insurance_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /insurance_masters/1
  # DELETE /insurance_masters/1.xml
  def destroy
    @insurance_master = InsuranceMaster.find(params[:id])
    @insurance_master.destroy

    respond_to do |format|
      format.html { redirect_to(insurance_masters_url) }
      format.xml  { head :ok }
    end
  end
  def select_city
  
	@city=CityMaster.find_by_name(params[:city_name])
	@state=StateMaster.find_by_id(@city.state_master_id)
	@country=CountryMaster.find_by_id(@state.country_master_id)
	render :js =>"
		document.getElementById('state').style.background='#FEF5CA';
		document.getElementById('state').readOnly=true;
		document.getElementById('country').style.background='#FEF5CA';
		document.getElementById('country').readOnly=true;
		document.getElementById('state').value='#{@state.name}';
   		document.getElementById('country').value='#{@country.name}';
	"
  end
  
    def find_report
		from_date=params[:from_date]
		to_date=params[:to_date]
		insurance=params[:insurance]
		org_code=params[:org_code]
	
		if(from_date!="" && to_date!="")
			query=["reg_date BETWEEN ? AND ? AND org_code Like '#{org_code}%' AND ins_company_name LIKE  '#{insurance}%' and reg_type='Insurance'",from_date,to_date]	
		end
		if(query)	
			@rig=Registration.new
			@rig.store_key(query)
			@rig1=Registration.find(:all, :conditions => query)
			render :partial => "insurance_reporting"
		else 
			render :text => "please enter any value"
		end
		
	
	
	end
	
	def generate_reports
	
		@insurance= Registration.find(:all, :conditions =>"reg_date BETWEEN '#{params[:from_date]}' AND '#{params[:to_date]}' AND reg_type ='Insurance'")
		report = StringIO.new
		CSV::Writer.generate(report, ',') do |title|
			title << ['Patient Name','MR No','Reg.Date','Age','Gender','Address','Ph.No','Insurance Com.Name','Policy No','Plan Name']
			@insurance.each do |a|
				title << [a.patient_name,a.mr_no,a.reg_date,a.age,a.gender,a.address,a.mobile_no,a.ins_company_name,a.policy_no,a.plan_name]
			end
		end
		report.rewind
		send_data(report.read,:type=>'text/csv;charset=iso-8859-1;header=present',:filename=>"Insurance_report_on_(#{Date.today}).csv",:disposition =>'attachment', :encoding => 'utf8')
    end
end
