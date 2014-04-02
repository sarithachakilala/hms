class PharmacyPaymentsController < ApplicationController
  # GET /pharmacy_payments
  # GET /pharmacy_payments.xml
  require 'csv'
  def index
   	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)

	@pharmacy_payment = PharmacyPayment.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@person.org_code}'"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pharmacy_payment }
    end
  end

  def search
	 @user_id=params[:user_id]
	@org=Person.find_by_id(@user_id)

	@pharmacy_payment = PharmacyPayment.find(:all,:conditions => "payment_no = '#{params[:t]}' ")
	render :partial => "search_ph_pay_records"
  end

  # GET /pharmacy_payments/1
  # GET /pharmacy_payments/1.xml
  def show
    @user_id = params[:user_id]
   	@org=Person.find_by_id(@user_id)
	@pharmacy_payment = PharmacyPayment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pharmacy_payment }
    end
  end

    def print
	@pharmacy_payment = PharmacyPayment.find(params[:id])
	    render :layout=>false
  end

  # GET /pharmacy_payments/new
  # GET /pharmacy_payments/new.xml
  def new
    @pharmacy_payment = PharmacyPayment.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	#Get the org_code and org_location in people table based on user id.

	10.times{ @pharmacy_payment.pharmacy_payment_children.build }
	str=""
	@pp=PharmacyPayment.last(:select=>"DISTINCT payment_no",:conditions=>"org_code ='#{@org_code}'")
    if(@pp)
       n=(@pp.payment_no.slice!(2..50).to_i+1).to_s
	   str="PP000000"+n
	else
        n=1.to_s
		str="PP000000"+n
	end
	@pharmacy_payment.payment_no=str
	@goods=Goodsrecieptnotemaster.find(:all, :conditions=>"org_code='#{@org_code}'",:select=>"DISTINCT agency_name" )
	@vendor_names=Array.new
	i=0
	for goods in @goods
		vendormaster=AgencyMaster.find_by_agency_name(goods.agency_name)
		@vendor_names[i]=vendormaster.agency_name
		i+=1
	end
	respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pharmacy_payment }
    end
  end


  def agency_payment
	#Get the org_code and org_location in people table based on user id.
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location

  end

  # GET /pharmacy_payments/1/edit
  def edit
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org = Person.find(@session.person_id)
@org_code=@person.org_code
    @pharmacy_payment = PharmacyPayment.find(params[:id])
@goods=Goodsrecieptnotemaster.find(:all, :conditions=>"org_code='#{@org_code}'",:select=>"DISTINCT agency_name" )
	@vendor_names=Array.new
	i=0
	for goods in @goods
		vendormaster=AgencyMaster.find_by_agency_name(goods.agency_name)
		@vendor_names[i]=vendormaster.agency_name
		i+=1
	end
  end

  # POST /pharmacy_payments
  # POST /pharmacy_payments.xml
  def create
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @pharmacy_payment = PharmacyPayment.new(params[:pharmacy_payment])
 @goods=Goodsrecieptnotemaster.find(:all, :conditions=>"org_code='#{@pharmacy_payment.org_code}'",:select=>"DISTINCT agency_name" )
   
	@vendor_names=Array.new
	i=0
	for goods in @goods
		vendormaster=AgencyMaster.find_by_agency_name(goods.agency_name)
		if(vendormaster)
			@vendor_names[i]=vendormaster.agency_name
			i+=1
		end
	end
	user_id=params[:user_id]
	str=""
	@pp=PharmacyPayment.last(:select=>"DISTINCT payment_no",:conditions=>"org_code ='#{@pharmacy_payment.org_code}'")
     if(@pp)
       n=(@pp.payment_no.slice!(2..50).to_i+1).to_s
	   str="PP000000"+n
	else
        n=1.to_s
		str="PP000000"+n
	end
	@pharmacy_payment.payment_no=str

	if(@pharmacy_payment.balance_amount==0)
		@pharmacy_payment.status="Closed"
	end
    respond_to do |format|
      if @pharmacy_payment.save
		for pharmacy_payment in @pharmacy_payment.pharmacy_payment_children
			@goodsrecipt_update=Goodsrecieptnotemaster.last(:conditions => " invoice_number LIKE '#{pharmacy_payment.invoice_no}%' and invoice_date LIKE '#{pharmacy_payment.invoice_date}%'")
			@goodsrecipt_update.net_invoice_amount=0
			@goodsrecipt_update.update_attributes(params[:goodsrecipt_update])
		end

        format.html { redirect_to("/reports/payment_thin_report/#{@pharmacy_payment.id}", :notice => 'PharmacyPayment was successfully created.') }
        format.xml  { render :xml => @pharmacy_payment, :status => :created, :location => @pharmacy_payment }
      else
		10.times{ @pharmacy_payment.pharmacy_payment_children.build }
        format.html { render :action => "new" }
        format.xml  { render :xml => @pharmacy_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pharmacy_payments/1
  # PUT /pharmacy_payments/1.xml
  def update
    @pharmacy_payment = PharmacyPayment.find(params[:id])

    respond_to do |format|
      if @pharmacy_payment.update_attributes(params[:pharmacy_payment])
        format.html { redirect_to("/pharmacy_payments/?user_id=#{params[:user_id]}", :notice => 'PharmacyPayment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pharmacy_payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pharmacy_payments/1
  # DELETE /pharmacy_payments/1.xml
  def destroy
    @pharmacy_payment = PharmacyPayment.find(params[:id])
    @pharmacy_payment.destroy

    respond_to do |format|
      format.html { redirect_to(pharmacy_payments_url) }
      format.xml  { head :ok }
    end
  end

  def ajax_search
 		vendor_code=params[:query]
		year=params[:year]
		mon=params[:month]
		if(mon.length==1)
			month="0"+params[:month]
		else
			month=params[:month]
		end
		net_amount=0
		vendor_master=AgencyMaster.find_by_agency_name(vendor_code)
		
		@goodsreceipt=Goodsrecieptnotemaster.sum(:net_invoice_amount, :conditions =>"agency_name ='#{vendor_master.agency_name}' and invoice_date Like '#{year}-#{month}-%'")
		str=""
		if(@goodsreceipt>0)

				@goodsrecipt_records=Goodsrecieptnotemaster.find(:all, :conditions =>"agency_name ='#{vendor_master.agency_name}' and invoice_date Like '#{year}-#{month}-%' and net_invoice_amount >0")

			
			for goodsrecipt_records in @goodsrecipt_records

				str<<goodsrecipt_records.invoice_number.to_s+"<sub_division>"+goodsrecipt_records.invoice_date.to_s+"<sub_division>"+goodsrecipt_records.net_invoice_amount.to_s+"<division>"
			end

			render :text =>str+"<goods>"+vendor_master.agency_name+"<goods>"+@goodsreceipt.to_s
		else
			render :text => "error"
		end
	end


def agency

 date1=params[:from_date]
 date2=params[:to_date]
 org_code=params[:org_code]
 status=params[:status]
 agency_name=params[:agency_name]
	if((org_code=="") && (status=="ALL"))
			if(date1!="" && date2!="" && agency_name!="")
			query=["payment_date BETWEEN ? AND ? AND agency_name= ?",date1,date2,agency_name]
			elsif(date1!="" && date2!="")
			query=["payment_date BETWEEN ? AND ?",date1,date2]
			end
				if(query)
				@payment=PharmacyPayment.new
				@payment.store_key(query)
				@payments=PharmacyPayment.find(:all, :conditions => query)
				render :partial =>"agency_payment_reporting"
				else
				render :text =>"No Records"
				end
	elsif((org_code!="") && (status!="ALL"))

			if(date1!="" && date2!="" && agency_name!="" && org_code!="" && status!="")
			query=["payment_date BETWEEN ? AND ? AND agency_name= ? AND org_code =? AND status=?",date1,date2,agency_name,org_code,status]

			elsif(date1!="" && date2!="" && org_code!="" && status!="")
			query=["payment_date BETWEEN ? AND ? AND org_code =? AND status=?",date1,date2,org_code,status]

			end
				if(query)
				@payment=PharmacyPayment.new
				@payment.store_key(query)
				@payments=PharmacyPayment.find(:all, :conditions => query)
				render :partial =>"agency_payment_reporting"
				else
				render :text =>"No Records"
				end

	elsif((org_code!="") && (status=="ALL"))

			if(date1!="" && date2!="" && agency_name!="" && org_code!="")
			query=["payment_date BETWEEN ? AND ? AND agency_name= ? AND org_code =?",date1,date2,agency_name,org_code]
			elsif(date1!="" && date2!="" && org_code!="")
			query=["payment_date BETWEEN ? AND ? AND org_code =?",date1,date2,org_code]
			end
				if(query)
				@payment=PharmacyPayment.new
				@payment.store_key(query)
				@payments=PharmacyPayment.find(:all, :conditions => query)
				render :partial =>"agency_payment_reporting"
				else
				render :text =>"No Records"
				end
	elsif((org_code=="") && (status!="ALL"))
			if(date1!="" && date2!="" && agency_name!="" && status!="")
			query=["payment_date BETWEEN ? AND ? AND agency_name= ? AND status =?",date1,date2,agency_name,status]

			elsif(date1!="" && date2!="" && status!="")
			query=["payment_date BETWEEN ? AND ? AND status =?",date1,date2,status]
			end
				if(query)
				@payment=PharmacyPayment.new
				@payment.store_key(query)
				@payments=PharmacyPayment.find(:all, :conditions => query)
				render :partial =>"agency_payment_reporting"
				else
				render :text =>"No Records"
				end
		end
end

def export_to_csv
@pharmacy=PharmacyPayment.find(:all)
	report = StringIO.new
	CSV::Writer.generate(report, ',') do |title|
			title << ['Table Name','Payment No','Payment date','Agency Name','Invoice Total','Paid Amount','Status','Invoice Date']
			@pharmacy.each do |c|
			title << ['Agency Payments',c.payment_no,c.payment_date,c.agency_name,c.invoice_total,c.paid_amount,c.status,c.invoice_date]
			end
		end
		report.rewind
		send_data(report.read,:type=>'text/csv;charset=iso-8859-1;header=present',:filename=>"goods.csv",:disposition =>'attachment', :encoding => 'utf8')
end
	def generate_reports

	@issues=PharmacyPayment.new
	 @data=@issues.return_key
	pdf = PharmacyPaymentReport.render_csv(:mrno => @data)
	send_data pdf, :type => "text/csv",
    :filename => "PharmacyPaymentReporting.csv"
  end

  def bill_info
	vendor_code=params[:vendor_code]
	year=params[:year]
	if(params[:month].length==1)
		month="0"+params[:month]
	else
		month=params[:month]
	end
	vendor_master=Vendormaster.find_by_vendor_name(vendor_code)
	@goodsrecipt=Goodsrecieptnotemaster.find(:all, :conditions =>"vendor_code ='#{vendor_master.vendor_code}' and grn_date Like '#{year}-#{month}-%'")
	render :partial => "bill_info_search"
 end

 def observe_field_ex

	@pharmacy_payment = PharmacyPayment.find(:all,:conditions=>"payment_no LIKE '%#{params[:payment_no]}' AND agency_name LIKE '#{params[:agency_name]}%' AND net_amount LIKE '#{params[:balance_amount]}%' ")
	if(@pharmacy_payment[0])
		   render:partial=>"search_ph_pay_records"
	else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
	end

  end

def get_supplier_address
		customer_supplier=AgencyMaster.last(:conditions => "agency_name LIKE '#{params[:customer_code]}%'")
		purchase_invoices=Goodsrecieptnotemaster.find(:all, :conditions => "agency_name='#{params[:customer_code]}' and type_pay = 'Credit'")

		str=""
		total=0	
		for purchase_invoice in purchase_invoices

		discount_amount=0
		if(purchase_invoice.discount)

		discount_amount=(purchase_invoice.sub_total*purchase_invoice.discount)/100
		end
		str << purchase_invoice.invoice_number+"<sub_division>"+purchase_invoice.invoice_date.to_s+"<sub_division>"+discount_amount.to_s+"<sub_division>"+purchase_invoice.due.to_s+"<division_sub>"
		total=total+purchase_invoice.due
		end

if(customer_supplier)
		render :text => customer_supplier.address.to_s+"<division>"+customer_supplier.city.to_s+"<division>"+total.to_s+"<division>"+str
else
	render :text => ""+"<division>"+""+"<division>"+total.to_s+"<division>"+str
end

  end



end
