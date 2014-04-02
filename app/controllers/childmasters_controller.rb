class ChildmastersController < ApplicationController
  # GET /childmasters
  # GET /childmasters.xml
  def index
  @user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
	@childmasters = Childmaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@org.org_code}'"
	
    @childmasters = Childmaster.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @childmasters }
    end
  end

  # GET /childmasters/1
  # GET /childmasters/1.xml
  def show
    @childmaster = Childmaster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @childmaster }
    end
  end

  # GET /childmasters/new
  # GET /childmasters/new.xml
  def new
    @childmaster = Childmaster.new
     	
	#Get the org_code and org_location in people table based on user id.
	@people=Person.find_by_id(params[:user_id])
	if(@people.code_option==0)
		@org_code=@people.org_code
		@org_location=@people.org_location
	else
		transfer_data=TransferData.new
		@org_code=transfer_data.get_org_codes(@people.port_number)
	end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @childmaster }
    end
  end

  # GET /childmasters/1/edit
  def edit
    @childmaster = Childmaster.find(params[:id])
  end

  # POST /childmasters
  # POST /childmasters.xml
  def create
    @childmaster = Childmaster.new(params[:childmaster])

    respond_to do |format|
      if @childmaster.save
        format.html { redirect_to(@childmaster, :notice => 'Childmaster was successfully created.') }
        format.xml  { render :xml => @childmaster, :status => :created, :location => @childmaster }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @childmaster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /childmasters/1
  # PUT /childmasters/1.xml
  def update
    @childmaster = Childmaster.find(params[:id])

    respond_to do |format|
      if @childmaster.update_attributes(params[:childmaster])
        format.html { redirect_to(@childmaster, :notice => 'Childmaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @childmaster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /childmasters/1
  # DELETE /childmasters/1.xml
  def destroy
    @childmaster = Childmaster.find(params[:id])
    @childmaster.destroy

    respond_to do |format|
      format.html { redirect_to(childmasters_url) }
      format.xml  { head :ok }
    end
  end
end
