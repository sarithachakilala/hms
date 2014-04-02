class GoodsrecieptnotemastersController < ApplicationController
  # GET /goodsrecieptnotemasters
  # GET /goodsrecieptnotemasters.xml
  require 'csv'
  def index
  	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@goodsrecieptnotemaster = Goodsrecieptnotemaster.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@person.org_code}'"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @goodsrecieptnotemaster }
    end
  end
  
  
  def search1
	@user_id=params[:user_id]
	@org=Person.find_by_id(@user_id)
	@goodsrecieptnotemaster = Goodsrecieptnotemaster.find(:all,:conditions => "grn_number = '#{params[:t]}' and org_code = '#{@org.org_code}'")
	
	render :partial => "search_grn"
  end
  

  # GET /goodsrecieptnotemasters/1
  # GET /goodsrecieptnotemasters/1.xml
  def show
  
	@user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
	
	
	@goodsrecieptnotemaster = Goodsrecieptnotemaster.find(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @goodsrecieptnotemaster }
    end
  end

  # GET /goodsrecieptnotemasters/new
  # GET /goodsrecieptnotemasters/new.xml
  def goodsrecieptnotemaster_report
  
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code

	
  end
  
  def goodreceptionist_report
  
	#Get the org_code and org_location in people table based on user id.
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
 @date1=Date.today("%Y-%m-%d")
	
  end
  
  def new
    @goodsrecieptnotemaster = Goodsrecieptnotemaster.new
	@goodsrecieptnotemaster.entry_no= @goodsrecieptnotemaster.find_mr_no()
	#Get the org_code and org_location in people table based on user id.
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	$user_id=@person.id
	@org_code=@person.org_code
	@org_location=@person.org_location
	20.times{ @goodsrecieptnotemaster.store_child.build }
	@item_masters=Itemmaster.find(:all, :select => "DISTINCT product_name")
	@item_names_store_arry=""
	
	for item_master in @item_masters
		@store_children = StoreChild.sum(:quantity,:conditions => "item_name = '#{item_master.product_name}'")
		@item_names_store_arry<< item_master.product_name+" --> "+@store_children.to_s+","
	end
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @goodsrecieptnotemaster }
    end
  end

  # GET /goodsrecieptnotemasters/1/edit
  def edit
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	$user_id=@person.id
	@org=@person.org_code
	@org_location=@person.org_location
	@user_id = params[:user_id]
	@form_name=params[:form_name]
	$form_name=params[:form_name]

	@goodsrecieptnotemaster = Goodsrecieptnotemaster.find(params[:id])
	20.times{ @goodsrecieptnotemaster.store_child.build }

	@item_masters=Itemmaster.find(:all, :select => "DISTINCT product_name")
	@item_names_store_arry=""
	
	for item_master in @item_masters
		@store_children = StoreChild.sum(:quantity,:conditions => "item_name = '#{item_master.product_name}'")
		@item_names_store_arry<< item_master.product_name+" --> "+@store_children.to_s+","
	end
  end

  def enquiry
  
	#Get the org_code and org_location in people table based on user id.
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	$user_id=@person.id
	@org_code=@person.org_code
	@org_location=@person.org_location
	@item_master=StoreChild.find(:all, :select => "DISTINCT item_name")
  
  end
  
  # POST /goodsrecieptnotemasters
  # POST /goodsrecieptnotemasters.xml
  def create
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	
    	@goodsrecieptnotemaster = Goodsrecieptnotemaster.new(params[:goodsrecieptnotemaster])
	user_id=params[:user_id]
	@item_masters=Itemmaster.find(:all, :select => "DISTINCT product_name")
	@item_names_store_arry=""
	
	for item_master in @item_masters
		@store_children = StoreChild.sum(:quantity,:conditions => "item_name = '#{item_master.product_name}'")
		@item_names_store_arry<< item_master.product_name+" --> "+@store_children.to_s+","
	end
	
		@goodsrecieptnotemaster.due=@goodsrecieptnotemaster.net_amount
			@goodsrecieptnotemaster.paid_amount=0
	respond_to do |format|
		@goodsrecieptnotemaster.stock_transfer_status="Completed"
      		if @goodsrecieptnotemaster.save 
			
			
			format.html { redirect_to("/goodsrecieptnotemasters/new?user_id=#{user_id}", :notice => 'Goodsrecieptnotemaster was successfully created.') }
        		format.xml  { render :xml => @goodsrecieptnotemaster, :status => :created, :location => @goodsrecieptnotemaster }
      		else
			20.times{ @goodsrecieptnotemaster.store_child.build }
 	       		format.html { render :action => "new" }
        		format.xml  { render :xml => @goodsrecieptnotemaster.errors, :status => :unprocessable_entity }
      		end
    	end
  end

  def print
  	@goodsrecieptnotemaster = Goodsrecieptnotemaster.find(params[:id])
	respond_to do |format|
      		format.html # show.html.erb
      		format.xml  { render :xml => @goodsrecieptnotemaster }
    	end
  end
  
  
  # PUT /goodsrecieptnotemasters/1
  # PUT /goodsrecieptnotemasters/1.xml
  def update
    	@goodsrecieptnotemaster = Goodsrecieptnotemaster.find(params[:id])
	
    	respond_to do |format|
      		if @goodsrecieptnotemaster.update_attributes(params[:goodsrecieptnotemaster])
	  		if($form_name=="enquiry")
        			format.html { redirect_to("/goodsrecieptnotemasters/enquiry/1?user_id=#{params[:user_id]}", :notice => 'Goodsrecieptnotemaster was successfully updated.') }
	  		else
	  			format.html { redirect_to("/goodsrecieptnotemasters/?user_id=#{params[:user_id]}", :notice => 'Goodsrecieptnotemaster was successfully updated.') }
      			end
	  		format.xml  { head :ok }
      		else
		        format.html { render :action => "edit" }
		        format.xml  { render :xml => @goodsrecieptnotemaster.errors, :status => :unprocessable_entity }
	      	end
    	end
  end

  # DELETE /goodsrecieptnotemasters/1
  # DELETE /goodsrecieptnotemasters/1.xml
  def destroy
    @goodsrecieptnotemaster = Goodsrecieptnotemaster.find(params[:id])
    @goodsrecieptnotemaster.destroy

    respond_to do |format|
      format.html { redirect_to(goodsrecieptnotemasters_url) }
      format.xml  { head :ok }
    end
  end
 
  
  def goodsrecieptnotemaster_reporting
		org_code=params[:org_code]
		@d1=params[:date_value]
		@d2=params[:date_value1]
	
   			@store_child = StoreChild.find(:all, :conditions=>"expiry_date BETWEEN '#{params[:date_value]}' and '#{params[:date_value1]}'")
	if(@store_child[0])
				render :partial => "goodsrecieptnotemaster_reporting"
	else
	
		render :text => "NO RECORDS FOUND" 
	end
				
		
	end

def goodreceptionmaster

	org_code=params[:org_code]
	vendorcode=params[:vendorcode]
	appt_date1=params[:appt_date1]
	appt_date2=params[:appt_date2]
	@goodsrecieptnotemaster1=Goodsrecieptnotemaster.new

	if(org_code!="")
		if(appt_date1!="" && appt_date2!="" && vendorcode!="")
		@goods=Goodsrecieptnotemaster.find(:all,:conditions => "(invoice_date BETWEEN '#{params[:appt_date1]}' and '#{params[:appt_date2]}') and agency_name LIKE '#{params[:vendorcode]}%'")
		else
		@goods=Goodsrecieptnotemaster.find(:all,:conditions => "(invoice_date BETWEEN '#{params[:appt_date1]}' and '#{params[:appt_date2]}')")
		end
	end

	if(@goods[0])
		    render :partial=>"goodreceptionist"

		else	
		   render :text =>"No Records"
		end
end	
def export_to_csv

@goods_receipts=StoreChild.find(:all)
	report = StringIO.new
	CSV::Writer.generate(report, ',') do |title|
			title << ['Table Name','Item Name','Drug Type','Batch No','Expira Date','Quantity','Purchase Rate','MRP','Amount','Vat']
			@goods_receipts.each do |c|
			title << ['Goods Child',c.item_name,c.drug_type,c.batch_no,c.expiry_date,c.quantity,c.purchase_rate	,c.mrp,c.amount	,c.vat	]
			end
		end
		report.rewind
		send_data(report.read,:type=>'text/csv;charset=iso-8859-1;header=present',:filename=>"goods.csv",:disposition =>'attachment', :encoding => 'utf8')
	end
  def ajax
  agency=params[:agency]
  @agency_details=AgencyMaster.find_by_agency_name(agency)
  
  render :js =>"
		document.getElementById('address').value='#{@agency_details.address}';
		document.getElementById('address').style.background='#FEF5CA';
		"
 end


def ajax_select
  agency=params[:agency]
  @agency_details=AgencyMaster.find_by_agency_name(agency)
  
  render :js =>"
		document.getElementById('address').value='#{@agency_details.address}';
		document.getElementById('address').style.background='#FEF5CA';
		document.getElementById('city').value='#{@agency_details.city}';
		document.getElementById('city').style.background='#FEF5CA';
		document.getElementById('phone_no').value='#{@agency_details.contact_no }';
		document.getElementById('phone_no').style.background='#FEF5CA';		
		"
 end

 def ajax1
	item=params[:query2]
 	@item=Itemmaster.find_by_product_name(item.split(" --> ")[0])
		str=""
			if(@item)
				@storechild=StoreChild.last(:conditions=>"item_name='#{@item.product_name}'")
				if(@storechild)
					mrp=@storechild.mrp.to_s
					rate=@storechild.purchase_rate.to_s
					qty=@storechild.requisation_qty
				else
					mrp=""
					rate=""
					sale_rate=""
				end
				str<<@item.product_name.to_s+"<code>"+@item.drug_type.to_s+"<code>"+@item.packing.to_s+"<code>"+@item.vat.to_s+","
				render :text => str
			else
				render :text => "Invalid item"
			end
 end 

 
   
  def find_medicine
	medicine_name=params[:medicine_name]
	org_code=params[:org_code]
		if(org_code!="" && medicine_name!="")
			query1=["item_name Like ? ",medicine_name+"%"]
		end
		if(query1)
			@ip_child=StoreChild.find(:all, :conditions=> query1)
			render :partial => "enquiry_search1"
		else
			render :text => "No Data"
		end
	end
  
	
	def generate_reports
	
	 g= StoreChild.report_table(:all,  :only => %w[item_name item_code quantity expiry_date])
	  send_data g.to_csv,
      :type         => "application/csv",
      :disposition  => "inline",
      :filename     => "report.csv" 
  end
def select_org_code
	org_code=params[:org_code]
	str=""
	if(org_code)
	@order=Goodsrecieptnotemaster.find(:all, :conditions => "org_code='#{org_code}'")
		for i in 0...@order.length
		str<<@order[i].vendor_code+"<code>"
		end
		render :text=>str
	end
  end
  
  def expiry_date_medicine_report
		@d1=Date.today
		@d2=Date.today>>3
		puts @d2
		@store_child=StoreChild.find(:all, :conditions => "expiry_date BETWEEN '#{@d1}' AND '#{@d2}'")
  
  end
  
  def less_medicine_lists

	@itemmaster=Itemmaster.all(:select =>"DISTINCT drug_type")


  end
  
  
  def vat_purchase
	mon=params[:month]
	date=Date.today.strftime("%d-%b-%Y").split("-")
	if(!mon || mon=="")
		mon=date[1]
	end
	month={"Jan" => "01","Feb" => "02","Mar" => "03","Apr" => "04","May" => "05","Jun" => "06","Jul" => "07","Aug" => "08","Sep" => "09","Oct" =>"10","Nov" =>"11","Dec" =>"12"}
	@goodsrecieptnotemaster = Goodsrecieptnotemaster.find(:all, :conditions => " invoice_date LIKE '#{params[:year]}-#{month[mon]}-%'")
	render :partial => "purchase_vat"
  end
  
   def observe_field_ex

	@goodsrecieptnotemaster = Goodsrecieptnotemaster.find(:all,:conditions=>"invoice_number LIKE '#{params[:grn_number]}%' AND agency_name LIKE '#{params[:vendor_code]}%' ")
	if( @goodsrecieptnotemaster[0])
		   render:partial=>"search_grn"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
	end  

  end

#report by saritha..
 def agency_enquiry

  @goodsreceipt=Goodsrecieptnotemaster.find(:all, :conditions=>"agency_name Like '#{params[:agency_name]}'")

  if(@goodsreceipt)
   render :partial => "agency_search1" 
  
  end
 end

 def agency_search1
  
 #Get the org_code and org_location in people table based on user id.
@session_id=session[:id]
@session = Session.find(session[:id])
@person = Person.find(@session.person_id)
@org_code=@person.org_code
@org_location=@person.org_location
 @people=Person.find_by_id(params[:user_id])

  end

 def product_info
		@purchase_invoice_children = StoreChild.all(:conditions => "item_name LIKE '#{params[:product_name]}%'")
  end

end

