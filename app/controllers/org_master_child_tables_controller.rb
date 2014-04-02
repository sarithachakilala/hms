class OrgMasterChildTablesController < ApplicationController
  # GET /org_master_child_tables
  # GET /org_master_child_tables.xml
  def index
    @org_master_child_tables = OrgMasterChildTable.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @org_master_child_tables }
    end
  end

  # GET /org_master_child_tables/1
  # GET /org_master_child_tables/1.xml
  def show
    @org_master_child_table = OrgMasterChildTable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @org_master_child_table }
    end
  end

  # GET /org_master_child_tables/new
  # GET /org_master_child_tables/new.xml
  def new
    @org_master_child_table = OrgMasterChildTable.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @org_master_child_table }
    end
  end

  # GET /org_master_child_tables/1/edit
  def edit
    @org_master_child_table = OrgMasterChildTable.find(params[:id])
  end

  # POST /org_master_child_tables
  # POST /org_master_child_tables.xml
  def create
    @org_master_child_table = OrgMasterChildTable.new(params[:org_master_child_table])

    respond_to do |format|
      if @org_master_child_table.save
        format.html { redirect_to(@org_master_child_table, :notice => 'OrgMasterChildTable was successfully created.') }
        format.xml  { render :xml => @org_master_child_table, :status => :created, :location => @org_master_child_table }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @org_master_child_table.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /org_master_child_tables/1
  # PUT /org_master_child_tables/1.xml
  def update
    @org_master_child_table = OrgMasterChildTable.find(params[:id])

    respond_to do |format|
      if @org_master_child_table.update_attributes(params[:org_master_child_table])
        format.html { redirect_to(@org_master_child_table, :notice => 'OrgMasterChildTable was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @org_master_child_table.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /org_master_child_tables/1
  # DELETE /org_master_child_tables/1.xml
  def destroy
    @org_master_child_table = OrgMasterChildTable.find(params[:id])
    @org_master_child_table.destroy

    respond_to do |format|
      format.html { redirect_to(org_master_child_tables_url) }
      format.xml  { head :ok }
    end
  end
end
