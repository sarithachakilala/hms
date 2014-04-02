class EmployeeMastersController < ApplicationController
  # GET /employee_masters
  # GET /employee_masters.xml
  def index
    @employee_masters = EmployeeMaster.all
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@employee_masters = EmployeeMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @employee_masters }
    end
  end

  # GET /employee_masters/1
  # GET /employee_masters/1.xml
  def show
    @employee_master = EmployeeMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @employee_master }
    end
  end

  # GET /employee_masters/new
  # GET /employee_masters/new.xml
  def new
    @employee_master = EmployeeMaster.new
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @employee_master }
    end
  end

  # GET /employee_masters/1/edit
  def edit
    @employee_master = EmployeeMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /employee_masters
  # POST /employee_masters.xml
  def create
    @employee_master = EmployeeMaster.new(params[:employee_master])
	if(@employee_master.category=="Consultant")
		@employee_master.name="Dr."<<@employee_master.name
	end
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @employee_master.save
        format.html { redirect_to("/employee_masters/new", :notice => 'EmployeeMaster was successfully created.') }
        format.xml  { render :xml => @employee_master, :status => :created, :location => @employee_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @employee_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /employee_masters/1
  # PUT /employee_masters/1.xml
  def update
    @employee_master = EmployeeMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @employee_master.update_attributes(params[:employee_master])
        format.html { redirect_to("/employee_masters/new", :notice => 'EmployeeMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @employee_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /employee_masters/1
  # DELETE /employee_masters/1.xml
  def destroy
    @employee_master = EmployeeMaster.find(params[:id])
    @employee_master.destroy

    respond_to do |format|
      format.html { redirect_to(employee_masters_url) }
      format.xml  { head :ok }
    end
  end
  
  def ajax_buildings
	category=params[:category]
		@category=DepartmentMaster.find(:all, :conditions => "category='#{category}'")
			str=""
			for i in 0...@category.length 
			str<<@category[i].department+"<division>"
			
			end
			render :text =>str
	
  end
  def search
	 @employee_masters = EmployeeMaster.find(:all, :conditions => "name LIKE '#{params[:name]}%'")
		render :partial => "search_employee_record"
  end
  
end
