class ChargeMastersController < ApplicationController
  # GET /charge_masters
  # GET /charge_masters.xml
  def index
    @charge_masters = ChargeMaster.all
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	
	@charge_masters = ChargeMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @charge_masters }
    end
  end

  # GET /charge_masters/1
  # GET /charge_masters/1.xml
  def show
    @charge_master = ChargeMaster.find(params[:id])
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @charge_master }
    end
  end

  # GET /charge_masters/new
  # GET /charge_masters/new.xml
  def new
    @charge_master = ChargeMaster.new
	 @session_id=session[:id]
		@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
	@insurance=InsuranceMaster.find(:all,:conditions => "org_code = '#{@org_code}'")
	j=0
	@insurance.length.times{
		charge_master=@charge_master.charge_master_children.build
		charge_master.reg_type="Insurance"	
		charge_master.name=@insurance[j].company_name
		charge_master.discount_price=0
		charge_master.discount_persentage=0
		charge_master.amount=0
		j+=1
	}	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @charge_master }
    end
  end

  # GET /charge_masters/1/edit
  def edit
    @charge_master = ChargeMaster.find(params[:id])
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /charge_masters
  # POST /charge_masters.xml
  def create
    @charge_master = ChargeMaster.new(params[:charge_master])
 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @charge_master.save
        format.html { redirect_to("/charge_masters/new", :notice => 'ChargeMaster was successfully created.') }
        format.xml  { render :xml => @charge_master, :status => :created, :location => @charge_master }
      else
		   @insurance=InsuranceMaster.find(:all,:conditions => "org_code = '#{@charge_master.org_code}'")
			j=0
			@insurance.length.times{
				charge_master=@charge_master.charge_master_children.build
				charge_master.reg_type="Insurance"	
				charge_master.name=@insurance[j].company_name
				charge_master.discount_price=0
				charge_master.discount_persentage=0
				charge_master.amount=0
				j+=1
			}	
        format.html { render :action => "new" }
        format.xml  { render :xml => @charge_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /charge_masters/1
  # PUT /charge_masters/1.xml
  def update
    @charge_master = ChargeMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @charge_master.update_attributes(params[:charge_master])
        format.html { redirect_to("/charge_masters/new", :notice => 'ChargeMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @charge_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /charge_masters/1
  # DELETE /charge_masters/1.xml
  def destroy
    @charge_master = ChargeMaster.find(params[:id])
    @charge_master.destroy

    respond_to do |format|
      format.html { redirect_to(charge_masters_url) }
      format.xml  { head :ok }
    end
  end
  
  def ajax_function
	str=""
	@tests=Testmaster.find(:all, :conditions => "department_name = '#{params[:service_name]}'", :order => "department_name ASC")
	for test in @tests
			str<<test.test_name+"<division>"
	end
	render :text => str
  end

   def search
	 @charge_masters = ChargeMaster.find(:all, :conditions => "test_name LIKE '#{params[:testname]}%'")
	render :partial => "charge_masters_record"
  end
end
