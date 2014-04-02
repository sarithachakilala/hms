class IpDuesController < ApplicationController
  # GET /ip_dues
  # GET /ip_dues.xml
  def index
    @ip_due = IpDue.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@ip_due = IpDue.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@org.org_code}'"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ip_due }
    end
  end

  
  # GET /ip_dues/1
  # GET /ip_dues/1.xml
  def show
    @user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
	@ip_due = IpDue.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ip_due }
    end
  end

  # GET /ip_dues/new
  # GET /ip_dues/new.xml
  def new
    @ip_due = IpDue.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@final_bill = FinalBill.find(:all,:conditions => "org_code ='#{@person.org_code}' and balance_amount!=0")
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ip_due }
    end
  end

  
   def print

	 @ip_due = IpDue.find(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ip_due }
    end
  end
  
  # GET /ip_dues/1/edit
  def edit
   @user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
	@ip_due = IpDue.find(params[:id])

  end

  # POST /ip_dues
  # POST /ip_dues.xml
  def create
 @ip_due = IpDue.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @ip_due = IpDue.new(params[:ip_due])
	@final_bill=FinalBill.find_by_admn_no_and_org_code(@ip_due.admn_no,@ip_due.org_code)
	@final_bill.paid_amount=@ip_due.remaining_amount+@final_bill.paid_amount
	@final_bill.balance_amount=0
	@n=Number.new
	update_reciept_value=@n.retrive_value("receipt",@ip_due.org_code)
	@ip_due.receipt_no=update_reciept_value
	user_id=params[:user_id]
    respond_to do |format|
      if @ip_due.save
	    @n=Number.find_by_name_and_org_code("receipt",@ip_due.org_code)
		@n.value=@ip_due.receipt_no
		@n.update_attributes(params[:n])
        @final_bill.update_attributes(params[:final_bill])
		format.html { redirect_to("/ip_dues/report/#{@ip_due.id}?print_type=original&format=pdf", :notice => 'FinalBill was successfully created.') }  
	    format.xml  { render :xml => @ip_due, :status => :created, :location => @ip_due }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ip_due.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ip_dues/1
  # PUT /ip_dues/1.xml
  def update
    @ip_due = IpDue.find(params[:id])

    respond_to do |format|
      if @ip_due.update_attributes(params[:ip_due])
        format.html { redirect_to("/ip_dues/report/#{@ip_due.id}?print_type=original&format=pdf", :notice => 'IpDue was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ip_due.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ip_dues/1
  # DELETE /ip_dues/1.xml
  def destroy
    @ip_due = IpDue.find(params[:id])
    @ip_due.destroy

    respond_to do |format|
      format.html { redirect_to(ip_dues_url) }
      format.xml  { head :ok }
    end
  end
  
  def ajax_function
	type=params[:type]
	@final_bill=FinalBill.find_by_id(params[:admn_no])
	@admission=Admission.find_by_admn_no_and_org_code(@final_bill.admn_no,params[:org_code])
	due=@final_bill.remaining_amount-@final_bill.paid_amount
	number=Number.new
	update_reciept_value=number.retrive_value("receipt",params[:org_code])
	@registration=Registration.find_by_mr_no_and_org_code(@admission.mr_no,params[:org_code])
	render :text => @final_bill.admn_no+"<division>"+@registration.mr_no+"<division>"+update_reciept_value.to_s+"<division>"+@registration.patient_name+"<division>"+@admission.floor+"<division>"+@admission.ward+"<division>"+@admission.room+"<division>"+@admission.bed+"<division>"+@final_bill.remaining_amount.to_s+"<division>"+due.to_s
  end
  
  def select_org_code
	transfer_data=TransferData.new
	render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
  end
  
  def observe_field_ex
  	@ip_due = IpDue.find(:all,:conditions=>"admn_no LIKE'%#{params[:admn_no]}' AND mr_no LIKE '%#{params[:mr_no]}' AND due_date LIKE '#{params[:due_date]}%' AND receipt_no LIKE '#{params[:receipt_no]}%'AND gross_amount LIKE '#{params[:gross_amount]}%'AND due LIKE '#{params[:due]}%'")
		if( @ip_due[0])
		   render:partial=>"seach_ip_due_records"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  	
  end 
  
  def report
  	@people=Person.find_by_id(params[:user_id])
    @admission = Admission.find_by_id(params[:id])
puts "ffffffffffffffffffffffffFFF"
puts params[:id]
	@ip_due = IpDue.find_by_id(params[:id])
   	@registration = Registration.find_by_mr_no(@ip_due.mr_no)
	
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
