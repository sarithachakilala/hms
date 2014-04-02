class ChargeMasterChildrenController < ApplicationController
  # GET /charge_master_children
  # GET /charge_master_children.xml
  def index
    @charge_master_children = ChargeMasterChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @charge_master_children }
    end
  end

  # GET /charge_master_children/1
  # GET /charge_master_children/1.xml
  def show
    @charge_master_child = ChargeMasterChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @charge_master_child }
    end
  end

  # GET /charge_master_children/new
  # GET /charge_master_children/new.xml
  def new
    @charge_master_child = ChargeMasterChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @charge_master_child }
    end
  end

  # GET /charge_master_children/1/edit
  def edit
    @charge_master_child = ChargeMasterChild.find(params[:id])
  end

  # POST /charge_master_children
  # POST /charge_master_children.xml
  def create
    @charge_master_child = ChargeMasterChild.new(params[:charge_master_child])

    respond_to do |format|
      if @charge_master_child.save
        format.html { redirect_to(@charge_master_child, :notice => 'ChargeMasterChild was successfully created.') }
        format.xml  { render :xml => @charge_master_child, :status => :created, :location => @charge_master_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @charge_master_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /charge_master_children/1
  # PUT /charge_master_children/1.xml
  def update
    @charge_master_child = ChargeMasterChild.find(params[:id])

    respond_to do |format|
      if @charge_master_child.update_attributes(params[:charge_master_child])
        format.html { redirect_to(@charge_master_child, :notice => 'ChargeMasterChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @charge_master_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /charge_master_children/1
  # DELETE /charge_master_children/1.xml
  def destroy
    @charge_master_child = ChargeMasterChild.find(params[:id])
    @charge_master_child.destroy

    respond_to do |format|
      format.html { redirect_to(charge_master_children_url) }
      format.xml  { head :ok }
    end
  end
end
