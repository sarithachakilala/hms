class DischargeSummariesController < ApplicationController
  # GET /discharge_summaries
  # GET /discharge_summaries.xml
  def index
  
 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@discharge_summary = DischargeSummary.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@person.org_code}'"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @discharge_summary }
    end
  end
  
    def observe_field_ex
   	@discharge_summary = DischargeSummary.find(:all,:conditions=>"admn_no LIKE '%#{params[:admn_search]}' AND mr_no LIKE '%#{params[:mr_no_search]}' AND discharge_date LIKE '#{params[:discharge_date_search]}%'")
		if( @discharge_summary[0])
		   render:partial=>"search_admission_records"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  
		
  end 
   
  # GET /discharge_summaries/1
  # GET /discharge_summaries/1.xml
  def show
   @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@discharge_summary = DischargeSummary.find(params[:id])
	respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @discharge_summary }
    end
  end

  # GET /discharge_summaries/new
  # GET /discharge_summaries/new.xml
  def new
  @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
    @discharge_summary = DischargeSummary.new
	20.times{ @discharge_summary.medicine_list.build }
	#Get the org_code and org_location in people table based on user id.
	@admission=Admission.find(:all,:conditions => "org_code='#{@person.org_code}' and admn_status='Admitted'")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @discharge_summary }
    end
  end

  # GET /discharge_summaries/1/edit
  def edit
  @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @discharge_summary = DischargeSummary.find(params[:id])
	20.times{ @discharge_summary.medicine_list.build }
	@admission=Admission.find_by_admn_no_and_org_code(@discharge_summary.admn_no, @discharge_summary.org_code)
	@registration=Registration.find_by_mr_no_and_org_code(@discharge_summary.mr_no,@discharge_summary.org_code)
	@floor=@admission.floor
	@ward=@admission.ward
	@room=@admission.room
	@bed=@admission.bed
	@first_name=@registration.patient_name
	@father_name=@registration.father_name
	@reg_no=@registration.reg_no
	
  end

  # POST /discharge_summaries
  # POST /discharge_summaries.xml
  
  
   def report
	@discharge_summary = DischargeSummary.find(params[:id])
	@people=Person.find_by_id(params[:user_id])
	@admission = Admission.find_by_admn_no_and_org_code(@discharge_summary.admn_no,@discharge_summary.org_code)
	@discharge=DischargeSummary.find_by_admn_no_and_org_code(params[:admn_no],params[:org_code])
	@consultant_visits=ConsultantVisit.find(:all,:conditions => "org_code = '#{@admission.org_code}' and admn_no = '#{@admission.admn_no}'")
	@registration = Registration.find_by_mr_no(@admission.mr_no)
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 10,
      :right_margin => 10,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "#{@discharge_summary.discharge_date.strftime("%d-%m-%y")}.pdf"
    render :layout => false
	
  end
  def create
  
    @session_id=session[:id]
	  @session = Session.find(session[:id])
	  @person = Person.find(@session.person_id)
    @discharge_summary = DischargeSummary.new(params[:discharge_summary])
   
	  @admission=Admission.find_by_admn_no_and_org_code_and_admn_status(@discharge_summary.admn_no, @discharge_summary.org_code,'Admitted') 
	  if(@admission)
	   @ward=WardMaster.find_by_name_and_org_code(@admission.ward,@admission.org_code)
	   @room=RoomMaster.find_by_ward_master_id_and_name_and_org_code(@ward.id,@admission.room, @admission.org_code) 
	   @bed=BedMaster.find_by_room_master_id_and_name_and_org_code(@room.id,@admission.bed,@admission.org_code)
    	 @bed.status="Available"
	   @beds=@room.no_of_beds
	   @room.no_of_beds=@beds.to_i+1
	   @admission.admn_status="Discharged"
		@admission.update_attributes(params[:admission])
	    @bed.update_attributes(params[:bed_master])
		@room.update_attributes(params[:room_master])
    end

	respond_to do |format|
      if @discharge_summary.save
		#format.html { redirect_to(@discharge_summary, :notice => 'Discharge Sumamry was successfully created.') }
		   format.html { redirect_to("/discharge_summaries/report/#{@discharge_summary.id}?format=pdf")}
       	#format.html { redirect_to("/discharge_summaries/new?user_id=#{user_id}", :notice => 'discharge_summary was successfully created.') }
	     format.xml  { render :xml => @discharge_summary, :status => :created, :location => @discharge_summary }
      else


	@admission=Admission.find_by_admn_no(@discharge_summary.admn_no)
if(@admission)
	@doctor=EmployeeMaster.find_by_empid_and_org_code(@admission.consultant_id,@admission.org_code)
	@reg=Registration.find_by_mr_no(@admission.mr_no)

@patient_name=@reg.patient_name
@fname=@reg.father_name
@room=@admission.room
@bed=@admission.bed
@flr=@admission.floor
@ward=@admission.ward
@reg_no=@reg.reg_no
end
	20.times{ @discharge_summary.medicine_list.build } 
        format.html { render :action => "new" }
        format.xml  { render :xml => @discharge_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /discharge_summaries/1
  # PUT /discharge_summaries/1.xml
  def update
    @discharge_summary = DischargeSummary.find(params[:id])

    respond_to do |format|
      if @discharge_summary.update_attributes(params[:discharge_summary])
        format.html { redirect_to("/discharge_summaries/report/#{@discharge_summary.id}?&format=pdf")}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @discharge_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /discharge_summaries/1
  # DELETE /discharge_summaries/1.xml
  def destroy
    @discharge_summary = DischargeSummary.find(params[:id])
    @discharge_summary.destroy

    respond_to do |format|
      format.html { redirect_to(discharge_summaries_url) }
      format.xml  { head :ok }
    end
  end
   def select_org_code
	transfer_data=TransferData.new
	render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
  end
 def ajax_function

	medicine = Itemmaster.find_by_product_name(params[:medicine_name])

	render :text => medicine.product_code
 end
 
 def admn_no_search
 @org_code=params[:org_code]
 end
 
 def mrno_search
   	@patientregistration = Registration.find(:all, :conditions => "
        patient_name LIKE '#{params[:patient_name]}%' AND
		father_name LIKE '#{params[:father_name]}%' AND
		city  LIKE '#{params[:city_name]}%' AND
		org_code LIKE '#{params[:org_code]}'")   
		if @patientregistration	
			render :partial => "admission_search"
		end
	
  end
def ajax_buildings
  	admno=params[:admn_no]
	orgcode=params[:org_code]
	@admission=Admission.find_by_id(admno)
	@doctor=EmployeeMaster.find_by_empid_and_org_code(@admission.consultant_id,@admission.org_code)
	@reg=Registration.find_by_mr_no_and_org_code(@admission.mr_no,orgcode)
	render :json => "<script>#{@admission.admn_no}</script><script>#{@reg.mr_no}</script><script>#{@reg.patient_name}</script><script>#{@reg.father_name}</script><script>#{@reg.reg_no}</script><script>#{@admission.floor}</script><script>#{@admission.ward}</script><script>#{@admission.room}</script><script>#{@admission.bed}</script><script>#{@doctor.name}</script>", :content_type => "text/html"
end
  
end
