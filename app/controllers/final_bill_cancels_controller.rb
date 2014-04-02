class FinalBillCancelsController < ApplicationController
  # GET /final_bill_cancels
  # GET /final_bill_cancels.xml
  def index
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@final_bill_cancel = FinalBillCancel.paginate :page => params[:page] || 1, 			:per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@org.org_code}'"
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @final_bill_cancel }
    end
  end
  
  # GET /final_bill_cancels/1
  # GET /final_bill_cancels/1.xml
  def show
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@final_bill_cancel = FinalBillCancel.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @final_bill_cancel }
    end
  end

  # GET /final_bill_cancels/new
  # GET /final_bill_cancels/new.xml
  def new
    @final_bill_cancel = FinalBillCancel.new
	#Get the org_code and org_location in people table based on user id.
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@people = Person.find(@session.person_id)
	@final_bill = FinalBill.find(:all,:conditions => "org_code ='#{@people.org_code}'")
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @final_bill_cancel }
    end
  end

  # GET /final_bill_cancels/1/edit
  def edit
   	@session_id=session[:id]
	  @session = Session.find(session[:id])
	  @org = Person.find(@session.person_id)
    @final_bill_cancel = FinalBillCancel.find(params[:id])
	  @registration=Registration.find_by_mr_no_and_org_code(@final_bill_cancel.mr_no,@final_bill_cancel.org_code)
	  @admission=Admission.find_by_admn_no_and_org_code(@final_bill_cancel.admn_no, @final_bill_cancel.org_code)
	  @first_name=@registration.patient_name
	  @floor=@admission.floor
	  @ward=@admission.ward
	  @room=@admission.room
	  @bed=@admission.bed
	end

  # POST /final_bill_cancels
  # POST /final_bill_cancels.xml
  def create
    @final_bill_cancel = FinalBillCancel.new(params[:final_bill_cancel])
	@final_bill=FinalBill.find_by_admn_no_and_org_code(@final_bill_cancel.admn_no,@final_bill_cancel.org_code)
	@final_bill.paid_amount=@final_bill_cancel.final_bill_cancel_amount
	 user_id=params[:user_id]
    respond_to do |format|
      if @final_bill_cancel.save
		@final_bill.update_attributes(params[:final_bill])
		format.html { redirect_to("/final_bill_cancels/report/#{@final_bill.id}?print_type=original&format=pdf", :notice => 'FinalBill was successfully created.') }
        format.xml  { render :xml => @final_bill_cancel, :status => :created, :location => @final_bill_cancel }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @final_bill_cancel.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  
  def print

	@final_bill_cancel = FinalBillCancel.find(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @final_bill_cancel }
    end
  end
  
 
 
 
  # PUT /final_bill_cancels/1
  # PUT /final_bill_cancels/1.xml
  def update
    @final_bill_cancel = FinalBillCancel.find(params[:id])

    respond_to do |format|
      if @final_bill_cancel.update_attributes(params[:final_bill_cancel])
        format.html { redirect_to("/final_bill_cancels?user_id=#{params[:user_id]}", :notice => 'FinalBillCancel was successfully Updated.') }
 
		  format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @final_bill_cancel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /final_bill_cancels/1
  # DELETE /final_bill_cancels/1.xml
  def destroy
    @final_bill_cancel = FinalBillCancel.find(params[:id])
    @final_bill_cancel.destroy

    respond_to do |format|
      format.html { redirect_to(final_bill_cancels_url) }
      format.xml  { head :ok }
    end
  end
  
  def ajax_function
	@final_bill=FinalBill.find_by_id(params[:admn_no])
	@admission=Admission.find_by_admn_no_and_org_code(@final_bill.admn_no,params[:org_code])
	@registration=Registration.find_by_mr_no_and_org_code(@admission.mr_no,params[:org_code])
	render :text => @final_bill.admn_no+"<division>"+@registration.mr_no+"<division>"+@final_bill.receipt_no.to_s+"<division>"+@registration.title+"."+@registration.patient_name+"<division>"+@admission.floor+"<division>"+@admission.ward+"<division>"+@admission.room+"<division>"+@admission.bed+"<division>"+@final_bill.paid_amount.to_s
	
  end
	def select_org_code
	transfer_data=TransferData.new
	render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
  end
  
  def observe_field_ex
  	@final_bill_cancel = FinalBillCancel.find(:all,:conditions=>"admn_no LIKE'%#{params[:admn_no]}' AND mr_no LIKE '%#{params[:mr_no]}' AND final_bill_amount LIKE '#{params[:final_bill_amount]}%' AND final_bill_cancel_amount LIKE '#{params[:final_bill_cancel_amount]}%'")
		if( @final_bill_cancel[0])
		   render:partial=>"seach_final_bill_cancel"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  
		
  end 
  def report
  	@people=Person.find_by_id(params[:user_id])
	
    @admission = Admission.find_by_id(params[:id])
	@final_bill_cancel = FinalBillCancel.find_by_id(params[:id])
	 @registration = Registration.find_by_mr_no_and_org_code(@final_bill_cancel.mr_no, @final_bill_cancel.org_code)
	@medicine=IssuesToOp.sum(:paid_amt, :conditions => "admn_no = '#{@final_bill_cancel.admn_no}' AND org_code = '#{@final_bill_cancel.org_code}'")
	puts @final_bill_cancel.org_code
	@lab_charge=TestBooking.sum(:total_amount, :conditions => "admn_no = '#{@final_bill_cancel.admn_no}'AND org_code = '#{@final_bill_cancel.org_code}'")
	
	@print_type=params[:print_type]
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
