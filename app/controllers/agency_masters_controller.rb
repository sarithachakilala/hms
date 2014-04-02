class AgencyMastersController < ApplicationController
  # GET /agency_masters
  # GET /agency_masters.xml
  def index
    @agency_masters = AgencyMaster.all
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@agency_masters = AgencyMaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @agency_masters }
    end
  end

  # GET /agency_masters/1
  # GET /agency_masters/1.xml
  def show
    @agency_master = AgencyMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @agency_master }
    end
  end

  # GET /agency_masters/new
  # GET /agency_masters/new.xml
  def new
    @agency_master = AgencyMaster.new
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @agency_master }
    end
  end

  # GET /agency_masters/1/edit
  def edit
    @agency_master = AgencyMaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /agency_masters
  # POST /agency_masters.xml
  def create
    @agency_master = AgencyMaster.new(params[:agency_master])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @agency_master.save
        format.html { redirect_to("/agency_masters/new", :notice => 'AgencyMaster was successfully created.') }
        format.xml  { render :xml => @agency_master, :status => :created, :location => @agency_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @agency_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /agency_masters/1
  # PUT /agency_masters/1.xml
  def update
    @agency_master = AgencyMaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @agency_master.update_attributes(params[:agency_master])
        format.html { redirect_to("/agency_masters/new", :notice => 'AgencyMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @agency_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /agency_masters/1
  # DELETE /agency_masters/1.xml
  def destroy
    @agency_master = AgencyMaster.find(params[:id])
    @agency_master.destroy

    respond_to do |format|
      format.html { redirect_to(agency_masters_url) }
      format.xml  { head :ok }
    end
  end
  def select_city
	@city=CityMaster.find_by_name(params[:city_name])
	@state=StateMaster.find_by_id(@city.state_master_id)
	@country=CountryMaster.find_by_id(@state.country_master_id)
	render :js =>"
		document.getElementById('state').style.background='#FEF5CA';
		document.getElementById('state').readOnly=true;
		document.getElementById('country').style.background='#FEF5CA';
		document.getElementById('country').readOnly=true;
		document.getElementById('state').value='#{@state.name}';
   		document.getElementById('country').value='#{@country.name}';
	"
  end
  def search
	 @agency_masters = AgencyMaster.find(:all, :conditions => "agency_name LIKE '#{params[:agency_name]}%'")
	render :partial => "agency_master_record"
  end
  
end
