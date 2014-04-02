class TestmastersController < ApplicationController
  # GET /testmasters
  # GET /testmasters.xml
  def index
    @testmasters = Testmaster.all
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@testmasters = Testmaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @testmasters }
    end
  end

  # GET /testmasters/1
  # GET /testmasters/1.xml
  def show
    @testmaster = Testmaster.find(params[:id])
 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @testmaster }
    end
  end

  # GET /testmasters/new
  # GET /testmasters/new.xml
  def new
    @testmaster = Testmaster.new
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
    20.times{@testmaster.testmaster_child.build}	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @testmaster }
    end
  end

  # GET /testmasters/1/edit
  def edit
    @testmaster = Testmaster.find(params[:id])
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
	20.times{@testmaster.testmaster_child.build}	
  end

  # POST /testmasters
  # POST /testmasters.xml
  def create
    @testmaster = Testmaster.new(params[:testmaster])
 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @testmaster.save
        format.html { redirect_to("/testmasters/new", :notice => 'Testmaster was successfully created.') }
        format.xml  { render :xml => @testmaster, :status => :created, :location => @testmaster }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @testmaster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /testmasters/1
  # PUT /testmasters/1.xml
  def update
    @testmaster = Testmaster.find(params[:id])
 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @testmaster.update_attributes(params[:testmaster])
        format.html { redirect_to("/testmasters/new", :notice => 'Testmaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @testmaster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /testmasters/1
  # DELETE /testmasters/1.xml
  def destroy
    @testmaster = Testmaster.find(params[:id])
    @testmaster.destroy

    respond_to do |format|
      format.html { redirect_to(testmasters_url) }
      format.xml  { head :ok }
    end
  end
  def search
	 @testmasters = Testmaster.find(:all, :conditions => "test_name	 LIKE '#{params[:testname]}%'")
	render :partial => "testmasters_record"
  end
  
  def select_investiogation
  	@service_master=Servicemaster.find(:all,:conditions => "service_group_code='#{params[:investigation]}' and org_Code = '#{params[:org_code]}'")
  	str=""
  	for service_master in @service_master
  		str<<service_master.service_name+"<division>"
  	end
  	render :text => str
  end
end
