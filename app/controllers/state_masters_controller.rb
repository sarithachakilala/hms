class StateMastersController < ApplicationController
  # GET /state_masters
  # GET /state_masters.xml
  def index
  @state_masters = StateMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
  @user_id = params[:user_id]
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)

        respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @state_masters }
    end
  end

  # GET /state_masters/1
  # GET /state_masters/1.xml
  def show
   @state_master = StateMaster.find(params[:id])
 @user_id = params[:user_id]
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)

   

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @state_master }
    end
  end

  # GET /state_masters/new
  # GET /state_masters/new.xml
  def new
	@state_master = StateMaster.new
	@org=Person.find_by_id(@user_id)
	@country_masters = CountryMaster.find(:all)
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
		 respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @state_master }
    end
  end

  # GET /state_masters/1/edit
  def edit
    @state_master = StateMaster.find(params[:id])
     @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org=Person.find_by_id(@user_id)
	
  end
    
    # POST /state_masters
  # POST /state_masters.xml
  def create
  @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
		@state_master = StateMaster.new(params[:state_master])
		@country= CountryMaster.find_by_name(params[:country_name])
if(@country)
		@state_master.country_master_id=@country.id
end

	
    respond_to do |format|
      if @state_master.save
        format.html { redirect_to("/state_masters/new", :notice => 'StateMaster was successfully created.') }
        format.xml  { render :xml => @state_master, :status => :created, :location => @state_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @state_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /state_masters/1
  # PUT /state_masters/1.xml
  def update
    @state_master = StateMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@country= CountryMaster.find_by_name(params[:country_name])
	if(@country)
	@state_master.country_master_id=@country.id
	end
    respond_to do |format|
      if @state_master.update_attributes(params[:state_master])
        format.html { redirect_to("/state_masters/new", :notice => 'StateMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @state_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /state_masters/1
  # DELETE /state_masters/1.xml
  def destroy
    @state_master = StateMaster.find(params[:id])
    @state_master.destroy

    respond_to do |format|
      format.html { redirect_to(state_masters_url) }
      format.xml  { head :ok }
    end
  end
  
   def select_org_code
	transfer_data=TransferData.new
	render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
  end
  
   def search
	 @state_masters = StateMaster.find(:all, :conditions => "name LIKE '#{params[:state_name]}%'")
	render :partial => "state_master_record"
  end
  
end
