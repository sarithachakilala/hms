class ModulesListsController < ApplicationController
  # GET /modules_lists
  # GET /modules_lists.xml
  def index
    @modules_lists = ModulesList.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @modules_lists }
    end
  end

  # GET /modules_lists/1
  # GET /modules_lists/1.xml
  def show
    @modules_list = ModulesList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @modules_list }
    end
  end

  # GET /modules_lists/new
  # GET /modules_lists/new.xml
  def new
    @modules_list = ModulesList.new
	10.times{ @modules_list.module_list_children.build }
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @modules_list }
    end
  end

  # GET /modules_lists/1/edit
  def edit
    @modules_list = ModulesList.find(params[:id])
	10.times{ @modules_list.module_list_children.build }
  end

  # POST /modules_lists
  # POST /modules_lists.xml
  def create
    @modules_list = ModulesList.new(params[:modules_list])

    respond_to do |format|
      if @modules_list.save
        format.html { redirect_to(@modules_list, :notice => 'ModulesList was successfully created.') }
        format.xml  { render :xml => @modules_list, :status => :created, :location => @modules_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @modules_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /modules_lists/1
  # PUT /modules_lists/1.xml
  def update
    @modules_list = ModulesList.find(params[:id])

    respond_to do |format|
      if @modules_list.update_attributes(params[:modules_list])
        format.html { redirect_to(@modules_list, :notice => 'ModulesList was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @modules_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /modules_lists/1
  # DELETE /modules_lists/1.xml
  def destroy
    @modules_list = ModulesList.find(params[:id])
    @modules_list.destroy

    respond_to do |format|
      format.html { redirect_to(modules_lists_url) }
      format.xml  { head :ok }
    end
  end
  
  
  def search
	@modules_lists = ModulesList.all(:conditions => "module_name LIKE '#{params[:module_name]}%'")
	render :partial => "search_module_records"
  end
end
