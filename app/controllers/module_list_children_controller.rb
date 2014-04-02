class ModuleListChildrenController < ApplicationController
  # GET /module_list_children
  # GET /module_list_children.xml
  def index
    @module_list_children = ModuleListChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @module_list_children }
    end
  end

  # GET /module_list_children/1
  # GET /module_list_children/1.xml
  def show
    @module_list_child = ModuleListChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @module_list_child }
    end
  end

  # GET /module_list_children/new
  # GET /module_list_children/new.xml
  def new
    @module_list_child = ModuleListChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @module_list_child }
    end
  end

  # GET /module_list_children/1/edit
  def edit
    @module_list_child = ModuleListChild.find(params[:id])
  end

  # POST /module_list_children
  # POST /module_list_children.xml
  def create
    @module_list_child = ModuleListChild.new(params[:module_list_child])

    respond_to do |format|
      if @module_list_child.save
        format.html { redirect_to(@module_list_child, :notice => 'ModuleListChild was successfully created.') }
        format.xml  { render :xml => @module_list_child, :status => :created, :location => @module_list_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @module_list_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /module_list_children/1
  # PUT /module_list_children/1.xml
  def update
    @module_list_child = ModuleListChild.find(params[:id])

    respond_to do |format|
      if @module_list_child.update_attributes(params[:module_list_child])
        format.html { redirect_to(@module_list_child, :notice => 'ModuleListChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @module_list_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /module_list_children/1
  # DELETE /module_list_children/1.xml
  def destroy
    @module_list_child = ModuleListChild.find(params[:id])
    @module_list_child.destroy

    respond_to do |format|
      format.html { redirect_to(module_list_children_url) }
      format.xml  { head :ok }
    end
  end
end
