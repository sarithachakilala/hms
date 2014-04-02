class StoreTestResultChildrenController < ApplicationController
  # GET /store_test_result_children
  # GET /store_test_result_children.xml
	$test_perameters
  def index
    @store_test_result_children = StoreTestResultChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @store_test_result_children }
    end
  end

  # GET /store_test_result_children/1
  # GET /store_test_result_children/1.xml
  def show
    @store_test_result_child = StoreTestResultChild.find(:all, :conditions => "store_test_result_id=#{params[:id]} and servce_name='#{params[:test_name]}'")
	
	@store_test_result=StoreTestResult.find_by_id(@store_test_result_child[0].store_test_result_id)
    @registration=Registration.find_by_org_code_and_mr_no(@store_test_result.org_code,@store_test_result.mr_no)
	respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @store_test_result_child }
    end
  end

  # GET /store_test_result_children/new
  # GET /store_test_result_children/new.xml
  def new
    @store_test_result_child = StoreTestResultChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @store_test_result_child }
    end
  end

  # GET /store_test_result_children/1/edit
  def edit
    @store_test_result_child = StoreTestResultChild.find(params[:id])
  end

  # POST /store_test_result_children
  # POST /store_test_result_children.xml
  def create
    @store_test_result_child = StoreTestResultChild.new(params[:store_test_result_child])

    respond_to do |format|
      if @store_test_result_child.save
        format.html { redirect_to(@store_test_result_child, :notice => 'StoreTestResultChild was successfully created.') }
        format.xml  { render :xml => @store_test_result_child, :status => :created, :location => @store_test_result_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @store_test_result_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /store_test_result_children/1
  # PUT /store_test_result_children/1.xml
  def update
    @store_test_result_child = StoreTestResultChild.find(params[:id])

    respond_to do |format|
      if @store_test_result_child.update_attributes(params[:store_test_result_child])
        format.html { redirect_to(@store_test_result_child, :notice => 'StoreTestResultChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @store_test_result_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /store_test_result_children/1
  # DELETE /store_test_result_children/1.xml
  def destroy
    @store_test_result_child = StoreTestResultChild.find(params[:id])
    @store_test_result_child.destroy

    respond_to do |format|
      format.html { redirect_to(store_test_result_children_url) }
      format.xml  { head :ok }
    end
  end
  
   def report

	@store_test_result_child = StoreTestResultChild.find(:all, :conditions => "store_test_result_id=#{params[:id]} and servce_name='#{params[:test_name]}'")
	@store_test_result=StoreTestResult.find_by_id(@store_test_result_child[0].store_test_result_id)
    @testbooking=TestBooking.find_by_lab_no(@store_test_result.lab_no)  
    @registration=Registration.find_by_org_code_and_mr_no(@store_test_result.org_code,@store_test_result.mr_no)
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 20,
      :right_margin => 20,
      :top_margin => 30,
      :bottom_margin => 30},
      :filename => "#{@registration.patient_name}.pdf"

    render :layout => false
	
  end
  
  def print_selection
	@lab_no=params[:lab_no]
	test_booking = TestBooking.find_by_lab_no(params[:lab_no])
	@test_booking_children=TestBookingChild.find(:all, :conditions => "test_booking_id = #{test_booking.id}")
	@total_tests=0
	for test_booking_children in @test_booking_children
		store_test_result = StoreTestResult.find_by_lab_no_and_service_name(@lab_no,test_booking_children.test_name)
		if(store_test_result)
			@total_tests=@total_tests+1
		end
	end
  end
  
  def report_print_selection
	length=params[:length].to_i
	check_value=params[:check_box_value].split("!")
	tests=params[:test_names].split("!")
	test_names=""
	i=0
	lab_no=params[:lab_id]
	for check in check_value
		if(check=="on")
			test_names<<tests[i]+"--->"
		end	
		i=i+1
	end
	$test_perameters=test_names
	puts test_names
	redirect_to("/store_test_result_children/report1/1?lab_no=#{lab_no}&format=pdf")
  end
  
  def report1
	@lab_no=params[:lab_no]
	@testbooking=TestBooking.find_by_lab_no(params[:lab_no]) 
	@tests=$test_perameters.split("--->")
	@registration=Registration.find_by_org_code_and_mr_no(@testbooking.org_code,@testbooking.mr_no)
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 20,
      :right_margin => 20,
      :top_margin => 30,
      :bottom_margin => 30},
      :filename => "#{@registration.patient_name}.pdf"

    render :layout => false
  end
end
