class TreatmentPlansController < ApplicationController
  # GET /treatment_plans
  # GET /treatment_plans.xml
  def index
  	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
    @treatment_plans = TreatmentPlan.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@org.org_code}'"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @treatment_plans }
    end
  end

    def observe_field_ex
  	@treatment_plans = TreatmentPlan.find(:all,:conditions=>"admn_no LIKE '%#{params[:admn_search]}' AND mr_no LIKE '%#{params[:mr_no_search]}' AND patient_type LIKE '#{params[:type_search]}%' AND treatment_date	 LIKE '#{params[:treatment_date_search]}%' AND consultant_id LIKE '#{params[:consultant_search]}%'")
		if( @treatment_plans[0])
		   render:partial=>"field_searching"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  	
  end 
  
  # GET /treatment_plans/1
  # GET /treatment_plans/1.xml
  def show
    @treatment_plan = TreatmentPlan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @treatment_plan }
    end
  end

  # GET /treatment_plans/new
  # GET /treatment_plans/new.xml
  def new
    @treatment_plan = TreatmentPlan.new
	@registration = Registration.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@people = Person.find(@session.person_id)
	@org_code=@people.org_code
	@org_location=@people.org_location
	20.times{ @treatment_plan.medicine_list.build }
	@appt_payment = AppointmentPayment.all(:conditions => "book_date = '#{Date.today}'", :order =>"id DESC")

	@admissions = Admission.all(:conditions => "admn_status = 'Admitted'", :order =>"id DESC")
	
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @treatment_plan }
    end
  end

  # GET /treatment_plans/1/edit
  def edit
    @treatment_plan = TreatmentPlan.find(params[:id])
    20.times{ @treatment_plan.medicine_list.build }
    registration=Registration.last(:conditions => "mr_no = '#{@treatment_plan.mr_no}' and org_code = '#{@treatment_plan.org_code}'")
    @age=registration.age
    @patient_name=registration.patient_name
  end

  # POST /treatment_plans
  # POST /treatment_plans.xml
  def create
    @treatment_plan = TreatmentPlan.new(params[:treatment_plan])

    respond_to do |format|
      if @treatment_plan.save
        format.html { redirect_to("/treatment_plans/report/#{@treatment_plan.id}?format=pdf") }
        format.xml  { render :xml => @treatment_plan, :status => :created, :location => @treatment_plan }
      else
		20.times{ @treatment_plan.medicine_list.build }
        format.html { render :action => "new" }
        format.xml  { render :xml => @treatment_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /treatment_plans/1
  # PUT /treatment_plans/1.xml
  def update
    @treatment_plan = TreatmentPlan.find(params[:id])

    respond_to do |format|
      if @treatment_plan.update_attributes(params[:treatment_plan])
        format.html { redirect_to("/treatment_plans/report/#{@treatment_plan.id}?format=pdf") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @treatment_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /treatment_plans/1
  # DELETE /treatment_plans/1.xml
  def destroy
    @treatment_plan = TreatmentPlan.find(params[:id])
    @treatment_plan.destroy

    respond_to do |format|
      format.html { redirect_to(treatment_plans_url) }
      format.xml  { head :ok }
    end
  end
  
  def select_consultant
	@consultant = EmployeeMaster.find_by_empid(params[:consultant_id])
	@slice_word=@consultant.name.slice(0..1)
	@slice_word="OP"+@slice_word
	@treatment_plan_all = TreatmentPlan.last(:conditions=>"consultant_id='#{params[:consultant_id]}'")
	if( @treatment_plan_all.created_at == Date.today)
		if(@treatment_plan_all)
		
					new_no=@treatment_plan_all.medicines.slice!(4..100)
					new_mr_no=(@slice_word).to_s+(new_no.to_i+1).to_s
					render :text => @consultant.name+"<division>"+new_mr_no
		else
			
					new_mr_no=@slice_word+1.to_s
					render :text => @consultant.name+"<division>"+new_mr_no
					
		end
	else
		new_mr_no=@slice_word+1.to_s
		render :text => @consultant.name+"<division>"+new_mr_no
	end
	
end	
 
 def mr_no_search
 
	if(params[:patient_type]=="OP")
		appt_payment = AppointmentPayment.find(params[:record_id])
		consultantmaster=EmployeeMaster.find_by_empid(appt_payment.consultant_id)
		registration=Registration.find_by_mr_no_and_org_code(appt_payment.mr_no,appt_payment.org_code)
		image_path="empty"
		if(registration.image_path!="")
			image_path=registration.image_path
		end
		
		render :text => appt_payment.org_code+"<division>"+appt_payment.org_location+"<division>"+appt_payment.mr_no+"<division>"+""+"<division>"+registration.title+"."+registration.patient_name+"<division>"+registration.age.to_s+"<division>"+appt_payment.consultant_id+"<division>"+registration.id.to_s+"<division>"+image_path
	else
		image_path="empty"
		admissions = Admission.find_by_id(params[:record_id])
		treatment_plan = TreatmentPlan.all(:conditions => "admn_no='#{admissions.admn_no}'")
		registration=Registration.find_by_mr_no_and_org_code(admissions.mr_no,admissions.org_code)
    
		@treatment_plan_medicine = TreatmentPlan.first(:conditions => "admn_no = '#{admissions.admn_no}'")
		str=""
		if(@treatment_plan_medicine)
			for treatment_plan_medicine in @treatment_plan_medicine.medicine_list
				str<<treatment_plan_medicine.name.to_s+"<sub_division>"+treatment_plan_medicine.code.to_s+"<sub_division>"+treatment_plan_medicine.quantity.to_s+"<main_division>"
			end
		end
		if(registration.image_path!="")
      image_path=registration.image_path
    end
		render :text => admissions.org_code+"<division>"+admissions.org_location+"<division>"+admissions.mr_no+"<division>"+admissions.admn_no+"<division>"+registration.title+"."+registration.patient_name+"<division>"+registration.age.to_s+"<division>"+admissions.consultant_id+"<division>"+registration.id.to_s+"<division>"+image_path+"<division>"+str
	end
 end
 def ajax_function
		mr=params[:q]
		@splitname=mr.split("-->")
		@child_store = StoreChild.last(:conditions => "item_name = '#{@splitname[0]}'")	
		medicine = Itemmaster.find_by_product_name(@child_store.item_name)
		render :text => medicine.product_name
 end

 def vitals_graph_representation
	mr_no=params[:mr_no]
	@vital_observation = TreatmentPlan.find(:all, :conditions => "mr_no = '#{mr_no}'")
		i=0
		@date=Array.new
		for vital_observation in @vital_observation 
			@date[i]=vital_observation.treatment_date
			i+=1
		end 
  end
  
  def report
    @time=Time.now
    @treatment_plan = TreatmentPlan.find(params[:id])
    @registration=Registration.find_by_mr_no_and_org_code(@treatment_plan.mr_no,@treatment_plan.org_code)
    @vital= TreatmentPlan.find_by_mr_no_and_org_code(@registration.mr_no,@treatment_plan.org_code)
    @print_type=params[:print_type]
   @medicinelist1 = MedicineList.find(:all, :conditions=>"treatment_plan_id = '#{@treatment_plan.id}'")
    prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 10,
      :right_margin => 10,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "report.pdf"

    render :layout => false

  end
  
end
