class StoreRadiologyTestsController < ApplicationController
  # GET /store_radiology_tests
  # GET /store_radiology_tests.xml
  def index
    @store_radiology_tests = StoreRadiologyTest.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @store_radiology_tests }
    end
  end

  # GET /store_radiology_tests/1
  # GET /store_radiology_tests/1.xml
  def show
    @store_radiology_test = StoreRadiologyTest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @store_radiology_test }
    end
  end

  # GET /store_radiology_tests/new
  # GET /store_radiology_tests/new.xml
  def new
    @store_radiology_test = StoreRadiologyTest.new
    test_booking=TestBooking.find_by_lab_no(params[:lab_id])
	
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	
	@store_radiology_test.org_code=@person.org_code
	@store_radiology_test.org_location=@person.org_location
	@store_radiology_test.test_name=params[:test_name]
	@store_radiology_test.lab_no=params[:lab_id]
	
	@store_radiology_test.mr_no=test_booking.mr_no
	@store_radiology_test.admn_no=test_booking.admn_no
	@store_radiology_test.patient_name=test_booking.patient_name
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @store_radiology_test }
    end
  end

  # GET /store_radiology_tests/1/edit
  def edit
    @store_radiology_test = StoreRadiologyTest.find(params[:id])
  end

  # POST /store_radiology_tests
  # POST /store_radiology_tests.xml
  def create
    @store_radiology_test = StoreRadiologyTest.new(params[:store_radiology_test])

    respond_to do |format|
      if @store_radiology_test.save
        format.html { redirect_to(@store_radiology_test, :notice => 'StoreRadiologyTest was successfully created.') }
        format.xml  { render :xml => @store_radiology_test, :status => :created, :location => @store_radiology_test }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @store_radiology_test.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /store_radiology_tests/1
  # PUT /store_radiology_tests/1.xml
  def update
    @store_radiology_test = StoreRadiologyTest.find(params[:id])

    respond_to do |format|
      if @store_radiology_test.update_attributes(params[:store_radiology_test])
        format.html { redirect_to(@store_radiology_test, :notice => 'StoreRadiologyTest was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @store_radiology_test.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /store_radiology_tests/1
  # DELETE /store_radiology_tests/1.xml
  def destroy
    @store_radiology_test = StoreRadiologyTest.find(params[:id])
    @store_radiology_test.destroy

    respond_to do |format|
      format.html { redirect_to(store_radiology_tests_url) }
      format.xml  { head :ok }
    end
  end
  def report
   
 
   @store_test_result=StoreRadiologyTest.find_by_id(params[:id])
   @testbooking=TestBooking.find_by_lab_no(params[:lab_no])  
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
end
