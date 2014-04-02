class DepartmentMastersController < ApplicationController
  # GET /department_masters
  # GET /department_masters.xml
  def index
    @department_masters = DepartmentMaster.all
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@department_masters = DepartmentMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @department_masters }
    end
  end

  # GET /department_masters/1
  # GET /department_masters/1.xml
  def show
    @department_master = DepartmentMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @department_master }
    end
  end

  # GET /department_masters/new
  # GET /department_masters/new.xml
  def new
    @department_master = DepartmentMaster.new
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @department_master }
    end
  end

  # GET /department_masters/1/edit
  def edit
    @department_master = DepartmentMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)

	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /department_masters
  # POST /department_masters.xml
  def create
	@department_master = DepartmentMaster.new(params[:department_master])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @department_master.save
        format.html { redirect_to("/department_masters/new", :notice => 'DepartmentMaster was successfully created.') }
        format.xml  { render :xml => @department_master, :status => :created, :location => @department_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @department_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /department_masters/1
  # PUT /department_masters/1.xml
  def update
    @department_master = DepartmentMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @department_master.update_attributes(params[:department_master])
        format.html { redirect_to("/department_masters/new", :notice => 'DepartmentMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @department_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /department_masters/1
  # DELETE /department_masters/1.xml
  def destroy
    @department_master = DepartmentMaster.find(params[:id])
    @department_master.destroy

    respond_to do |format|
      format.html { redirect_to(department_masters_url) }
      format.xml  { head :ok }
    end
  end
  def search
	 @department_masters = DepartmentMaster.find(:all, :conditions => "department LIKE '#{params[:deptname]}%'")
	render :partial => "department_masters_record"
  end
end
