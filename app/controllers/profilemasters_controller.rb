class ProfilemastersController < ApplicationController
  # GET /profilemasters
  # GET /profilemasters.xml
  def index
  	@user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
	@profilemasters = Profilemaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC"
	@role=params[:role]
     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @profilemasters }
    end
  end

  # GET /profilemasters/1
  # GET /profilemasters/1.xml
  def show
    @profilemaster = Profilemaster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @profilemaster }
    end
  end

  # GET /profilemasters/new
  # GET /profilemasters/new.xml
  def new
    @profilemaster = Profilemaster.new
	@role=params[:role]
    @module_list_children = ModuleListChild.all
	@modules_lists = ModulesList.all(:order => "position ASC")
	j=0
	@forms_name=Array.new
	@field_type=Array.new
	for modules_lists in @modules_lists
		@forms_name[j]=modules_lists.module_name
		@field_type[j]="Main"
		j=j+1
		for module_child in modules_lists.module_list_children
			@forms_name[j]=module_child.form_name
			@field_type[j]=module_child.field_type
			j=j+1
		end
	end
	@i=0
	@forms_name.length.times { @profilemaster.childmaster.build   }
    		
	#Get the org_code and org_location in people table based on user id.
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @profilemaster }
    end
  end

  # GET /profilemasters/1/edit
  def edit
    @profilemaster = Profilemaster.find(params[:id])
	@module_list_children = ModuleListChild.all
	@modules_lists = ModulesList.all
	j=0
	@forms_name=Array.new
	@field_type=Array.new
	for modules_lists in @modules_lists
		@forms_name[j]=modules_lists.module_name
		@field_type[j]="Main"
		j=j+1
		for module_child in modules_lists.module_list_children
			@forms_name[j]=module_child.form_name
			@field_type[j]=module_child.field_type
			j=j+1
		end
	end
	@i=0
	
	(@forms_name.length-@profilemaster.childmaster.length).times { @profilemaster.childmaster.build   }
  end

  # POST /profilemasters
  # POST /profilemasters.xml
  def create
    @profilemaster = Profilemaster.new(params[:profilemaster])
 	@module_list_children = ModuleListChild.all
	@modules_lists = ModulesList.all(:order => "position ASC")
	j=0
	@forms_name=Array.new
	@field_type=Array.new
	for modules_lists in @modules_lists
		@forms_name[j]=modules_lists.module_name
		@field_type[j]="Main"
		j=j+1
		for module_child in modules_lists.module_list_children
			@forms_name[j]=module_child.form_name
			@field_type[j]=module_child.field_type
			j=j+1
		end
	end
	@i=0

    respond_to do |format|
      if @profilemaster.save
        format.html { redirect_to("/profilemasters?role=#{params[:role]}", :notice => 'Profilemaster was successfully created.') }
        format.xml  { render :xml => @profilemaster, :status => :created, :location => @profilemaster }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profilemaster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /profilemasters/1
  # PUT /profilemasters/1.xml
  def update
    @profilemaster = Profilemaster.find(params[:id])

    respond_to do |format|
      if @profilemaster.update_attributes(params[:profilemaster])
        format.html { redirect_to(@profilemaster, :notice => 'Profilemaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profilemaster.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /profilemasters/1
  # DELETE /profilemasters/1.xml
  def destroy
    @profilemaster = Profilemaster.find(params[:id])
    @profilemaster.destroy

    respond_to do |format|
      format.html { redirect_to(profilemasters_url) }
      format.xml  { head :ok }
    end
  end
end
