class RefferalMastersController < ApplicationController
  # GET /refferal_masters
  # GET /refferal_masters.xml
  def index
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @refferal_masters = RefferalMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @refferal_masters }
    end
  end

  # GET /refferal_masters/1
  # GET /refferal_masters/1.xml
  def show
    @refferal_master = RefferalMaster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @refferal_master }
    end
  end

  # GET /refferal_masters/new
  # GET /refferal_masters/new.xml
  def new
    @refferal_master = RefferalMaster.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
	if(params[:call_from])
		@call_from="registrations"
	else
		@call_from="new"
	end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @refferal_master }
    end
  end

  # GET /refferal_masters/1/edit
  def edit
    @refferal_master = RefferalMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /refferal_masters
  # POST /refferal_masters.xml
  def create
    @refferal_master = RefferalMaster.new(params[:refferal_master])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @refferal_master.save
        format.html { redirect_to("/refferal_masters/show/#{@refferal_master.id}", :notice => 'RefferalMaster was successfully created.') }
        format.xml  { render :xml => @refferal_master, :status => :created, :location => @refferal_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @refferal_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /refferal_masters/1
  # PUT /refferal_masters/1.xml
  def update
    @refferal_master = RefferalMaster.find(params[:id])

    respond_to do |format|
      if @refferal_master.update_attributes(params[:refferal_master])
        format.html { redirect_to("/refferal_masters/new", :notice => 'RefferalMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @refferal_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /refferal_masters/1
  # DELETE /refferal_masters/1.xml
  def destroy
    @refferal_master = RefferalMaster.find(params[:id])
    @refferal_master.destroy

    respond_to do |format|
      format.html { redirect_to(refferal_masters_url) }
      format.xml  { head :ok }
    end
  end
  
   def search
	 @referral_masters = ReferralMaster.find(:all, :conditions => "refferal_name LIKE '#{params[:name]}%'")
		render :partial => "search_referral_record"
  end
end
