class RoomMastersController < ApplicationController
  # GET /room_masters
  # GET /room_masters.xml
  def index
		
	@room_masters = RoomMaster.find(:all)
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @room_masters }
    end
  end

  # GET /room_masters/1
  # GET /room_masters/1.xml
  def show
    @room_master = RoomMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @room_master }
    end
  end

  # GET /room_masters/new
  # GET /room_masters/new.xml
  def new
    @room_master = RoomMaster.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @room_master }
    end
  end

  # GET /room_masters/1/edit
  def edit
    @room_master = RoomMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /room_masters
  # POST /room_masters.xml
  def create
    @room_master = RoomMaster.new(params[:room_master])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@ward = WardMaster.find_by_name(params[:ward])   
	if(@ward )
	@room_master.ward_master_id=@ward.id
	end
    respond_to do |format|
      if @room_master.save
        format.html { redirect_to("/room_masters/new", :notice => 'RoomMaster was successfully created.') }
        format.xml  { render :xml => @room_master, :status => :created, :location => @room_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @room_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /room_masters/1
  # PUT /room_masters/1.xml
  def update
    @room_master = RoomMaster.find(params[:id])
		@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@ward = WardMaster.find_by_name(params[:ward])
	if(@ward)
		@room_master.ward_master_id=@ward.id
	end
    respond_to do |format|
      if @room_master.update_attributes(params[:room_master])
        format.html { redirect_to("/room_masters/new", :notice => 'RoomMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @room_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /room_masters/1
  # DELETE /room_masters/1.xml
  def destroy
    @room_master = RoomMaster.find(params[:id])
    @room_master.destroy
    respond_to do |format|
      format.html { redirect_to(room_masters_url) }
      format.xml  { head :ok }
    end
  end

   def search
	 @room_masters = RoomMaster.find(:all, :conditions => "name LIKE '#{params[:room_name]}%'")
	 render :partial => "room_search"
  end
  
end
