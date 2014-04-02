class ConsultantMastersController < ApplicationController
  # GET /consultant_masters
  # GET /consultant_masters.xml
  def index
    @consultant_masters = ConsultantMaster.all
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@consultant_masters = ConsultantMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultant_masters }
    end
  end

  # GET /consultant_masters/1
  # GET /consultant_masters/1.xml
  def show
    @consultant_master = ConsultantMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultant_master }
    end
  end

  # GET /consultant_masters/new
  # GET /consultant_masters/new.xml
  def new
    @consultant_master = ConsultantMaster.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
	@ward=WardMaster.find(:all)
	@length=@ward.length
	i=0
    @length.times{@consultant_master.ward_cost.build
		@consultant_master.ward_cost[i].ward=@ward[i].name
		i+=1
		}
		
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consultant_master }
    end
  end

  # GET /consultant_masters/1/edit
  def edit
    @consultant_master = ConsultantMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /consultant_masters
  # POST /consultant_masters.xml
  def create
    @consultant_master = ConsultantMaster.new(params[:consultant_master])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @consultant_master.save
        format.html { redirect_to("/consultant_masters/new", :notice => 'ConsultantMaster was successfully created.') }
        format.xml  { render :xml => @consultant_master, :status => :created, :location => @consultant_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultant_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /consultant_masters/1
  # PUT /consultant_masters/1.xml
  def update
    @consultant_master = ConsultantMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @consultant_master.update_attributes(params[:consultant_master])
        format.html { redirect_to("/consultant_masters/new", :notice => 'ConsultantMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consultant_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /consultant_masters/1
  # DELETE /consultant_masters/1.xml
  def destroy
    @consultant_master = ConsultantMaster.find(params[:id])
    @consultant_master.destroy

    respond_to do |format|
      format.html { redirect_to(consultant_masters_url) }
      format.xml  { head :ok }
    end
  end
  
  
 def ajax_function
	consultant=params[:consultant]
	selected_type=params[:selected_type]
	if(selected_type=="emp_id")
		@emp=EmployeeMaster.find_by_empid(consultant)
		render :text=>@emp.name+"<division>"+@emp.designation+"<division>"+@emp.phno
	end
end
def search
	 @consultant_masters = ConsultantMaster.find(:all, :conditions => "consultant_id LIKE '#{params[:consultantId]}%'")
	 render :partial => "search_consultant_masters"
  end
end
