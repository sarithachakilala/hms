class PackageMasterMajesticChildrenController < ApplicationController
  # GET /package_master_majestic_children
  # GET /package_master_majestic_children.xml
  def index
    @package_master_majestic_children = PackageMasterMajesticChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @package_master_majestic_children }
    end
  end

  # GET /package_master_majestic_children/1
  # GET /package_master_majestic_children/1.xml
  def show
    @package_master_majestic_child = PackageMasterMajesticChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package_master_majestic_child }
    end
  end

  # GET /package_master_majestic_children/new
  # GET /package_master_majestic_children/new.xml
  def new
    @package_master_majestic_child = PackageMasterMajesticChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @package_master_majestic_child }
    end
  end

  # GET /package_master_majestic_children/1/edit
  def edit
    @package_master_majestic_child = PackageMasterMajesticChild.find(params[:id])
  end

  # POST /package_master_majestic_children
  # POST /package_master_majestic_children.xml
  def create
    @package_master_majestic_child = PackageMasterMajesticChild.new(params[:package_master_majestic_child])

    respond_to do |format|
      if @package_master_majestic_child.save
        format.html { redirect_to(@package_master_majestic_child, :notice => 'PackageMasterMajesticChild was successfully created.') }
        format.xml  { render :xml => @package_master_majestic_child, :status => :created, :location => @package_master_majestic_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @package_master_majestic_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /package_master_majestic_children/1
  # PUT /package_master_majestic_children/1.xml
  def update
    @package_master_majestic_child = PackageMasterMajesticChild.find(params[:id])

    respond_to do |format|
      if @package_master_majestic_child.update_attributes(params[:package_master_majestic_child])
        format.html { redirect_to(@package_master_majestic_child, :notice => 'PackageMasterMajesticChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @package_master_majestic_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /package_master_majestic_children/1
  # DELETE /package_master_majestic_children/1.xml
  def destroy
    @package_master_majestic_child = PackageMasterMajesticChild.find(params[:id])
    @package_master_majestic_child.destroy

    respond_to do |format|
      format.html { redirect_to(package_master_majestic_children_url) }
      format.xml  { head :ok }
    end
  end
end
