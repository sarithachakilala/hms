class TestCancelsController < ApplicationController
  # GET /test_cancels
  # GET /test_cancels.xml
  def index
    @test_cancels = TestCancel.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @test_cancels }
    end
  end

  # GET /test_cancels/1
  # GET /test_cancels/1.xml
  def show
    @test_cancel = TestCancel.all
	
	
    respond_to do |format|
      format.html {render :layout => false}
      format.xml  { render :xml => @test_cancel }
    end
  end

  # GET /test_cancels/new
  # GET /test_cancels/new.xml
  def new
    @test_cancel = TestCancel.new
	
	@test_booking_child = TestBookingChild.find(params[:record_id])
	@test_booking = TestBooking.find(@test_booking_child.test_booking_id)
	@test_cancel.lab_id=@test_booking.lab_no
	@test_cancel.department_name=@test_booking_child.department
	@test_cancel.service_name=@test_booking_child.test_name
	@test_cancel.org_code=@test_booking.org_code
	@test_cancel.org_location=@test_booking.org_location
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @test_cancel }
    end
  end

  # GET /test_cancels/1/edit
  def edit
    @test_cancel = TestCancel.find(params[:id])
  end

  # POST /test_cancels
  # POST /test_cancels.xml
  def create
    @test_cancel = TestCancel.new(params[:test_cancel])

	test_booking = TestBooking.find_by_id(params[:test_booking_id])
	
	@test_booking_child=TestBookingChild.find_by_id(params[:record_id])
	test_booking.grand_total=test_booking.grand_total-@test_booking_child.rate
	
    respond_to do |format|
      if @test_cancel.save
		@test_booking_child.destroy
		test_booking.update_attributes(params[:test_booking])
	    format.html { redirect_to(@test_cancel, :notice => 'TestCancel was successfully created.') }
        format.xml  { render :xml => @test_cancel, :status => :created, :location => @test_cancel }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @test_cancel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /test_cancels/1
  # PUT /test_cancels/1.xml
  def update
    @test_cancel = TestCancel.find(params[:id])

    respond_to do |format|
      if @test_cancel.update_attributes(params[:test_cancel])
        format.html { redirect_to(@test_cancel, :notice => 'TestCancel was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @test_cancel.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /test_cancels/1
  # DELETE /test_cancels/1.xml
  def destroy
    @test_cancel = TestCancel.find(params[:id])
    @test_cancel.destroy

    respond_to do |format|
      format.html { redirect_to(test_cancels_url) }
      format.xml  { head :ok }
    end
  end
  
  def search
	
	@user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
  
  end

  def search_radiology
	
	@user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
  
  end

  def search_results
	from_date=params[:from_date]
	to_date=params[:to_date]
	lab_id=params[:lab_id]
	mr_no=params[:mr_no]
	first_name=params[:first_name]
	@form_name=params[:form_name]
	if(from_date!="" && to_date!="")
		@test_bookings = TestBooking.find(:all, :conditions => "
			(receipt_date BETWEEN '#{from_date}' AND '#{to_date}') AND
			first_name LIKE '#{first_name}%' AND
			mr_no  LIKE '#{mr_no}%' AND
			lab_no  LIKE '#{lab_id}%'")
	else
		@test_bookings = TestBooking.find(:all, :conditions => "
			first_nam LIKE '#{first_nam}%' AND
			mr_no  LIKE '#{mr_no}%' AND
			lab_no  LIKE '#{lab_id}%'")
	end
  end
end
