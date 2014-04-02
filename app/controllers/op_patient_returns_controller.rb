class OpPatientReturnsController < ApplicationController
  # GET /op_patient_returns
  # GET /op_patient_returns.xml
  require 'csv'
  def index
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@op_patient_return = OpPatientReturn.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@person.org_code}'"
    
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @op_patient_return }
    end
  end

  
  
  def search
	@user_id=params[:user_id]
	@org=Person.find_by_id(@user_id)
	@op_patient_return = OpPatientReturn.find(:all,:conditions => "return_no = '#{params[:t]}' and org_code = '#{@org.org_code}'")
	
	render :partial => "search_returns"
  end
  # GET /op_patient_returns/1
  # GET /op_patient_returns/1.xml
  def show
    @user_id = params[:user_id]
    @org=Person.find_by_id(@user_id)
	@op_patient_return = OpPatientReturn.find(params[:id])
	@patient_name=""
	@age=""
	@consultant_id=""
	@gender=""
	@issue_date=""
	@osp=IssuesToOp.find_by_receipt_no_and_org_code(@op_patient_return.receipt_no,@op_patient_return.org_code)	
	if(@op_patient_return.patient_type=="OP")
		@reg=Registration.find_by_mr_no_and_org_code(@op_patient_return.mr_No,@op_patient_return.org_code)
		@appt=AppointmentPayment.find_by_mr_no_and_org_code(@op_patient_return.mr_No,@op_patient_return.org_code)
		@patient_name=@reg.patient_name
		@age=@reg.age.to_s
		@consultant_id=@appt.consultant_id
		@gender=@reg.gender
		@issue_date=@osp.issue_date
	elsif(@op_patient_return.patient_type=="IP")
		@admn=Admission.find_by_admn_no_and_org_code(@op_patient_return.admn_no,@op_patient_return.org_code)
		@reg=Registration.find_by_mr_no_and_org_code(@admn.mr_no,@op_patient_return.org_code)
		@appt=AppointmentPayment.find_by_mr_no_and_org_code(@admn.mr_no,@op_patient_return.org_code)
		@patient_name=@reg.patient_name
		@age=@reg.age.to_s
		@consultant_id=@appt.consultant_id
		@gender=@reg.gender
		@issue_date=@osp.issue_date
	else(@op_patient_return.patient_type=="OSP")
		@patient_name=@osp.patient_name
		@age=@osp.age.to_s
		@issue_date=@osp.issue_date
		@consultant_id=""
		@gender=""
	end
	if(@op_patient_return.patient_type!="OSP")
		@pa=Registration.find_by_mr_no_and_org_code(@op_patient_return.mr_No,@op_patient_return.org_code)
		@am=AppointmentPayment.find_by_mr_no_and_org_code(@pa.mr_no,@pa.org_code)
		@cid=ConsultantMaster.find_by_consultant_id_and_org_code(@am.consultant_id,@am.org_code)
		@issue_op=IssuesToOp.find_by_receipt_no_and_org_code(@op_patient_return.receipt_no,@op_patient_return.org_code)
		@age=@pa.age
		@issue_date=@issue_op.issue_date
		@patient_name=@pa.patient_name
		@gender=@pa.gender
		@name=@pa.gender
	end
	
	respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @op_patient_return }
    end
  end

  # GET /op_patient_returns/new
  # GET /op_patient_returns/new.xml
  def new
    @op_patient_return = OpPatientReturn.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	10.times{ @op_patient_return.opreturn_child.build }
	#Get the org_code and org_location in people table based on user id.
	@people=Person.find_by_id(params[:user_id])
	
	@item_master=Itemmaster.find(:all, :conditions => "org_code = '#{@person.org_code}'", :select => "DISTINCT product_name")

	@op=OpPatientReturn.last(:select=>"Distinct return_no",:conditions =>"org_code='#{@org_code}'")
     if(@op)
       	n=(@op.return_no.slice!(6..50).to_i+1).to_s
       	str="SC0000"+n
	else
        n=1.to_s
		str="SC0000"+n
	end
	@op_patient_return.return_no=str
		
	respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @op_patient_return }
    end
  end 

  def op_patient_return_report
  
  	@people=Person.find_by_id(params[:user_id])
	
  end
  
  def export_to_csv
	
  end
  
   def print

	@op_patient_return = OpPatientReturn.find(params[:id])
	  respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @op_patient_return }
    end
  end
  
  
  # GET /op_patient_returns/1/edit
  def edit
  	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @op_patient_return = OpPatientReturn.find(params[:id])
		
  end

  # POST /op_patient_returns
  # POST /op_patient_returns.xml
  def create
 @op_patient_return = OpPatientReturn.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	
	user_id=params[:user_id]
    @op_patient_return = OpPatientReturn.new(params[:op_patient_return])

    
	@op=OpPatientReturn.last(:select=>"Distinct return_no",:conditions =>"org_code='#{@op_patient_return.org_code}'")
    if(@op)
       	n=(@op.return_no.slice!(6..50).to_i+1).to_s
       	str="SC0000"+n
	else
        n=1.to_s
		str="SC0000"+n
	end
	@op_patient_return.return_no=str
	for store1 in @op_patient_return.opreturn_child
		@child_store1 = StoreChild.find_by_item_name_and_batch_no(store1.item_name,store1.batch_no)
		@child_store1.quantity=@child_store1.quantity.to_i + store1.return_qty.to_i
		@child_store1.issued_quantity=@child_store1.issued_quantity.to_i - store1.return_qty.to_i
	
		@child_store1.update_attributes(params[:child_store1])
	end
	respond_to do |format|
		if @op_patient_return.save
			format.html { redirect_to("/reports/sales_thin_report_return/#{@op_patient_return.id}", :notice => 'op_patient_return was successfully created.') }
            format.xml  { render :xml => @op_patient_return, :status => :created, :location => @op_patient_return }
		else
			10.times{ @op_patient_return.opreturn_child.build }
			format.html { render :action => "new" }
			format.xml  { render :xml => @op_patient_return.errors, :status => :unprocessable_entity }
		end
    end
  end

  # PUT /op_patient_returns/1
  # PUT /op_patient_returns/1.xml
  def update
  
    @op_patient_return = OpPatientReturn.find(params[:id])

    respond_to do |format|
      if @op_patient_return.update_attributes(params[:op_patient_return])
        format.html { redirect_to("/op_patient_returns/?user_id=#{params[:user_id]}", :notice => 'OpPatientReturn was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @op_patient_return.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /op_patient_returns/1
  # DELETE /op_patient_returns/1.xml
  def destroy
    @op_patient_return = OpPatientReturn.find(params[:id])
    @op_patient_return.destroy

    respond_to do |format|
      format.html { redirect_to(op_patient_returns_url) }
      format.xml  { head :ok }
    end
  end
	def ajax_buildings
		mr=params[:q1]
		mr1=params[:q11]
		type=params[:s]
		mrn=params[:m]
		org_code=params[:org_code]
		receipt=params[:r]
		patient_type=params[:patient_type]
		str=""
		if(type=="service")
			item_batch_no=mr1.split("^")
			@issues=IssuesToOp.find_by_receipt_no_and_org_code(receipt,org_code)
			if(@issues)

				@test = IssueOpChild.find_by_issues_to_op_id_and_item_name_and_batch_no(@issues.id,item_batch_no[0].strip,item_batch_no[1])
				itemmaster=Itemmaster.find_by_product_name(item_batch_no[0])
				render :text =>itemmaster.product_code.to_s+","+itemmaster.manufacturer+","+@test.batch_no.to_s+","+@test.expiry_date.to_s+","+@test.issue_qty.to_s+","+@test.sale_rate.to_s+","+@test.discount.to_s+","+@test.vat.to_s
			else
				render :text=>"Invalid 	 No"
			end
		else
			@issues_to_op=IssuesToOp.last(:conditions => "receipt_no = '#{mr1}' and org_code = '#{org_code}' and patient_type ='#{patient_type}'")
			if(@issues_to_op)
				@pa=Registration.find_by_mr_no_and_org_code(@issues_to_op.mr_no,org_code)
				for item in @issues_to_op.issue_op_child
					str<< item.item_name.to_s+"^"+item.batch_no.to_s+"&"
				end
				if(@pa)
					age=@pa.age
					name=@pa.patient_name.to_s
					gender=@pa.gender.to_s
				else
					age=""
					name=@issues_to_op.patient_name
					gender=""
				end
				render :text =>@issues_to_op.admn_no.to_s+","+@issues_to_op.mr_no.to_s+","+@issues_to_op.issue_no.to_s+","+age.to_s+","+@issues_to_op.issue_date.to_s+","+name+","+gender.to_s+","+str
			else
				render :text =>"Invalid Receipt No"
			end
		end
	end
  def select_org_code
	transfer_data=TransferData.new
	render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
  end
  
	def returns
		date1=params[:date1]
		date2=params[:date2]
		org_code=params[:org_code]
		patient_type=params[:patient_type]
	
		if((org_code=="") && (patient_type==""))
			if(date1!="" && date2!="")
			query=["return_date BETWEEN ? AND ?",date1,date2]	
			end
				if(query)
				@returns=OpPatientReturn.new
				@returns.store_key(query)
				@return=OpPatientReturn.find(:all, :conditions => query)
				render :partial =>"op_patient_return"
				else 
				render :text =>"No Records"	
				end 
		elsif((org_code!="") && (patient_type!=""))
			if(date1!="" && date2!="")
			query=["return_date BETWEEN ? AND ? AND patient_type = ? ",date1,date2,patient_type]	
			end
				if(query)
				@returns=OpPatientReturn.new
				@returns.store_key(query)
				@return=OpPatientReturn.find(:all, :conditions => query)
				render :partial =>"op_patient_return"
				else 
				render :text =>"No Records"	
				end 
		elsif(patient_type=="")
			if(date1!="" && date2!="" && org_code!="")
			query=["return_date BETWEEN ? AND ? AND org_code = ?",date1,date2,org_code]	
			end
				if(query)
				@returns=OpPatientReturn.new
				@returns.store_key(query)
				@return=OpPatientReturn.find(:all, :conditions => query)
				render :partial =>"op_patient_return"
				else 
				render :text =>"No Records"	
				end 
	elsif(org_code=="")
			if(date1!="" && date2!="" && patient_type!="")
			query=["return_date BETWEEN ? AND ? AND patient_type = ?",date1,date2,patient_type]	
			end
				if(query)
				@returns=OpPatientReturn.new
				@returns.store_key(query)
				@return=OpPatientReturn.find(:all, :conditions => query)
				render :partial =>"op_patient_return"
				else 
				render :text =>"No Records"	
				end 
	end
end

def export_to_csv
@return=OpPatientReturn.find(:all)
	report = StringIO.new
CSV::Writer.generate(report, ',') do |title|
			title << ['Table Name','Item Name','Receipt No','Return No','Return Date','Retrn Amount','Patient Name','Patient Type']
			@return.each do |c|
			title << ['OP Returns',c.item_name,c.receipt_no,c.return_no,c.return_date,c.return_amount,c.patient_name,c.patient_type]
			end
		end
		report.rewind
		send_data(report.read,:type=>'text/csv;charset=iso-8859-1;header=present',:filename=>"goods.csv",:disposition =>'attachment', :encoding => 'utf8')

end

 def observe_field_ex
	@op_patient_return = OpPatientReturn.find(:all,:conditions=>"return_no LIKE '%#{params[:return_no]}' AND issue_No LIKE '%#{params[:issue_No]}' AND return_amount LIKE '#{params[:return_amount]}%' ")
	if( @op_patient_return[0])
		   render:partial=>"search_returns"
	else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
	end
	
  end 


end
