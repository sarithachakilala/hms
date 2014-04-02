class ItemmastersController < ApplicationController
  # GET /itemmasters
  # GET /itemmasters.xml
  def index
    @itemmasters = Itemmaster.all
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@itemmasters = Itemmaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @itemmasters }
    end
  end

  # GET /itemmasters/1
  # GET /itemmasters/1.xml
  def show
    @itemmaster = Itemmaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @itemmaster }
    end
  end

  # GET /itemmasters/new
  # GET /itemmasters/new.xml
  def new
    @itemmaster = Itemmaster.new
	  @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
	@manufacturers = Manufacturer.all
	@item_master=Itemmaster.find(:all, :select => "DISTINCT product_name")
	@item_batchno=Array.new
	@item_batchno=""
	if(params[:call_from])

		@call_from=params[:call_from]

	else
		@call_from="new"
	end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @itemmaster }
    end
  end

  # GET /itemmasters/1/edit
  def edit
    @itemmaster = Itemmaster.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
  end

  # POST /itemmasters
  # POST /itemmasters.xml
  def create
    @itemmaster = Itemmaster.new(params[:itemmaster])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
  @item_master=Itemmaster.find(:all, :select => "DISTINCT product_name")
  @item_batchno=Array.new
  @item_batchno=""
  @manufacturers = Manufacturer.all
  if(@itemmaster.product_name)
    @itemmaster.product_name=@itemmaster.product_name.upcase
  end
  respond_to do |format|
      if @itemmaster.save
		if(params[:call_from].to_s=="goods")
			format.html { redirect_to("/itemmasters/close_form/#{@itemmaster.id}", :notice => 'Itemmaster was successfully created.') }
		elsif(params[:call_from].to_s=="discharge")
			format.html { redirect_to("/itemmasters/close_discharge/#{@itemmaster.id}", :notice => 'Itemmaster was successfully created.') }
		else
			format.html { redirect_to("/itemmasters/new", :notice => 'Itemmaster was successfully created.') }
		end	
        format.xml  { render :xml => @itemmaster, :status => :created, :location => @itemmaster }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @itemmaster.errors, :status => :unprocessable_entity }
      end
    end
  end

  def close_form
	@itemmaster = Itemmaster.find(params[:id])
  end
  
  # PUT /itemmasters/1
  # PUT /itemmasters/1.xml
  def update
    @itemmaster = Itemmaster.find(params[:id])
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @itemmaster.update_attributes(params[:itemmaster])
        format.html { redirect_to("/itemmasters/new", :notice => 'Itemmaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @itemmaster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /itemmasters/1
  # DELETE /itemmasters/1.xml
  def destroy
    @itemmaster = Itemmaster.find(params[:id])
    @itemmaster.destroy

    respond_to do |format|
      format.html { redirect_to(itemmasters_url) }
      format.xml  { head :ok }
    end
  end
  def search
	@itemmasters = Itemmaster.find(:all, :conditions => "product_name LIKE '#{params[:product_name]}%'")
	render :partial => "item_masters_record"
  end
  
  def verify_name
	name=params[:name]
	units=params[:units]
	return_val="0"
		if(params[:type]=="item_names")
		@items=Itemmaster.find(:all, :conditions=>"product_name Like '#{name}%'")
		
		render :partial =>"all_items"
		else
				@item=Itemmaster.find_by_product_name_and_units(name,units)
				if(!@item)
					return_val=@item.product_name
				else 
					return_val="0"
				end
				
				render :text => return_val
		end
  end
  
end
