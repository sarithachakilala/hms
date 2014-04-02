class ConsultantVisitsController < ApplicationController
  # GET /consultant_visits
  # GET /consultant_visits.xml
  def index
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @consultant_visits = ConsultantVisit.paginate:page => params[:page] || 1, :per_page => 5, :order =>"id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultant_visits }
    end
  end
  
    def search
	@consultant_visits = ConsultantVisit.find(:all,:conditions => "admn_no = '#{params[:t]}'")
	render :partial => "search_consultant_records"
  end

  
  # GET /consultant_visits/1
  # GET /consultant_visits/1.xml
  def show
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@consultant_visit = ConsultantVisit.find(params[:id])
	if @consultant_visit
		@adm=Admission.find_by_admn_no_and_org_code(@consultant_visit.admn_no,@consultant_visit.org_code)
		@reg=Registration.find_by_mr_no_and_org_code(@adm.mr_no,@consultant_visit.org_code)
	end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultant_visit }
    end
  
 end
  
   def print
	@consultant_visit = ConsultantVisit.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultant_visit }
    end
  end
  
  # GET /consultant_visits/new
  # GET /consultant_visits/new.xml
  def new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	@date=Date.today
	@consultant_visit = ConsultantVisit.new
	@ward=""
	@room=""
	@bed=""
	@floor=""
	if(params[:record_id])
		@record_id=1
		admission=Admission.find_by_id(params[:record_id])
		@ward=admission.ward
		@room=admission.room
		@bed=admission.bed
		@floor=admission.floor
		@consultant_visit1=ConsultantVisit.find_by_admn_no_and_org_code(admission.admn_no,admission.org_code)
		registration=Registration.last(:conditions => "mr_no = '#{admission.mr_no}' and org_code = '#{admission.org_code}'")
		if(@consultant_visit1)
			@consultant_visit=ConsultantVisit.find_by_admn_no_and_org_code(admission.admn_no,admission.org_code)
			@consultant_visit.patient_name=registration.title+"."+registration.patient_name
			@length=0
			@length=@length+@consultant_visit.consultant_visit_children.length
			15.times{ @consultant_visit.consultant_visit_children.build }
		else
			@length=0
			@consultant_visit.admn_no=admission.admn_no
			@consultant_visit.mr_no=admission.mr_no
			@consultant_visit.patient_name=registration.title+"."+admission.patient_name
			15.times{ @consultant_visit.consultant_visit_children.build }
			@admission=Admission.find(:all,:conditions =>"org_code ='#{admission.org_code}' and admn_status='Admitted'")
		end
	else
		15.times{ @consultant_visit.consultant_visit_children.build }
		@admission=Admission.find(:all,:conditions =>"org_code ='#{@org_code}' and admn_status='Admitted'")
		respond_to do |format|
			format.html # new.html.erb
			format.xml  { render :xml => @medicine_issue }
		end
	end
  end

  
  def new_visit
  
  end
  # GET /consultant_visits/1/edit
  def edit
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    	@consultant_visit = ConsultantVisit.find(params[:id])
	@registration=Registration.find_by_mr_no_and_org_code(@consultant_visit.mr_no,@consultant_visit.org_code)
    	@admission=Admission.find_by_admn_no_and_org_code(@consultant_visit.admn_no, @consultant_visit.org_code)
	
    	@consultant_visit.patient_name=@registration.title+"."+@registration.patient_name
	
    	@father_name=@registration.father_name
	 @floor=@admission.floor
	 @ward=@admission.ward
	 @room=@admission.room
	 @bed=@admission.bed
  end

  # POST /consultant_visits
  # POST /consultant_visits.xml
  def create
    @session_id=session[:id]
    @session = Session.find(session[:id])
    @person = Person.find(@session.person_id)
    @org_code=@person.org_code
    @org_location=@person.org_location
    @date=Date.today
    @consultant_visit = ConsultantVisit.new(params[:consultant_visit])

    @consultant_visit.patient_name=Number.new.change_patient_name(@consultant_visit.patient_name)
    respond_to do |format|
      if @consultant_visit.save
        format.html { redirect_to("/consultant_visits/new", :notice => 'ConsultantVisit was successfully created.') }
        format.xml  { render :xml => @consultant_visit, :status => :created, :location => @consultant_visit }
      else
		@con=Admission.find_by_mr_no(@consultant_visit.mr_no)
if(@con)
		@ward=@con.ward	
		@room=@con.room
		@bed=@con.bed
		@floor=@con.floor
end
		15.times{ @consultant_visit.consultant_visit_children.build }
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultant_visit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /consultant_visits/1
  # PUT /consultant_visits/1.xml
  def update
    @consultant_visit = ConsultantVisit.find(params[:id])
    
    respond_to do |format|
      if @consultant_visit.update_attributes(params[:consultant_visit])
        format.html { redirect_to("/consultant_visits/new", :notice => 'ConsultantVisit was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consultant_visit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /consultant_visits/1
  # DELETE /consultant_visits/1.xml
  def destroy
    @consultant_visit = ConsultantVisit.find(params[:id])
    @consultant_visit.destroy

    respond_to do |format|
      format.html { redirect_to(consultant_visits_url) }
      format.xml  { head :ok }
    end
  end
  def ajax_buildings
  	admno=params[:admn_no]
	orgcode=params[:org_code]
	@admission=Admission.find_by_id(admno)
	@doctor=ConsultantMaster.find_by_consultant_id_and_org_code(@admission.consultant_id,@admission.org_code)
	puts @admission.mr_no
	@reg=Registration.find_by_mr_no_and_org_code(@admission.mr_no,orgcode)
	render :json => "<script>#{@admission.admn_no}</script><script>#{@reg.mr_no}</script><script>#{@reg.patient_name}</script><script>#{@reg.father_name}</script><script>#{@reg.reg_no}</script><script>#{@admission.floor}</script><script>#{@admission.room}</script><script>#{@admission.ward}</script><script>#{@admission.bed}</script><script>#{@admission.consultant_name}</script>", :content_type => "text/html"
end

 def select_org_code
	transfer_data=TransferData.neconsultantw
	render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
  end

 # start of change by sateesh 2011-12-26  
 def appointment
	@date=params[:date]
	@admn_no=params[:admn_no]
	@org_code=params[:org_code]
	@doctor=EmployeeMaster.find(:all, :conditions =>" department ='#{params[:dapartment]}' and org_code='#{params[:org_code]}' OR visible=1  ")
	

 end
 
 def find_doctor_charge
	admission=Admission.find_by_admn_no_and_org_code(params[:admn_no],params[:org_code])
	consultant_master=ConsultantMaster.find_by_consultant_id_and_org_code(params[:consultant],params[:org_code])
	if(consultant_master.charge_type=="IP")
		ward_cost=WardCost.find_by_consultant_master_id_and_ward(consultant_master.id,admission.ward)
		render :text => ward_cost.gcost
	elsif(consultant_master.charge_type=="Both")

		if(consultant_master.charge=="Both Flat")
			render :text => consultant_master.general_charge.to_s
		else

			ward_cost=WardCost.find_by_consultant_master_id_and_ward(consultant_master.id,admission.ward)
			puts ward_cost.consultant_master_id
			puts ward_cost.ward
			render :text => ward_cost.gcost
		end
	end
 end
  def observe_field_ex
  	@consultant_visits = ConsultantVisit.find(:all,:conditions=>"admn_no LIKE '%#{params[:admn_search]}' AND mr_no LIKE '%#{params[:mr_no_search]}' AND patient_name LIKE '#{params[:name_search]}%'")
if (@consultant_visits[0])
   render:partial=>"search_consultant_records"
else
render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
end  
end
 
end
