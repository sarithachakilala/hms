class CityMastersController < ApplicationController
  # GET /city_masters
  # GET /city_masters.xml
  
  def index
  
	@city_masters = CityMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
	 format.xml  { render :xml => @city_masters }
	 format.html # index.html.erb
      
    end
  end
  # GET /city_masters/1
  # GET /city_masters/1.xml
  def show
   	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)									
    @city_master = CityMaster.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @city_master }
    end
  end

  # GET /city_masters/new
  # GET /city_masters/new.xml
  def new
    @city_master = CityMaster.new
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @city_master }
    end
  end

  # GET /city_masters/1/edit
  def edit
    @city_master = CityMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	
  end

  # POST /city_masters
  # POST /city_masters.xml
  def create
    @city_master = CityMaster.new(params[:city_master])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@city= StateMaster.find_by_name(params[:state_name])
	if(@city)
		@city_master.state_master_id=@city.id
	end
    respond_to do |format|
      if @city_master.save
        format.html { redirect_to("/city_masters/new", :notice => 'CityMaster was successfully created.') }
        format.xml  { render :xml => @city_master, :status => :created, :location => @city_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @city_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /city_masters/1
  # PUT /city_masters/1.xml
  def update
   @user_id = params[:user_id]	
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)   
    @city_master = CityMaster.find(params[:id])
	@city= StateMaster.find_by_name(params[:state_name])
	if(@city)
		@city_master.state_master_id=@city.id
	end
    respond_to do |format|
      if @city_master.update_attributes(params[:city_master])
        format.html { redirect_to("/city_masters/new", :notice => 'CityMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @city_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /city_masters/1
  # DELETE /city_masters/1.xml
  def destroy
    @city_master = CityMaster.find(params[:id])
    @city_master.destroy

    respond_to do |format|
      format.html { redirect_to(city_masters_url) }
      format.xml  { head :ok }
    end
  end
   def search
	 @city_masters = CityMaster.find(:all, :conditions => "name LIKE '#{params[:city_name]}%'")
	render :partial => "city_master_record"
  end
  
end
