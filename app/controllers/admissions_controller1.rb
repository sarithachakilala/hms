class AdmissionsController < ApplicationController
  # GET /admissions
  # GET /admissions.xml
  def index

    @admissions = Admission.paginate:page => params[:page] || 1, :per_page => 5, :order =>"id DESC"
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admissions }
    end
  end
    def observe_field_ex
  	@admissions = Admission.find(:all,:conditions=>"admn_no LIKE '%#{params[:admn_search]}' AND mr_no LIKE '%#{params[:mr_no_search]}' AND patient_name LIKE '#{params[:name_search]}%' AND admn_date LIKE '#{params[:admn_date_search]}%' AND bed LIKE '#{params[:bed_search]}%' AND room LIKE '#{params[:room_search]}%' AND ward LIKE '#{params[:ward_search]}%'")
		if( @admissions[0])
		   render:partial=>"field_searching"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end 
end		
	def report1
        @admission = Admission.find(params[:id])
	con_id=@admission.consultant_id.split(" --> ")
	@admission.consultant_id=con_id[0]
		@registration = Registration.find_by_mr_no(@admission.mr_no)
		@people=Person.find_by_id(params[:user_id])
		@print_type=params[:print_type]
		@registration=Registration.find_by_mr_no_and_org_code(@admission.mr_no,@admission.org_code)
		number=Number.new
	   	prawnto :prawn => {
		  
		  :page_size => 'A4',
		  :left_margin => 10,
		  :right_margin => 10,
		  :top_margin => -15 ,
		  :bottom_margin => 30},
		  :filename => "report1.pdf"

		render :layout => false
	
	 end	 



  # GET /admissions/1
  # GET /admissions/1.xml
  def show
    @admission = Admission.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admission }
    end
  end

  # GET /admissions/new
  # GET /admissions/new.xml
  def new
    @admission = Admission.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	@registration=Registration.all
	@admission.admn_no=@admission.find_admn_no()
	@n=Number.find_by_name_and_org_code("receipt",@org_code)
	@admission.bill_no1= @n.value+1

    if(params[:mr_no])
	@registrations = Registration.find_by_mr_no_and_org_code(params[:mr_no],@org_code)
	@admission.mr_no=@registrations.mr_no
	@admission.patient_name=@registrations.title+"."+@registrations.patient_name
	@admission.age=@registrations.age
	@admission.gender=@registrations.gender
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admission }
    end
  end

  # GET /admissions/1/edit
  def edit
  	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @admission = Admission.find(params[:id])
  end

  # POST /admissions
  # POST /admissions.xml
  def create
    	@admission = Admission.new(params[:admission])
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    	con_id=@admission.consultant_id.split(" --> ")
	@admission.consultant_id=con_id[0]
	@admission.patient_name=Number.new.change_patient_name(@admission.patient_name)
    respond_to do |format|
      if @admission.save
		if(@admission.advance.to_i>0)
	  	  
			@advance_payment = AdvancePayment.new
			@advance_payment.org_code=@admission.org_code
			@advance_payment.org_location=@admission.org_location
			@advance_payment.admn_no=@admission.admn_no
			@advance_payment.mr_no=@admission.mr_no
			@advance_payment.total_amount=@admission.amount
			@advance_payment.already_paid_amount=@admission.advance
			@advance_payment.advance_date=@admission.admn_date
			@advance_payment.receipt_no=@admission.bill_no1
			@advance_payment.gross_amount=@admission.advance
			@advance_payment.admn_category="General"
			@advance_payment.save
		end
		@n=Number.new
		update_reciept_value=@n.retrive_value("receipt",@admission.org_code)
		@admission.bill_no1=update_reciept_value
		@ward=WardMaster.find_by_name_and_org_code(@admission.ward,@admission.org_code)
		if(@ward)
			@roommaster=RoomMaster.find_by_name_and_org_code_and_ward_master_id(@admission.room,@admission.org_code,@ward.id)
			@bedmaster=BedMaster.find_by_name_and_room_master_id(@admission.bed,@roommaster.id)
			@bedmaster.status="Un-Available"
			beds=@roommaster.no_of_beds
			@roommaster.no_of_beds=beds.to_i-1
		end
		@bedmaster.update_attributes(params[:bedmaster])
		@roommaster.update_attributes(params[:roommaster])
		@n=Number.find_by_name_and_org_code("receipt",@admission.org_code)
		@n.value=@admission.bill_no1
		@n.update_attributes(params[:n])

        format.html { redirect_to("/admissions/report1/#{@admission.id}?print_type=original&format=pdf") }
        format.xml  { render :xml => @admission, :status => :created, :location => @admission }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admissions/1
  # PUT /admissions/1.xml
  def update
    @admission = Admission.find(params[:id])

    respond_to do |format|
      if @admission.update_attributes(params[:admission])
        format.html { redirect_to("/admissions/report1/#{@admission.id}?print_type=original&format=pdf") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admission.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admissions/1
  # DELETE /admissions/1.xml
  def destroy
    @admission = Admission.find(params[:id])
    @admission.destroy

    respond_to do |format|
      format.html { redirect_to(admissions_url) }
      format.xml  { head :ok }
    end
  end
  
   
def select_consultant
	@consultant = EmployeeMaster.find_by_empid(params[:consultant_id])
	render :js =>"document.getElementById('consultant').value='#{@consultant.name}'"
end
	
def bed_select
	@wards=params[:q]
	@org_code=params[:org_code]
	@bed_names=Array.new
	@room_names=Array.new
	@floor_name=Array.new
	@floor=Array.new
	@cost=Array.new
	@admn_no=Array.new
	@mr_no=Array.new
	@patient_name=Array.new
	if(@wards!="")
			@ward=WardMaster.find_by_name_and_org_code(@wards,@org_code)
			@room=RoomMaster.find(:all, :conditions => "ward_master_id = '#{@ward.id}'") 
			@room1=RoomMaster.find(:all, :conditions => "ward_master_id = '#{@ward.id}'")
			i=0
			for room in @room
			@bedmasters=BedMaster.find(:all, :conditions => "room_master_id = '#{room.id}' and status != 'Un-Available'")
			
				@floor_name[i]=room.floor
				for bed in @bedmasters

					@bed_names[i]=bed.name
					@room_names[i]=room.name
					@floor[i]=room.floor

					@admn_details=Admission.find_by_ward_and_org_code_and_floor_and_room_and_bed(@wards,@org_code,room.floor,room.name,bed.name)
					if(@admn_details)
						@admn_no[i]=@admn_details.admn_no
						reg=Registration.find_by_mr_no_and_org_code(@admn_details.mr_no,@admn_details.org_code) 
						@mr_no[i]=reg.mr_no
						@patient_name[i]=reg.patient_name
					end
					i+=1
				end
				
			end
		else
			i=0
			@bedmasters=BedMaster.find(:all, :conditions => "status = 'Un-Available' and org_code = '#{@org_code}'")
			for bed in @bedmasters
				room=RoomMaster.find_by_id(bed.room_master_id)
				ward=WardMaster.find_by_id(room.ward_master_id) 
				@bed_names[i]=bed.name
				@room_names[i]=room.name
				@floor[i]=room.floor
				@cost[i]=ward.cost
				@admn_details=Admission.find_by_ward_and_org_code_and_floor_and_room_and_bed(@mr,@org_code,room.floor,room.name,bed.name)
					@admn_no[i]=@admn_details.admn_no
					reg=Registration.find_by_mr_no_and_org_code(@admn_details.mr_no,@admn_details.org_code) 
					@mr_no[i]=reg.mr_no
					@patient_name[i]=reg.patient_name
				i+=1
			end
		end
end
 def ajax_buildings
	org_code=params[:org_code]
	mr=params[:q]
	mr1=params[:q1]
	type=params[:type]
	if(type=="package_category")
		@pm=PackageMasterMajestic.find(:all,:conditions => "org_code = '#{org_code}' and category='#{mr1}'")	
		puts @pm[0].sub_category
		str=""
		for pm in @pm
			str<<pm.sub_category+"<division>"
		end
		render :text=>str	
	elsif(type=="mr_no")
		@pa=Registration.find_by_id(params[:q])
		@ip=Admission.last(:conditions =>"mr_no='#{@pa.mr_no}' and org_code='#{org_code}'")
	   	if(@ip)
			if(@ip.admn_status=="Discharged" )
				render :text =>@pa.reg_no+","+@pa.mr_no+","+@pa.title+"."+@pa.patient_name+","+@pa.age.to_s+","+@pa.gender  
			else
				render :text =>"Already Admitted"
			end		
		else
			if(@pa)
               	render :text =>@pa.reg_no+","+@pa.mr_no+","+@pa.title+"."+@pa.patient_name+","+@pa.age.to_s+","+@pa.gender  
			else
				render :text =>"Invalid MR_NUMBER"
			end
		end
	elsif(type=="dept")
		str=""
		@employee=EmployeeMaster.find(:all, :conditions => "department = '#{mr1}' and org_code = '#{org_code}'")
		for i in 0...@employee.length
			str<<@employee[i].empid+" --> "+@employee[i].name+","
		end
		render :text =>str
	end
	
end	
def search
	
	@admissions = Admission.find(:all,:conditions => "mr_no = '#{params[:t]}'")
	render :partial => "search_medical_records"
 end
  
   
  def field_search
	@form_name=params[:form_name]
	
	if(params[:no_type]=="mr_no")
		@registration=Registration.find(:all, :conditions =>"
			patient_name LIKE '#{params[:name]}%' AND
			mr_no  LIKE '#{params[:number]}%' AND
			org_code LIKE '#{params[:org_code]}%'", :order =>"id DESC")
	elsif(params[:no_type]=="admn_no")
		
			@admission=Admission.last(:conditions => "admn_no = '#{params[:number]}' and org_code = '#{params[:org_code]}'")
			if(@admission)
			@registration=Registration.find(:all, :conditions =>"
				mr_no LIKE '#{@admission.mr_no}%' AND
				org_code LIKE '#{params[:org_code]}%'")
			else
				@registration=""
			end
		
	end
	render :partial => "field_search"
  end
   def casesheet
  	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	
  end
  
 def print_case_sheets
	mr=params[:q]
	org_code=params[:org_code]
	@admission=Admission.find_by_admn_no_and_org_code(mr,org_code)
	if(@admission)
		render :text =>"Exist"
	else
		render :text =>"Invalid AD_NUMBER"
	end		
 end	
 
 
  def daily_status
 
 	@admission=Admission.find_by_admn_no_and_org_code(params[:admn_no],params[:org_code])
 	if(@admission)
  		render :partial => "daily_info"
 	else
  		render :text => "No record found"
 	end
  end
	def report

	@admission = Admission.find_by_admn_no_and_org_code(params[:admn_no],params[:org_code])
	@discharge=DischargeSummary.find_by_admn_no_and_org_code(params[:admn_no],params[:org_code])
	#@patient_allergies=PatientAllergy.find(:all,:conditions =>"admn_no='#{@admission.admn_no}' and org_code = '#{@admission.org_code}'")
	#@history=History.find_by_admn_no_and_org_code(@admission.admn_no,@admission.org_code)
	#@investigation=Investigation.find(:all,:conditions =>"admn_no='#{@admission.admn_no}' and org_code = '#{@admission.org_code}'")
	#@vital_observation=VitalObservation.find(:all,:conditions => "org_code = '#{@admission.org_code}' and admn_no = '#{@admission.admn_no}'")
	@consultant_visits=ConsultantVisit.find(:all,:conditions => "org_code = '#{@admission.org_code}' and admn_no = '#{@admission.admn_no}'")
	#@medicine_issues=MedicineIssue.find(:all,:conditions => "org_code = '#{@admission.org_code}' and admn_no = '#{@admission.admn_no}'")
	@registration = Registration.find_by_mr_no(@admission.mr_no)
	@bedtransfer = BedTransfer.find(:all,:conditions => "admn_no = '#{@admission.admn_no}' and org_code = '#{@admission.org_code}'")
	
   prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 20,
      :right_margin => 20,
      :top_margin => 30,
      :bottom_margin => 30},
      :filename => "#{@admission.admn_date.strftime("%d-%m-%y")}.pdf"

    render :layout => false
	
  end
  
  def admn_no
   	@patientregistration = Admission.find(:all, :conditions => "
        	patient_name LIKE '#{params[:patient_name]}%'")                  
	if 	@patientregistration
		render :partial => "admission_search"
	else 
		render :text=> "NO RECORDS"
	end
  end
  def select_amount_on_package
	package_master=PackageMasterMajestic.find_by_org_code_and_category_and_sub_category(params[:org_code],params[:package],params[:sub_package])
	package_child=PackageMasterMajesticChild.find_by_package_master_majestic_id_and_ward_name(package_master.id,params[:ward])
	render :text =>package_child.charge.to_s+"<division>"+package_master.days.to_s
   end
   
    def ip_details_search
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
  end
 def ip_details_search1
	@admission = Admission.find(:all, :conditions => "
						(admn_date  BETWEEN '#{params[:admission_date_from]}%' AND
						'#{params[:admission_date_to]}%' AND org_code = '#{params[:org_code]}' AND admn_no LIKE '#{params[:admn_no]}%' AND patient_name LIKE '#{params[:patient_name]}%' AND admn_status LIKE '#{params[:status]}%')")
		render :partial => "ip_details_search"

  end
  
   def display
	@admission = Admission.find(params[:id1])
	@registration=Registration.find_by_org_code_and_mr_no(@admission.org_code,@admission.mr_no)
   end
 
   def ip_details
	@admission = Admission.find(:all, :conditions => "
						(admn_date  BETWEEN '#{params[:admission_date_from]}%' AND
						'#{params[:admission_date_to]}%' AND org_code = '#{params[:org_code]}' AND admn_no LIKE '#{params[:admn_no]}%' AND patient_name LIKE '#{params[:patient_name]}%' AND admn_status LIKE '#{params[:status]}%')")
   prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 20,
      :right_margin => 20,
      :top_margin => 30,
      :bottom_margin => 30},
      :filename => "ip.pdf"

    render :layout => false
	
   end

end
