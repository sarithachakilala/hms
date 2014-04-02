class AdvancePaymentsController < ApplicationController
  # GET /advance_payments
  # GET /advance_payments.xml
  def index
  @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)

@advance_payment = AdvancePayment.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@person.org_code}'"
	
	
	respond_to do |format|
    format.html # index.html.erb
    format.xml  { render :xml => @advance_payment }
    end
  end
  
def search
	@user_id=params[:user_id]
	@advance_payment = AdvancePayment.find(:all,:conditions => "admn_no = '#{params[:t]}'")
	render :partial => "search_advance_records"
end


  # GET /advance_payments/1
  # GET /advance_payments/1.xml
  def show
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@advance_payment = AdvancePayment.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @advance_payment }
    end
  end

  # GET /advance_payments/new
  # GET /advance_payments/new.xml
  def new
    @advance_payment = AdvancePayment.new
	#Get the org_code and org_location in people table based on user id.
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@admission=Admission.find(:all,:conditions => "org_code='#{@person.org_code}' and admn_status='Admitted'", :order =>"id DESC")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @advance_payment }
    end
  end

  # GET /advance_payments/1/edit
  def edit
 	  @session_id=session[:id]
	  @session = Session.find(session[:id])
	  @person = Person.find(@session.person_id)
    @advance_payment = AdvancePayment.find(params[:id])
 	  @admission=Admission.find_by_admn_no_and_org_code(@advance_payment.admn_no, @person.org_code)
	  @registration=Registration.find_by_mr_no_and_org_code(@advance_payment.mr_no,@person.org_code)
    @patient_name=@registration.patient_name
    @father_name=@registration.father_name
  	@floor=@admission.floor
  	@ward=@admission.ward
  	@room=@admission.room
  	@bed=@admission.bed
  end

  # POST /advance_payments
  # POST /advance_payments.xml
  def create
    @advance_payment = AdvancePayment.new(params[:advance_payment])
    @session_id=session[:id]
    @session = Session.find(session[:id])
    @person = Person.find(@session.person_id)
	@advance_payment.already_paid_amount=@advance_payment.gross_amount.to_f+@advance_payment.already_paid_amount.to_f


    respond_to do |format|
      if @advance_payment.save
	     # format.html { redirect_to(@advance_payment, :notice => 'advance payments was successfully created.') }
	       format.html { redirect_to("/advance_payments/report_bill/#{@advance_payment.id}?print_type=original&format=pdf", :notice => 'AdvancePayment was successfully created.') }
         format.xml  { render :xml => @advance_payment, :status => :created, :location => @advance_payment }
      else
		@adm=Admission.find_by_admn_no(@advance_payment.admn_no)
if(@adm)
		@patient_name=@adm.patient_name
		@ward=@adm.ward
		@room=@adm.room
		@floor=@adm.floor
		@bed=@adm.bed
end
        format.html { render :action => "new" }
        format.xml  { render :xml => @advance_payment.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /advance_payments/1
  # PUT /advance_payments/1.xml
  def update
    @advance_payment = AdvancePayment.find(params[:id])
    respond_to do |format|
      if @advance_payment.update_attributes(params[:advance_payment])
	   format.html { redirect_to("/advance_payments/report_bill/#{@advance_payment.id}?print_type=original&format=pdf", :notice => 'Admission was successfully updated.') }
        #format.html { redirect_to("/advance_payments/?user_id=#{params[:user_id]}", :notice => 'AdvancePayment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @advance_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /advance_payments/1
  # DELETE /advance_payments/1.xml
  def destroy
    @advance_payment = AdvancePayment.find(params[:id])
    @advance_payment.destroy

    respond_to do |format|
      format.html { redirect_to(advance_payments_url) }
      format.xml  { head :ok }
    end
  end
  
  def ajax_function
	@admission=Admission.find_by_id(params[:admn_no])
	number=Number.new
	update_reciept_value=number.retrive_value("receipt",@admission.org_code)
	advance=0
	total_amount=0
	@advance=AdvancePayment.last(:conditions=>"admn_no='#{@admission.admn_no}' and org_code='#{@admission.org_code}'")
	if(@advance)
		advance=@advance.already_paid_amount.to_f
	end

	if(@admission.admn_category=="Package")
		total_amount=@admission.amount
	end	
	@registration=Registration.find_by_mr_no_and_org_code(@admission.mr_no,@admission.org_code)
	render :text => @admission.admn_no+"<division>"+@registration.mr_no+"<division>"+update_reciept_value.to_s+"<division>"+@registration.title+"."+@registration.patient_name+"<division>"+@admission.floor+"<division>"+@admission.ward+"<division>"+@admission.room+"<division>"+@admission.bed+"<division>"+advance.to_s+"<division>"+total_amount.to_s
	
  end
   def select_org_code
	transfer_data=TransferData.new
	render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
  end
 
	 
	 def observe_field_ex

  	@advance_payment = AdvancePayment.find(:all,:conditions=>"admn_no LIKE '%#{params[:admn_no]}' AND mr_no LIKE '%#{params[:mr_no]}' AND advance_date LIKE '#{params[:advance_date]}%' AND receipt_no LIKE '#{params[:receipt_no]}%' AND gross_amount LIKE '#{params[:gross_amount]}%'AND already_paid_amount LIKE '#{params[:already_paid_amount]}%'")
		if( @advance_payment[0])
		   render:partial=>"search_advance_records"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  
	end
	
	
  	def report_bill
		@advance_payment = AdvancePayment.find(params[:id])
		@people=Person.find_by_id(params[:user_id])
		@print_type=params[:print_type]
		@registration=Registration.find_by_mr_no_and_org_code(@advance_payment.mr_no,@advance_payment.org_code)
    		@admissions=Admission.find_by_mr_no_and_org_code(@registration.mr_no, @registration.org_code)
		@to_watds=Number.new.number_to_words(@advance_payment.gross_amount.to_i)		
		prawnto :prawn => {
		  
		  :page_size => 'A4',
		  :left_margin => 10,
		  :right_margin => 10,
		  :top_margin => -15 ,
		  :bottom_margin => 30},
		  :filename => "report_bill.pdf"

		render :layout => false
	
	 end
end
