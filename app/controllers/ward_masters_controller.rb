class WardMastersController < ApplicationController
  # GET /ward_masters
  # GET /ward_masters.xml
  def index
    @ward_masters = WardMaster.all
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ward_masters }
    end
  end

  # GET /ward_masters/1
  # GET /ward_masters/1.xml
  def show
    @ward_master = WardMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ward_master }
    end
  end

  # GET /ward_masters/new
  # GET /ward_masters/new.xml
  def new
    @ward_master = WardMaster.new
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ward_master }
    end
  end

  # GET /ward_masters/1/edit
  def edit
    @ward_master = WardMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /ward_masters
  # POST /ward_masters.xml
  def create
    @ward_master = WardMaster.new(params[:ward_master])
	 @session = Session.find(session[:id])
  @person = Person.find(@session.person_id)
  @org_code = @person.org_code
  @org_location = @person.org_location
    respond_to do |format|
      if @ward_master.save
        format.html { redirect_to("/ward_masters/new", :notice => 'WardMaster was successfully created.') }
        format.xml  { render :xml => @ward_master, :status => :created, :location => @ward_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ward_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ward_masters/1
  # PUT /ward_masters/1.xml
  def update
    @ward_master = WardMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @ward_master.update_attributes(params[:ward_master])
        format.html { redirect_to("/ward_masters/new", :notice => 'WardMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ward_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ward_masters/1
  # DELETE /ward_masters/1.xml
  def destroy
    @ward_master = WardMaster.find(params[:id])
    @ward_master.destroy

    respond_to do |format|
      format.html { redirect_to(ward_masters_url) }
      format.xml  { head :ok }
    end
  end
   def search
	 @ward_masters = WardMaster.find(:all, :conditions => "name LIKE '#{params[:ward_name]}%'")
	 render :partial => "search_ward"
  end
end
