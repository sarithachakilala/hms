class ManufacturersController < ApplicationController
  # GET /manufacturers
  # GET /manufacturers.xml
  def index
    @manufacturers = Manufacturer.all
	@manufacturers = Manufacturer.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @manufacturers }
    end
  end

  # GET /manufacturers/1
  # GET /manufacturers/1.xml
  def show
    @manufacturer = Manufacturer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @manufacturer }
    end
  end

  # GET /manufacturers/new
  # GET /manufacturers/new.xml
  def new
    @manufacturer = Manufacturer.new
    @session_id=session[:id]
  @session = Session.find(session[:id])
  @person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @manufacturer }
    end
  end

  # GET /manufacturers/1/edit
  def edit
        @session_id=session[:id]
    @session = Session.find(session[:id])
    @person = Person.find(@session.person_id)
    @manufacturer = Manufacturer.find(params[:id])
  end

  # POST /manufacturers
  # POST /manufacturers.xml
  def create
    @manufacturer = Manufacturer.new(params[:manufacturer])
    @session_id=session[:id]
    @session = Session.find(session[:id])
    @person = Person.find(@session.person_id)
    respond_to do |format|
      if @manufacturer.save
        format.html { redirect_to("/manufacturers/new", :notice => 'Manufacturer was successfully created.') }
        format.xml  { render :xml => @manufacturer, :status => :created, :location => @manufacturer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @manufacturer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /manufacturers/1
  # PUT /manufacturers/1.xml
  def update
    @manufacturer = Manufacturer.find(params[:id])

    respond_to do |format|
      if @manufacturer.update_attributes(params[:manufacturer])
        format.html { redirect_to(@manufacturer, :notice => 'Manufacturer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @manufacturer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /manufacturers/1
  # DELETE /manufacturers/1.xml
  def destroy
    @manufacturer = Manufacturer.find(params[:id])
    @manufacturer.destroy

    respond_to do |format|
      format.html { redirect_to(manufacturers_url) }
      format.xml  { head :ok }
    end
  end
  
  def search
	 @manufacturer = Manufacturer.find(:all, :conditions => "manufacturer_name LIKE '#{params[:manufacturer_name]}%'")
	 render :partial => "search_manufacturer"
  end
end
