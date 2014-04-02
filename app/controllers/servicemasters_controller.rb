class ServicemastersController < ApplicationController
  # GET /servicemasters
  # GET /servicemasters.xml
  def index
    @servicemasters = Servicemaster.all
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
@servicemasters = Servicemaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @servicemasters }
    end
  end

  # GET /servicemasters/1
  # GET /servicemasters/1.xml
  def show
    @servicemaster = Servicemaster.find(params[:id])
 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @servicemaster }
    end
  end

  # GET /servicemasters/new
  # GET /servicemasters/new.xml
  def new
    @servicemaster = Servicemaster.new
 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @servicemaster }
    end
  end

  # GET /servicemasters/1/edit
  def edit
    @servicemaster = Servicemaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /servicemasters
  # POST /servicemasters.xml
  def create
    @servicemaster = Servicemaster.new(params[:servicemaster])
 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @servicemaster.save
        format.html { redirect_to("/servicemasters/new", :notice => 'Servicemaster was successfully created.') }
        format.xml  { render :xml => @servicemaster, :status => :created, :location => @servicemaster }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @servicemaster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /servicemasters/1
  # PUT /servicemasters/1.xml
  def update
    @servicemaster = Servicemaster.find(params[:id])
 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @servicemaster.update_attributes(params[:servicemaster])
        format.html { redirect_to("/servicemasters/new", :notice => 'Servicemaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @servicemaster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /servicemasters/1
  # DELETE /servicemasters/1.xml
  def destroy
    @servicemaster = Servicemaster.find(params[:id])
    @servicemaster.destroy

    respond_to do |format|
      format.html { redirect_to(servicemasters_url) }
      format.xml  { head :ok }
    end
  end
  def search
  
	 @servicemasters = Servicemaster.find(:all, :conditions => "service_name LIKE '#{params[:service_name]}%'")
	 render :partial => "service_masters_record"
  end
  
end
