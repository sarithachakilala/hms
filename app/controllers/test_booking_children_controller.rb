class TestBookingChildrenController < ApplicationController
  # GET /test_booking_children
  # GET /test_booking_children.xml
  def index
    @test_booking_children = TestBookingChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @test_booking_children }
    end
  end

  # GET /test_booking_children/1
  # GET /test_booking_children/1.xml
  def show
    @test_booking_child = TestBookingChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @test_booking_child }
    end
  end

  # GET /test_booking_children/new
  # GET /test_booking_children/new.xml
  def new
    @test_booking_child = TestBookingChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @test_booking_child }
    end
  end

  # GET /test_booking_children/1/edit
  def edit
    @test_booking_child = TestBookingChild.find(params[:id])
  end

  # POST /test_booking_children
  # POST /test_booking_children.xml
  def create
    @test_booking_child = TestBookingChild.new(params[:test_booking_child])

    respond_to do |format|
      if @test_booking_child.save
        format.html { redirect_to(@test_booking_child, :notice => 'TestBookingChild was successfully created.') }
        format.xml  { render :xml => @test_booking_child, :status => :created, :location => @test_booking_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @test_booking_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /test_booking_children/1
  # PUT /test_booking_children/1.xml
  def update
    @test_booking_child = TestBookingChild.find(params[:id])

    respond_to do |format|
      if @test_booking_child.update_attributes(params[:test_booking_child])
        format.html { redirect_to(@test_booking_child, :notice => 'TestBookingChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @test_booking_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /test_booking_children/1
  # DELETE /test_booking_children/1.xml
  def destroy
	@test_booking_child = TestBookingChild.find(params[:id])
    @test_booking_child.destroy
	@test_booking = TestBooking.find_by_id(@test_booking_child.test_booking_id)
	@test_booking.grand_total=@test_booking.grand_total.to_f-@test_booking_child.amount.to_f
	@test_booking.update_attributes(params[:test_booking])
	redirect_to("/test_bookings/search_results/1?from_date='#{params[:from_date]}'&to_date='#{params[:to_date]}'&lab_id='#{params[:lab_id]}'&mr_no='#{params[:mr_no]}'&first_name='#{params[:first_name]}'&org_code='#{params[:org_code]}'")
  end
end
