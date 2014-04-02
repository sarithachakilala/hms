class PurchaseOrderReturnsController < ApplicationController
  # GET /purchase_order_returns
  # GET /purchase_order_returns.xml
  def index
  @session_id=session[:id]
	@session = Session.find(session[:id])
    @person = Person.find(@session.person_id)
	@purchase_order_returns = PurchaseOrderReturn.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@person.org_code}'"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @purchase_order_return }
    end
  end

  
  
  
  def search
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@purchase_order_return = PurchaseOrderReturn.find(:all,:conditions => "return_no = '#{params[:t]}' and org_code = '#{@org.org_code}'")
	
	render :partial => "seach_purchase"
  end
  
  # GET /purchase_order_returns/1
  # GET /purchase_order_returns/1.xml
  def show
     @session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@purchase_order_return = PurchaseOrderReturn.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @purchase_order_return }
    end
  end

  
    def print
	@purchase_order_return = PurchaseOrderReturn.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @purchase_order_return }
    end
  end
  # GET /purchase_order_returns/new
  # GET /purchase_order_returns/new.xml
  def new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
   @purchase_order_return = PurchaseOrderReturn.new
	#Get the org_code and org_location in people table based on user id.
	@item_master=Itemmaster.find(:all, :conditions => "org_code = '#{@person.org_code}'", :select => "DISTINCT product_name")
	15.times{ @purchase_order_return.purchase_order_return_children.build }
	@por=PurchaseOrderReturn.last(:select=>"DISTINCT return_no",:conditions=>"org_code ='#{@org_code}'")
       	if(@por)
       n=(@por.return_no.slice!(2..50).to_i+1).to_s
       	str="PR000000"+n
	else
	    n=1.to_s
		str="PR000000"+n
	end
		@purchase_order_return.return_no=str
	

		
	respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @purchase_order_return }
    end
  end

  # GET /purchase_order_returns/1/edit
  def edit
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@people= Person.find(@session.person_id)
    @purchase_order_return = PurchaseOrderReturn.find(params[:id])
	@item_master=Itemmaster.find(:all, :conditions => "org_code = '#{@people.org_code}'", :select => "DISTINCT product_name")

  end

  # POST /purchase_order_returns
  # POST /purchase_order_returns.xml
  def create
@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
  	@item_master=Itemmaster.find(:all, :conditions => "org_code = '#{@person.org_code}'", :select => "DISTINCT product_name")
    @purchase_order_return = PurchaseOrderReturn.new(params[:purchase_order_return])
   	@por=PurchaseOrderReturn.last(:select=>"DISTINCT return_no",:conditions=>"org_code ='#{@purchase_order_return.org_code}'")
     
   	if(@por)
       n=(@por.return_no.slice!(2..50).to_i+1).to_s
       	str="PR000000"+n
	else
	    n=1.to_s
		str="PR000000"+n
	end
	@purchase_order_return.return_no=str
	for store1 in @purchase_order_return.purchase_order_return_children
		@store_child1=StoreChild.find_by_item_name_and_batch_no(store1.item_name,store1.batch_no)
		@store_child1.quantity=@store_child1.quantity.to_i - store1.return_qty.to_i
		@store_child1.purchase_return_quantity=@store_child1.purchase_return_quantity.to_i + store1.return_qty.to_i
		@store_child1.update_attributes(params[:store_child1])
	end 	
		
		
	respond_to do |format|
      if @purchase_order_return.save
          format.html { redirect_to("/purchase_order_returns/new", :notice => 'purchase_order_return was successfully created.') }
		  format.xml  { render :xml => @purchase_order_return, :status => :created, :location => @purchase_order_return }
      else
15.times{ @purchase_order_return.purchase_order_return_children.build } 
	      format.html { render :action => "new" }
          format.xml  { render :xml => @purchase_order_return.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /purchase_order_returns/1
  # PUT /purchase_order_returns/1.xml
  def update
    @purchase_order_return = PurchaseOrderReturn.find(params[:id])

    respond_to do |format|
      if @purchase_order_return.update_attributes(params[:purchase_order_return])
        format.html { redirect_to("/purchase_order_returns/?user_id=#{params[:user_id]}", :notice => 'PurchaseOrderReturn was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchase_order_return.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_order_returns/1
  # DELETE /purchase_order_returns/1.xml
  def destroy
    @purchase_order_return = PurchaseOrderReturn.find(params[:id])
    @purchase_order_return.destroy

    respond_to do |format|
      format.html { redirect_to(purchase_order_returns_url) }
      format.xml  { head :ok }
    end
  end
  	def date_select	 
		mr=params[:q]
		type1=params[:res]
		poid=params[:po_no]
		org_code=params[:org_code]
		vend=params[:vend]
		str=""
		@vend_name=AgencyMaster.find_by_org_code_and_agency_name(org_code,vend)
		if(type1=="service")
			@parent_store=mr.split("-")
			@test = StoreChild.find_by_batch_no_and_item_name_and_org_code(@parent_store[1],@parent_store[0],org_code)
			render :text => @test.item_code+","+@test.batch_no+","+@test.expiry_date.to_s+","+@test.quantity.to_s+","+@test.purchase_rate.to_s
		elsif(type1=="dates")
			@items=Goodsrecieptnotemaster.find(:all,:conditions =>"org_code='#{org_code}' and agency_name='#{@vend_name.agency_name}'")

			for item in @items

				if(mr=="15 Days")
					@new_items = StoreChild.find(:all, :conditions=>"goodsrecieptnotemaster_id='#{item.id}' and quantity>0 and expiry_date<'#{Date.today+15}'")
				elsif(mr=="1 Month")
					@new_items = StoreChild.find(:all, :conditions=>"goodsrecieptnotemaster_id='#{item.id}' and quantity>0 and expiry_date<'#{Date.today>>1}'")
				elsif(mr=="3 Months")
					@new_items = StoreChild.find(:all, :conditions=>"goodsrecieptnotemaster_id='#{item.id}' and quantity>0 and expiry_date<'#{Date.today>>3}'")
				elsif(mr=="6 Months")
					@new_items = StoreChild.find(:all, :conditions=>"goodsrecieptnotemaster_id='#{item.id}' and quantity>0 and expiry_date<'#{Date.today>>6}'")
				end
				for new_item in @new_items
					str<< new_item.item_name+","+new_item.batch_no+","+new_item.expiry_date.to_s+","+(new_item.quantity.to_i).to_s+","+new_item.purchase_rate.to_s+","+(new_item.quantity.to_i).to_s+","+new_item.purchase_rate.to_s+","+(new_item.quantity.to_i*new_item.purchase_rate.to_f).to_s+"<division>"
				end

		    end
					render :text => str
		end
	end
 
  def select_org_code
	transfer_data=TransferData.new
	render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
  end	
  
  def observe_field_ex
	@purchase_order_return = PurchaseOrderReturn.find(:all,:conditions=>"return_no LIKE '%#{params[:return_no]}' AND return_date LIKE '#{params[:return_date]}%' AND agency_names LIKE '#{params[:vendor]}%'")
	if(@purchase_order_return[0])
		   render:partial=>"seach_purchase"
	else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
	end
  end   
end
