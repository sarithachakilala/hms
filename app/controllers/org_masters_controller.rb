class OrgMastersController < ApplicationController
  # GET /org_masters
  # GET /org_masters.xml
  def index
    @org_masters = OrgMaster.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @org_masters }
    end
  end

  # GET /org_masters/1
  # GET /org_masters/1.xml
  def show
    @org_master = OrgMaster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @org_master }
    end
  end

  # GET /org_masters/new
  # GET /org_masters/new.xml
  def new
    @org_master = OrgMaster.new
	10.times{ @org_master.org_master_child_tables.build }
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @org_master }
    end
  end

  # GET /org_masters/1/edit
  def edit
    @org_master = OrgMaster.find(params[:id])
  end

  # POST /org_masters
  # POST /org_masters.xml
  def create
    @org_master = OrgMaster.new(params[:org_master])

    respond_to do |format|
      if @org_master.save
        format.html { redirect_to(@org_master, :notice => 'OrgMaster was successfully created.') }
        format.xml  { render :xml => @org_master, :status => :created, :location => @org_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @org_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /org_masters/1
  # PUT /org_masters/1.xml
  def update
    @org_master = OrgMaster.find(params[:id])

    respond_to do |format|
      if @org_master.update_attributes(params[:org_master])
        format.html { redirect_to(@org_master, :notice => 'OrgMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @org_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /org_masters/1
  # DELETE /org_masters/1.xml
  def destroy
    @org_master = OrgMaster.find(params[:id])
    @org_master.destroy

    respond_to do |format|
      format.html { redirect_to(org_masters_url) }
      format.xml  { head :ok }
    end
  end
  
  
end
