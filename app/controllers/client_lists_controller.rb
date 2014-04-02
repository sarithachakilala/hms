class ClientListsController < ApplicationController
  # GET /client_lists
  # GET /client_lists.xml
  def index
    @client_lists = ClientList.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @client_lists }
    end
  end

  def manage_clients
	@client_lists = ClientList.find(:all)
  end
  # GET /client_lists/1
  # GET /client_lists/1.xml
  def show
    @client_list = ClientList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @client_list }
    end
  end

  # GET /client_lists/new
  # GET /client_lists/new.xml
  def new
    @client_list = ClientList.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @client_list }
    end
  end

  def display
    @client_lists = ClientList.find(:all, :conditions => "hospital_name = '#{params[:name]}'")
  end
  
  # GET /client_lists/1/edit
  def edit
    @client_list = ClientList.find(params[:id])
  end

  # POST /client_lists
  # POST /client_lists.xml
  def create
    @client_list = ClientList.new(params[:client_list])

    respond_to do |format|
      if @client_list.save
		format.html { redirect_to(@client_list, :notice => 'ClientList was successfully created.') }
        format.xml  { render :xml => @client_list, :status => :created, :location => @client_list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @client_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /client_lists/1
  # PUT /client_lists/1.xml
  def update
    @client_list = ClientList.find(params[:id])

    respond_to do |format|
      if @client_list.update_attributes(params[:client_list])
        format.html { redirect_to(@client_list, :notice => 'ClientList was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @client_list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /client_lists/1
  # DELETE /client_lists/1.xml
  def destroy
    @client_list = ClientList.find(params[:id])
    @client_list.destroy

    respond_to do |format|
      format.html { redirect_to(client_lists_url) }
      format.xml  { head :ok }
    end
  end
  
  def check_hospital
	if(params[:id1]=="hospital_name")
		org_master=OrgMaster.find_by_hospital_name(params[:hospital_name])
		str=""
		for org in org_master.org_master_child_tables
			str<<org.branch_code+","
		end
		str<<org_master.port_number.to_s
	else
		org_master_child=OrgMasterChildTable.find_by_branch_code(params[:hospital_name])
		str=org_master_child.branch_name
	end
	render :text => str
  end
end
