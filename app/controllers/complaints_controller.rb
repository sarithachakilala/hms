class ComplaintsController < ApplicationController
  # GET /complaints
  # GET /complaints.xml
  def index
    @complaints = Complaint.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @complaints }
    end
  end

  # GET /complaints/1
  # GET /complaints/1.xml
  def show
    #@complaint = Complaint.find(:all,:conditions=>params[:id])
	 @complaint = Complaint.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @complaint }
    end
  end

  # GET /complaints/new
  # GET /complaints/new.xml
  def new
    @complaint = Complaint.new
	@complaints = Complaint.find(:all,:order=>"created_at desc" ,:conditions => "status='NOT COMPLEATED'")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @complaint }
    end
	
	dt=DateTime.now
	dateandtime=(dt.to_s).split('T')
	@date=dateandtime[0].to_s
	@time=(dateandtime[1].to_s).split('T')
	
  end

  # GET /complaints/1/edit
  def edit
    @complaint = Complaint.find(params[:id])
  end

  # POST /complaints
  # POST /complaints.xml
  def create
    @complaint = Complaint.new(params[:complaint])
    respond_to do |format|
      if @complaint.save
        format.html { redirect_to("/complaints/new/1", :notice => 'Complaint was successfully created.') }
        format.xml  { render :xml => @complaint, :status => :created, :location => @complaint }
	   #render :partial=>"pname",:object=>@complaint
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @complaint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /complaints/1
  # PUT /complaints/1.xml
  def update
    @complaint = Complaint.find(params[:id])
    respond_to do |format|
      if @complaint.update_attributes(params[:complaint])
        format.html { redirect_to("/complaints/new/1", :notice => 'Complaint was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @complaint.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /complaints/1
  # DELETE /complaints/1.xml
  def destroy
    @complaint = Complaint.find(params[:id])
    @complaint.destroy
    respond_to do |format|
      format.html { redirect_to(complaints_url) }
      format.xml  { head :ok }
    end
  end
  
  def select_department
		@department1 = EmployeeMaster.find(:all, :conditions=>"category = '#{params[:query]}' ")
		str=""
		for department in @department1
			str<<department.empid+" - "+department.name+"<division>"
		end
		render :text => str
  end
end
