class IssuesToOpsController < ApplicationController
  # GET /issues_to_ops
  # GET /issues_to_ops.xml
  def index
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@issues_to_op= IssuesToOp.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@person.org_code}'"
    
	respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @issues_to_op }
    end
  end

  
 def sales_report_by_patientwise
	@people=Person.find_by_id(params[:user_id])
	if(@people.code_option=="0")
		@org_code=@people.org_code
		@org_location=@people.org_location
	else
		transfer_data=TransferData.new
		@org_code=transfer_data.get_org_codes(@people.port_number)
	end
  end 
  
  def sales_tax_reports
	@people=Person.find_by_id(params[:user_id])
	if(@people.code_option=="0")
		@org_code=@people.org_code
		@org_location=@people.org_location
	else
		transfer_data=TransferData.new
		@org_code=transfer_data.get_org_codes(@people.port_number)
	end
  end  
  
  def search
@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@issues_to_op= IssuesToOp.find(:all,:conditions => "issue_no = '#{params[:t]}' and org_code = '#{@org.org_code}'")
	
	
	render :partial => "search_op_record"
  end
  
  # GET /issues_to_ops/1
  # GET /issues_to_ops/1.xml
  def show
  @session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@issues_to_op = IssuesToOp.find(params[:id])
	@patient_name=""
	@age=""
	@consultant_id=""
	
	if(@issues_to_op.patient_type=="OP")
		@reg=Registration.find_by_mr_no_and_org_code(@issues_to_op.mr_no,@issues_to_op.org_code)
		@appt=AppointmentPayment.find_by_mr_no_and_org_code(@issues_to_op.mr_no,@issues_to_op.org_code)
		@patient_name=@reg.patient_name
		@age=@reg.age.to_s
		@consultant_id=@appt.consultant_id
	elsif(@issues_to_op.patient_type=="IP")
		@admn=Admission.find_by_admn_no_and_org_code(@issues_to_op.admn_no,@issues_to_op.org_code)
		@reg=Registration.find_by_mr_no_and_org_code(@admn.mr_no,@issues_to_op.org_code)
		@appt=Admission.find_by_mr_no_and_org_code(@admn.mr_no,@issues_to_op.org_code)
		@patient_name=@reg.patient_name
		@age=@reg.age.to_s
		@consultant_id=@appt.consultant_id
	else(@issues_to_op.patient_type=="OSP")
		@patient_name=@issues_to_op.patient_name
		@age=@issues_to_op.age.to_s
		@consultant_id=""
	end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @issues_to_op }
    end
  end

  # GET /issues_to_ops/new
  # GET /issues_to_ops/new.xml
  def new
    @issues_to_op = IssuesToOp.new
	#Get the org_code and org_location in people table based on user id.
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	@item_masters=StoreChild.find(:all, :select => "DISTINCT item_name")
	@item_master1=Array.new
	i=0
	for item in @item_masters
		@store_children = StoreChild.sum(:quantity,:conditions => "item_name = '#{item.item_name}'")
		@item_master1[i]=item.item_name+" --> "+@store_children.to_s
		i+=1
	end
	@item_master=Itemmaster.find(:all, :conditions => "org_code = '#{@person.org_code}'", :select => "DISTINCT product_name")
	@storechild=StoreChild.find(:all, :conditions=>"quantity > 0 ")	
	@item_batchno=Array.new
	for i in 0...@storechild.length
		@item_batchno[i]=@storechild[i].item_name+"--->"+@storechild[i].batch_no
	end	
	
	10.times{ @issues_to_op.issue_op_child.build }
	@op=IssuesToOp.last(:select=>"DISTINCT receipt_no",:conditions =>"org_code='#{@org_code}'")
    	if(@op)
		n=(@op.receipt_no.slice!(2..100).to_i+1).to_s
	else
		n=1.to_s
	end
	str="SI000000"+n
	@issues_to_op.receipt_no=str
	
	@registration=Registration.find(:all, :conditions =>"org_code ='#{@org_code}'", :order =>"id DESC")
	@appt_payment = AppointmentPayment.all(:conditions => "appt_date > '#{Date.today-6}'", :order =>"id DESC")
	@admission=Admission.find(:all,:conditions =>"org_code ='#{@org_code}' and admn_status='Admitted'", :order =>"id DESC")
	@treatment_plan = TreatmentPlan.all(:conditions =>"org_code ='#{@org_code}' and patient_type='IP'", :order =>"id DESC")
	@treatment_plan_op = TreatmentPlan.all(:conditions =>"org_code ='#{@org_code}' and patient_type='OP' and treatment_date='#{Date.today}'")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @issues_to_op }
    end
  end
def issues_to_op_reports
  
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code

  end
  
  # GET /issues_to_ops/1/edit
  def edit
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@person = Person.find(@session.person_id)
	@storechild=StoreChild.find(:all, :conditions=>"org_code='#{@org.org_code}' and quantity > 0 ")	
	@item_batchno=Array.new
	for i in 0...@storechild.length
		@item_batchno[i]=@storechild[i].item_name+"-"+@storechild[i].batch_no
	end	

	@issues_to_op = IssuesToOp.find(params[:id])
	10.times{ @issues_to_op.issue_op_child.build }
	@appt=AppointmentPayment.find_by_mr_no_and_org_code(@issues_to_op.mr_no,@issues_to_op.org_code)
	@item_master=Itemmaster.find(:all, :conditions => "org_code = '#{@org.org_code}'", :select => "DISTINCT product_name")
	@storechild=StoreChild.find(:all, :conditions=>"quantity > 0 ")	
	@item_batchno=Array.new
	for i in 0...@storechild.length
		@item_batchno[i]=@storechild[i].item_name+"--->"+@storechild[i].batch_no
	end

	@item_masters=StoreChild.find(:all, :select => "DISTINCT item_name")
	@item_master1=Array.new
	i=0
	for item in @item_masters
		@store_children = StoreChild.sum(:quantity,:conditions => "item_name = '#{item.item_name}'")
		@item_master1[i]=item.item_name+" --> "+@store_children.to_s
		i+=1
	end 
  end

  # POST /issues_to_ops
  # POST /issues_to_ops.xml
  def create
	@issues_to_op = IssuesToOp.new(params[:issues_to_op])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	@item_masters=StoreChild.find(:all, :select => "DISTINCT item_name")
	@item_master1=Array.new
	i=0
	for item in @item_masters
		@store_children = StoreChild.sum(:quantity,:conditions => "item_name = '#{item.item_name}'")
		@item_master1[i]=item.item_name+" --> "+@store_children.to_s
		i+=1
	end
	@item_master=Itemmaster.find(:all, :conditions => "org_code = '#{@person.org_code}'", :select => "DISTINCT product_name")
	@storechild=StoreChild.find(:all, :conditions=>"quantity > 0 ")	
	@item_batchno=Array.new
	for i in 0...@storechild.length
		@item_batchno[i]=@storechild[i].item_name+"--->"+@storechild[i].batch_no
	end	
	
	@op=IssuesToOp.last(:select=>"DISTINCT receipt_no",:conditions =>"org_code='#{@org_code}'")
     	if(@op)
		n=(@op.receipt_no.slice!(2..100).to_i+1).to_s
	else
		n=1.to_s

	end
	str="SI000000"+n
	@issues_to_op.receipt_no=str
	@registration=Registration.find(:all, :conditions =>"org_code ='#{@org_code}'", :order =>"id DESC")
	@appt_payment = AppointmentPayment.all(:conditions => "appt_date > '#{Date.today-6}'", :order =>"id DESC")
	@admission=Admission.find(:all,:conditions =>"org_code ='#{@org_code}' and admn_status='Admitted'", :order =>"id DESC")
	@treatment_plan = TreatmentPlan.all(:conditions =>"org_code ='#{@org_code}' and patient_type='IP'", :order =>"id DESC")
	@treatment_plan_op = TreatmentPlan.all(:conditions =>"org_code ='#{@org_code}' and patient_type='OP' and treatment_date='#{Date.today}'")

    	user_id=params[:user_id] 
	if(@issues_to_op.patient_type !='OSP' && @issues_to_op.patient_name!="")
		@issues_to_op.title=@issues_to_op.patient_name.split(".")[0]		
		@issues_to_op.patient_name=Number.new.change_patient_name(@issues_to_op.patient_name)
	elsif(@issues_to_op.patient_type =='OSP' && @issues_to_op.patient_name!="")
		@issues_to_op.patient_name=@issues_to_op.patient_name.capitalize
	end				
	respond_to do |format|
		if @issues_to_op.save 
			@reg=Registration.find_by_mr_no_and_org_code(@issues_to_op.mr_no,@issues_to_op.org_code)
			@op=IssuesToOp.last(:select=>"DISTINCT receipt_no",:conditions =>"org_code='#{@issues_to_op.org_code}'")
			if(@op)
				n=(@op.receipt_no.slice!(2..50).to_i+1).to_s
			else
				n=0000001.to_s
			end
			str="SI"+n
			@issues_to_op.receipt_no=str
				
	
			if(!@issues_to_op.receipt_no)
				format.html { redirect_to("/issues_to_ops/day_wise_report/1?user_id=#{user_id}", :notice => 'Issues was successfully created.') }
				format.xml  { render :xml => @issue, :status => :created, :location => @issue }
			else
			str=""
			str1=""
				
			if(@issues_to_op.patient_type=="OP" || @issues_to_op.patient_type=="OSP"|| @issues_to_op.patient_type=="IP" || params[:form_name].to_s=="arogya")
				for store in @issues_to_op.issue_op_child
					@store_child=StoreChild.all(:conditions => "item_name = '#{store.item_name}' and quantity > 0 and batch_no = '#{store.batch_no}'")
					issue=store.issue_qty
					for st in @store_child
						if((st.quantity).to_i>issue.to_i)
							store1=StoreChild.find_by_id(st.id)
							store1.quantity=(store1.quantity).to_i-(issue).to_i
							store1.issued_quantity=store1.issued_quantity.to_i+issue
							issue=0
							store1.update_attributes(params[:store1])
							break;
						else
							store1=StoreChild.find_by_id(st.id)
							issue=issue.to_i-(store1.quantity).to_i
							store1.quantity=0
							store1.issued_quantity=store1.issued_quantity+issue
							store1.update_attributes(params[:store1])
						end
					end
				end
			
			end
			if(@issues_to_op.patient_type.to_s=="IP" && @issues_to_op.reg_type.to_s=="Arogyasree" && params[:form_name].to_s=="arogya")
				format.html { redirect_to("/issues_to_ops/arogyasree_medicine/1?user_id=#{user_id}", :notice => 'Issues was successfully created.') }
			else
				format.html { redirect_to("/reports/sales_thin_report/#{@issues_to_op.id}?user_id=#{user_id}&format=pdf") }
			end
				format.xml  { render :xml => @issues_to_op, :status => :created, :location => @issues_to_op }
			end	
		else
			10.times{ @issues_to_op.issue_op_child.build }
			format.html { render :action => "new" }
			format.xml  { render :xml => @issues_to_op.errors, :status => :unprocessable_entity }
		end
    end
  end

  
  def print
	@issues_to_op = IssuesToOp.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @issues_to_op }
    end
  end
 
  
  
  def report1
    @print_type=params[:print_type]
   @issues_to_op = IssuesToOp.find(params[:id])
@discount=  @issues_to_op.total_amount.to_f - @issues_to_op.due_amount.to_f
  #for issues_to_op in @issues_to_op.issue_op_child
	# puts issues_to_op.id
	#end
	@issue=IssueOpChild.find(:all, :conditions => "issues_to_op_id = '#{@issues_to_op.id}'")
	prawnto :prawn => {
		  :page_size => 'A4',
		  :left_margin => 10,
		  :right_margin => 10,
		  :top_margin => 10,
		  :bottom_margin => 30},
      :filename => "#{@issues_to_op.created_at.strftime("%d-%m-%y")}.pdf"
    render :layout => false
 
	end

  
  # PUT /issues_to_ops/1
  # PUT /issues_to_ops/1.xml
  def update
    @issues_to_op = IssuesToOp.find(params[:id])
		user_id=params[:user_id] 
    for sales in  @issues_to_op.issue_op_child
	purchase_invoice_children=StoreChild.find_by_item_name_and_batch_no(sales.item_name,sales.batch_no)
	StoreChild.update(purchase_invoice_children.id,:quantity=> (purchase_invoice_children.quantity).to_i + (sales.issue_qty).to_i, :issued_quantity =>(purchase_invoice_children.issued_quantity).to_i-(sales.issue_qty).to_i)
   end
						

    respond_to do |format|
      if @issues_to_op.update_attributes(params[:issues_to_op])
	for sales in  @issues_to_op.issue_op_child
		if(sales.item_name!="")
		purchase_invoice_children=StoreChild.find_by_item_name_and_batch_no(sales.item_name,sales.batch_no)
		StoreChild.update(purchase_invoice_children.id,:quantity=> (purchase_invoice_children.quantity).to_i - (sales.issue_qty).to_i, :issued_quantity =>(purchase_invoice_children.issued_quantity).to_i+(sales.issue_qty).to_i)
		end
      end

        format.html { redirect_to("/reports/sales_thin_report/#{@issues_to_op.id}?user_id=#{user_id}&format=pdf", :notice => 'IssuesToOp was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @issues_to_op.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /issues_to_ops/1
  # DELETE /issues_to_ops/1.xml
  def destroy
    @issues_to_op = IssuesToOp.find(params[:id])
    @issues_to_op.destroy
    respond_to do |format|
      format.html { redirect_to(issues_to_ops_url) }
      format.xml  { head :ok }
    end
  end
  
	def ajax_buildings1
		select_patient=params[:select_patient]
		mr=params[:q]
		type=params[:s]
		org_code=params[:org_code]
		dept_type=params[:dept_type]
		if(type=="admn_no")
			@admission = Admission.find_by_id(mr)
			@pa=Registration.find_by_mr_no_and_org_code(@admission.mr_no,org_code)
			consultant_master=EmployeeMaster.find_by_empid(@admission.consultant_id)
			cons=consultant_master.name
			str=""
			render :text =>@admission.admn_no+","+@pa.mr_no+","+@pa.title+"."+@pa.patient_name+","+@pa.age.to_s+","+cons+","+@admission.admn_category
		elsif(type=="mr_no")
			@appt_payment = AppointmentPayment.find_by_id(mr)
			@pa=Registration.find_by_mr_no_and_org_code(@appt_payment.mr_no,org_code)
			cons=""
			consultant_master=EmployeeMaster.find_by_empid(@appt_payment.consultant_id)
			render :text =>""+","+@pa.mr_no+","+@pa.title+"."+@pa.patient_name+","+@pa.age.to_s+","+consultant_master.name+","+""+","+@pa.reg_type+","
		else
			@splitname=mr.split("-->")
			@child_store = StoreChild.last(:conditions => "item_name = '#{@splitname[0]}'")
			if(@child_store)
				item_master=Itemmaster.find_by_product_name(@splitname[0])
				@qunatity = StoreChild.sum(:quantity,:conditions => "item_name = '#{@splitname[0]}'")
				@rate = (@child_store.mrp.to_f/item_master.units.to_i)
				render :text => @child_store.item_name.to_s+","+@child_store.batch_no.to_s+","+@child_store.expiry_date.to_s+","+(@qunatity.to_i).to_s+","+(@rate).to_s+","+""+","+""+","+@child_store.vat.to_s+","+"<division>"
			else
				render :text =>"Invalid item"
			end
		end
	end
 
	def select_org_code
		transfer_data=TransferData.new
		render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
	end
	
	def sales
		@date1=params[:date1]
		puts @date1
		@date2=params[:date2]
		puts @date2
		@org_code=params[:org_code]
		puts @org_code
		@patient_type=params[:patient_type]
		puts @patient_type
		if((@org_code=="") && (@patient_type==""))
			if(date1!="" && date2!="")
			query=["issue_date BETWEEN ? AND ?",date1,date2]	
			end
				if(query)
				@issues=IssuesToOp.new
				@issues.store_key(query)
				@issue=IssuesToOp.find(:all, :conditions => query)
				render :partial =>"issues_to_op_reports"
				else 
				render :text =>"No Records"	
				end 
	elsif((@org_code!="") && (@patient_type!=""))
			if(@date1!="" && @date2!="")
			query=["issue_date BETWEEN ? AND ? AND patient_type = ? ",@date1,@date2,@patient_type]	
			end
				if(query)
				@issues=IssuesToOp.new
				@issues.store_key(query)
				@issue=IssuesToOp.find(:all, :conditions => query)
				render :partial =>"issues_to_op_reports"
				else 
				render :text =>"No Records"	
				end 
	elsif(@patient_type=="")
			if(@date1!="" && @date2!="" && @org_code!="")
			query=["issue_date BETWEEN ? AND ? AND org_code = ?",@date1,@date2,@org_code]	
			end
				if(query)
				@issues=IssuesToOp.new
				@issues.store_key(query)
				@issue=IssuesToOp.find(:all, :conditions => query)
				render :partial =>"issues_to_op_reports"
				else 
				render :text =>"No Records"	
				end 
	elsif(org_code=="")
			if(@date1!="" && @date2!="" && @patient_type!="")
			query=["issue_date BETWEEN ? AND ? AND patient_type = ?",@date1,@date2,@patient_type]	
			end
				if(query)
				@issues=IssuesToOp.new
				@issues.store_key(query)
				@issue=IssuesToOp.find(:all, :conditions => query)
				render :partial =>"issues_to_op_reports"
				else 
				render :text =>"No Records"	
				end 

	end
		
end
	
	def generate_reports
	
	@issues=IssuesToOp.new
	 @data=@issues.return_key
	pdf = IssuesToOpReport.render_csv(:mrno => @data)
	send_data pdf, :type => "text/csv",
    :filename => "issues_reporting.csv"
  end
def sales_tax_report
	
	date1=params[:date_value]
	date2=params[:date_value1]
	org_code=params[:org_code]
	@vat_percentage=params[:vat_percentage]
	
	if(org_code=="")
			if(date1!="" && date2!="")
			query=["issue_date BETWEEN ? AND ?",date1,date2]	
			end
			
				if(query)
					@issue=IssuesToOp.find(:all, :conditions => query)
					issues_op=IssueOpChild.find_by_issues_to_op_id_and_vat(@issue[0].id,@vat_percentage)
					render :partial =>"sales_tax_reporting"
				else 
				render :text =>"No Records"	
				end 
	
	elsif(org_code!="")
			if(date1!="" && date2!="" && org_code!="")
			query=["issue_date BETWEEN ? AND ? AND org_code = ?",date1,date2,org_code]	
			end
				if(query)
				@issue=IssuesToOp.find(:all, :conditions => query)
				issues_op=IssueOpChild.find_by_issues_to_op_id_and_vat(@issue[0].id,@vat_percentage)
				render :partial =>"sales_tax_reporting"
				else 
				render :text =>"No Records"	
				end 
	end
end

def generate_reports_vat
	
	@issues=IssuesToOp.new
	 @data=@issues.return_key
	pdf = IssuesToOpReport.render_csv(:mrno => @data)
	send_data pdf, :type => "text/csv",
    :filename => "issues_reporting.csv"
  end

def sales_report_by_patientwise_report
	
	date1=params[:date1]
	date2=params[:date2]
	org_code=params[:org_code]
	mr_no=params[:mr_no]
	patient_name=params[:patient_name]
	
	if(org_code=="")
			if(date1!="" && date2!="" && mr_no!="" && patient_name!="")
			query=["issue_date BETWEEN ? AND ? AND mr_no =? AND patient_name LIKE ?",date1,date2,mr_no,patient_name]	
			elsif(date1!="" && date2!="" && mr_no!="")
			query=["issue_date BETWEEN ? AND ? AND mr_no =?",date1,date2,mr_no]	
			elsif(date1!="" && date2!="" && patient_name!="")
			query=["issue_date BETWEEN ? AND ? AND patient_name LIKE?",date1,date2,patient_name]	
			elsif(date1!="" && date2!="")
			query=["issue_date BETWEEN ? AND ? ",date1,date2]
			elsif(mr_no!="" && patient_name!="")
			query=["mr_no = ?  AND patient_name LIKE ?",mr_no,patient_name]				
			elsif(mr_no!="")
			query=["mr_no = ? ",mr_no]
			elsif(patient_name!="")
			query=["patient_name = ? ",patient_name]
			end
			
				if(query)
					isse=IssuesToOp.new
					isse.store_key(query)
					@issue=IssuesToOp.find(:all, :conditions => query)
					render :partial =>"sales_report_by_patientwising"
				else 
				render :text =>"No Records"	
				end 
	
	elsif(org_code!="")
			if(date1!="" && date2!="" && mr_no!="" && patient_name!="")
			query=["issue_date BETWEEN ? AND ? AND mr_no =? AND patient_name LIKE ? AND org_code = ?",date1,date2,mr_no,patient_name,org_code]	
			elsif(date1!="" && date2!="" && mr_no!="")
			query=["issue_date BETWEEN ? AND ? AND mr_no =? AND org_code = ?",date1,date2,mr_no,org_code]	
			elsif(date1!="" && date2!="" && patient_name!="")
			query=["issue_date BETWEEN ? AND ? AND patient_name LIKE? AND org_code = ?",date1,date2,patient_name,org_code]	
			elsif(date1!="" && date2!="")
			query=["issue_date BETWEEN ? AND ? AND org_code = ?",date1,date2,org_code]
			elsif(mr_no!="" && patient_name!="")
			query=["mr_no = ?  AND patient_name LIKE ? AND org_code = ?",mr_no,patient_name,org_code]				
			elsif(mr_no!="")
			query=["mr_no = ? AND org_code = ?",mr_no,org_code]
			elsif(patient_name!="")
			query=["patient_name = ? AND org_code = ?",patient_name,org_code]
			end
				if(query)
				isse=IssuesToOp.new
				isse.store_key(query)
				@issue=IssuesToOp.find(:all, :conditions => query)
				render :partial =>"sales_report_by_patientwising"
				else 
				render :text =>"No Records"	
				end 
	end
end

def generate_reports_patientwise
	@issue=IssuesToOp.new
	 @data=@issue.return_key
	pdf = IssuesPatientwiseReportingReport.render_csv(:mrno => @data)
	send_data pdf, :type => "text/csv",
    :filename => "issues_patientwise_reporting.csv"
	
  end
  
  def arogyasree_medicine
	 @issues_to_op = IssuesToOp.new
	#Get the org_code and org_location in people table based on user id.
	@people=Person.find_by_id(params[:user_id])
	if(@people.code_option=="0")
		@org_code=@people.org_code
		@org_location=@people.org_location
	else
		transfer_data=TransferData.new
		@org_code=transfer_data.get_org_codes(@people.port_number)
	end
	
	@item_masters=StoreChild.find(:all, :conditions => "org_code = '#{@people.org_code}'", :select => "DISTINCT item_name")
	@item_batchno=Array.new
	i=0
	for item in @item_masters
		@store_children = StoreChild.sum(:quantity,:conditions => "item_name = '#{item.item_name}'")
		@item_batchno[i]=item.item_name+" --> "+@store_children.to_s
		i+=1
	end
	10.times{ @issues_to_op.issue_op_child.build }
	@op=IssuesToOp.last(:select=>"DISTINCT issue_no",:conditions =>"org_code='#{@org_code}'")
    if(@op)
		n=(@op.issue_no.slice!(3..100).to_i+1).to_s
	else
		n=1.to_s
	end
	str="ISS"+n
	@issues_to_op.issue_no=str
	
	@op1=IssuesToOp.last(:select=>"DISTINCT receipt_no",:conditions =>"org_code='#{@org_code}'")
	if(@op1)
		n1=(@op1.receipt_no.slice!(2..50).to_i+1).to_s
		str1="OP"+n1
	else
		n1=1.to_s
		str1="OP"+n1
	end
	@issues_to_op.receipt_no=str1
	@registration=Registration.find(:all, :conditions =>"org_code ='#{@org_code}'", :order =>"id DESC")
	@admission=Admission.find(:all,:conditions =>"org_code ='#{@org_code}' and admn_status='Admitted'")
  end
  
  def ajax_building_arogyasree
	@ip=Admission.find_by_id(params[:admission_id])
	@pa=Registration.find_by_mr_no_and_org_code(@ip.mr_no,@ip.org_code)
	render :text =>@ip.admn_no+","+@ip.mr_no+","+@pa.first_name+","+@pa.age.to_s+","+@ip.consultant_id+","+@pa.reg_type
  end
  
   def vat_purchase
  
	mon=params[:month]
	date=Date.today.strftime("%d-%b-%Y").split("-")
	if(!mon || mon=="")
		mon=date[1]
	end
	month={"Jan" => "01","Feb" => "02","Mar" => "03","Apr" => "04","May" => "05","Jun" => "06","Jul" => "07","Aug" => "08","Sep" => "09","Oct" =>"10","Nov" =>"11","Dec" =>"12"}
	@issue = IssuesToOp.find(:all, :conditions => " issue_date LIKE '#{params[:year]}-#{month[mon]}-%'")
	render :partial => "sales_vat"
  end
  
  
   def day_wise_report
	  @issues_to_op = IssuesToOp.new
	  @issue_last_id= IssuesToOp.last(:conditions =>"issue_no IS NULL") 
		  
		  @issue_first=0
		  if(@issue_last_id)
		  @issue_first=@issue_last_id.id
		  end
		  @issue1 = IssuesToOp.last(:conditions =>"issue_no!=''")
		  if(@issue1)
			@issue=IssuesToOp.find(:all, :conditions=>"id between '#{@issue_first+1}' and '#{@issue1.id}'")
			end
			#@issue=StoreChild.find(:all, :conditions=>"@issues_to_op.issue_date like '#{@date}'")	
			respond_to do |format|
			  format.html # new.html.erb
			  format.xml  { render :xml => @issues_to_op }
			end
	end
	
	 def observe_field_ex
puts "ffffffffffffffffffffffffff"
puts params[:issue_no]
puts params[:issue_date]
puts params[:due_amount]
puts params[:due]
puts params[:paid_amt]
  	@issues_to_op = IssuesToOp.find(:all,:conditions=>"receipt_no LIKE '%#{params[:issue_no]}' AND issue_date LIKE '#{params[:issue_date]}%' AND due_amount LIKE '#{params[:due_amount]}%' AND paid_amt LIKE '#{params[:paid_amt]}%'")
		if( @issues_to_op[0])
		   render:partial=>"search_op_record"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  
		
  end 
  
  def export_to_csv
	
		@goods_receipts=StoreChild.find(:all)
		report = StringIO.new
		CSV::Writer.generate(report, ',') do |title|
			title << ['Table Name','Item Name','Item Code','Drug Type','Packing','No.Of Units','Quantity','BatchNo','Exp.Date','MRP','Pur.Rate','Amount','Vat']
			@goods_receipts.each do |c|
			title << ['Goods Child',c.item_name,c.item_code,c.drug_type,c.packing,c.units,c.quantity,c.batch_no,c.expiry_date,c.mrp,c.purchase_rate,c.amount,c.vat,c.mfr]
			end
		end
		report.rewind
		send_data(report.read,:type=>'text/csv;charset=iso-8859-1;header=present',:filename=>"goods.csv",:disposition =>'attachment', :encoding => 'utf8')
	end

def product_info
		@purchase_invoice_children = StoreChild.all(:conditions => "item_name LIKE '#{params[:product_name]}%'")
  end
 def get_medicine
		purchase_invoice_children=StoreChild.find_by_item_name_and_batch_no_and_goodsrecieptnotemaster_id(params[:medicine_name],params[:batch_no],params[:product_id])
		render :text =>  purchase_invoice_children.item_name.to_s+"<division>"+ purchase_invoice_children.batch_no.to_s+"<division>"+ purchase_invoice_children.expiry_date.to_s+"<division>"+purchase_invoice_children.quantity.to_s+"<division>"+ purchase_invoice_children.free.to_s+"<division>"+purchase_invoice_children.mrp.to_s+"<division>"+purchase_invoice_children.vat.to_s+"<division>"+purchase_invoice_children.id.to_s
  end

end
