class StoreTestResultsController < ApplicationController
  # GET /store_test_results
  # GET /store_test_results.xml
  def index
    @store_test_results = StoreTestResult.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @store_test_results }
    end
  end

  # GET /store_test_results/1
  # GET /store_test_results/1.xml
  def show
    @store_test_result = StoreTestResult.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @store_test_result }
    end
  end

  # GET /store_test_results/new
  # GET /store_test_results/new.xml
   def new
    @store_test_result = StoreTestResult.new
	
	@main_service=params[:test_name]
	test_booking=TestBooking.find_by_lab_no_and_org_code(params[:lab_id],params[:org_code])
	@store_test_result.lab_no=params[:lab_id]
	@store_test_result.test_booking_id=test_booking.id
	@store_test_result.patient_type=test_booking.patient_type
	@store_test_result.mr_no=test_booking.mr_no
	@store_test_result.admn_no=test_booking.admn_no 
	@store_test_result.org_code=test_booking.org_code
	@store_test_result.org_location=test_booking.org_location
	@store_test_result.admn_no=""
	@store_test_result.service_name=@main_service
	if(params[:bill_type]=="IP")
		admission=Admission.find_by_mr_no_and_org_code(test_booking.mr_no,params[:org_code])
		@store_test_result.admn_no=admission.admn_no
	end
	i=0
	testmaster=Testmaster.find_by_test_name_and_org_code(@main_service,params[:org_code])
	@testmaster_child=TestmasterChild.find(:all, :conditions => "testmaster_id = '#{testmaster.id}'")
	@testmaster_child.length.times{ 
		store=@store_test_result.store_test_result_children.build
		store.servce_name=@main_service
		store.test_name=@testmaster_child[i].paramaters
		store.lbound=@testmaster_child[i].normal_range
		store.units=@testmaster_child[i].unit
		i=i+1
	}
	@field=Array.new
	@field_names=Array.new
	@total_fields=0
   	for i in 0...@testmaster_child.length
        	@field[i]=@testmaster_child[i].field_type
		@field_names[i]=@testmaster_child[i].paramaters
		if(@testmaster_child[i].field_type=="Content")
			@total_fields=@total_fields+1
		end
	end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @store_test_result }
    end
  end

  # GET /store_test_results/1/edit
  def edit
    @store_test_result = StoreTestResult.find(params[:id])
	org = @store_test_result.org_code
	name= @store_test_result.service_name
	i=0
	testmaster=Testmaster.find_by_test_name_and_org_code(name,org)
	@testmaster_child=TestmasterChild.find(:all, :conditions => "testmaster_id = '#{testmaster.id}'")
	@testmaster_child.length.times{ 
		store=@store_test_result.store_test_result_children.build
		store.servce_name=@main_service
		store.test_name=@testmaster_child[i].paramaters
		store.lbound=@testmaster_child[i].normal_range
		store.units=@testmaster_child[i].unit
		i=i+1
	}
	@field=Array.new
    for i in 0...@testmaster_child.length
        @field[i]=@testmaster_child[i].field_type
	end
	
  end

  # POST /store_test_results
  # POST /store_test_results.xml
  def create
    @store_test_result = StoreTestResult.new(params[:store_test_result])

    respond_to do |format|
      if @store_test_result.save
        format.html { redirect_to(@store_test_result, :notice => 'StoreTestResult was successfully created.') }
        format.xml  { render :xml => @store_test_result, :status => :created, :location => @store_test_result }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @store_test_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /store_test_results/1
  # PUT /store_test_results/1.xml
  def update
    @store_test_result = StoreTestResult.find(params[:id])

    respond_to do |format|
      if @store_test_result.update_attributes(params[:store_test_result])
        format.html { redirect_to(@store_test_result, :notice => 'StoreTestResult was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @store_test_result.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /store_test_results/1
  # DELETE /store_test_results/1.xml
  def destroy
    @store_test_result = StoreTestResult.find(params[:id])
    @store_test_result.destroy

    respond_to do |format|
      format.html { redirect_to(store_test_results_url) }
      format.xml  { head :ok }
    end
  end
  
  def search
	
	@user_id = params[:user_id]
	@people=Person.find_by_id(@user_id)
  	
	if(@people.code_option=="0")
		@org_code=@people.org_code
		@org_location=@people.org_location
	else
		transfer_data=TransferData.new
		@org_code=transfer_data.get_org_codes(@people.port_number)
	end 
  end
  
  def search_results
	from_date=params[:from_date]
	to_date=params[:to_date]
	@lab_id=params[:lab_id]
	mr_no=params[:mr_no]
	first_name=params[:first_name]
	@department_name=params[:department_name]
	org_code=params[:org_code]
	if(@lab_id=="")
		if(from_date!="" && to_date!="")
			@test_bookings = TestBooking.find(:all, :conditions => "
				(receipt_date BETWEEN '#{from_date}' AND '#{to_date}') AND
				first_name LIKE '#{first_name}%' AND
				mr_no  LIKE '#{mr_no}%' AND
				org_code LIKE '#{org_code}'", :order => "id DESC")
		else
			@test_bookings = TestBooking.find(:all, :conditions => "
				first_name LIKE '#{first_name}%' AND
				mr_no  LIKE '#{mr_no}%' AND
				org_code LIKE '#{org_code}'", :order => "id DESC")
		end
	else
		@test_bookings = TestBooking.find(:all, :conditions => "lab_no  = '#{@lab_id}'", :order => "id DESC")
	end
	
  end

  def ajax_function
	@test_booking = TestBooking.find_by_org_code_and_lab_no(params[:org_code],params[:lab_id])
	testmaster=Testmaster.find_by_test_name(params[:test_name])
	if(testmaster)
		render :text => "sucess"
	else
		render :text => "test_error"
	end
  end
  
  
end
