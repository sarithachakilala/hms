class CountryMastersController < ApplicationController
  # GET /country_masters
  # GET /country_masters.xml
  def index
 
	@country_masters = CountryMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
	  @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @country_masters }
    end
  end

  # GET /country_masters/1
  # GET /country_masters/1.xml
  def show
    @country_master = CountryMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @country_master }
    end
  end

  # GET /country_masters/new
  # GET /country_masters/new.xml
  def new
    @country_master = CountryMaster.new
    	
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @country_master }
    end
  end

  # GET /country_masters/1/edit
  def edit
    @country_master = CountryMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
  end

  # POST /country_masters
  # POST /country_masters.xml
  def create
    @country_master = CountryMaster.new(params[:country_master])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @country_master.save
        format.html { redirect_to("/country_masters/new", :notice => 'CountryMaster was successfully created.') }
        format.xml  { render :xml => @country_master, :status => :created, :location => @country_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @country_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /country_masters/1
  # PUT /country_masters/1.xml
  def update
    @country_master = CountryMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @country_master.update_attributes(params[:country_master])
        format.html { redirect_to("/country_masters/new", :notice => 'CountryMaster was successfully created.', :notice => 'CountryMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @country_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /country_masters/1
  # DELETE /country_masters/1.xml
  def destroy
    @country_master = CountryMaster.find(params[:id])
    @country_master.destroy

    respond_to do |format|
      format.html { redirect_to(country_masters_url) }
      format.xml  { head :ok }
    end
  end
  
   def search
	 @country_masters = CountryMaster.find(:all, :conditions => "name LIKE '#{params[:country_name]}%'")
	render :partial => "country_master_record"
  end
  
end
#modified by jyothi on jan-11th
