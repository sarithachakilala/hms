class BedMastersController < ApplicationController
  # GET /bed_masters
  # GET /bed_masters.xml
  def index
    @bed_masters = BedMaster.all
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@bed_masters = BedMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bed_masters }
    end
  end

  # GET /bed_masters/1
  # GET /bed_masters/1.xml
  def show
    @bed_master = BedMaster.find(params[:id])
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bed_master }
    end
  end

  # GET /bed_masters/new
  # GET /bed_masters/new.xml
  def new
    @bed_master = BedMaster.new
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bed_master }
    end
  end

  # GET /bed_masters/1/edit
  def edit
    @bed_master = BedMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /bed_masters
  # POST /bed_masters.xml
  def create
    @bed_master = BedMaster.new(params[:bed_master])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@ward = WardMaster.find_by_name(params[:ward1])
if(@ward)
	@bed_master.ward_master_id=@ward.id
	@room = RoomMaster.find_by_name_and_ward_master_id(params[:room1],@ward.id)
	@bed_master.room_master_id=@room.id
end
    respond_to do |format|
      if @bed_master.save
        format.html { redirect_to("/bed_masters/new", :notice => 'BedMaster was successfully created.') }
        format.xml  { render :xml => @bed_master, :status => :created, :location => @bed_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bed_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bed_masters/1
  # PUT /bed_masters/1.xml
  def update
    @bed_master = BedMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@ward = WardMaster.find_by_name(params[:ward1])
	if(@ward)
		@bed_master.ward_master_id=@ward.id
		@room = RoomMaster.find_by_name_and_ward_master_id(params[:room1],@ward.id)
	@bed_master.room_master_id=@room.id
	end
    respond_to do |format|
      if @bed_master.update_attributes(params[:bed_master])
        format.html { redirect_to("/bed_masters/new", :notice => 'BedMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bed_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bed_masters/1
  # DELETE /bed_masters/1.xml
  def destroy
    @bed_master = BedMaster.find(params[:id])
    @bed_master.destroy

    respond_to do |format|
      format.html { redirect_to(bed_masters_url) }
      format.xml  { head :ok }
    end
  end
  
  def ajax_function
	
	if(params[:type]=="ward")
		@ward_master=WardMaster.find_by_name(params[:ward])
		@room_master=RoomMaster.find(:all, :conditions => " ward_master_id = '#{@ward_master.id}'")
		str=""
		for room in @room_master
			str<<room.name<<"<division>"
		end
	else
		@room_master=RoomMaster.find_by_code(params[:ward])
		@bed_master=BedMaster.find(:all, :conditions => " room_master_id = '#{@room_master.id}'")
		str=""
		for bed_master in @bed_master
			str<<bed_master.code<<"<division>"
		end
	end
	render :text => str
  end
	def search
	 @bed_masters = BedMaster.find(:all, :conditions => "name LIKE '#{params[:bed_name]}%'")
	render :partial => "bed_masters_record"
  end
end
