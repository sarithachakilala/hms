class MiscellaneousMastersController < ApplicationController
  # GET /miscellaneous_masters
  # GET /miscellaneous_masters.xml
  def index
  	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org=@person.org_code
    @miscellaneous_master = MiscellaneousMaster.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @miscellaneous_master }
    end
  end

  
  
  def search
	 @user_id=params[:user_id]
	@org=Person.find_by_id(@user_id)
	 @miscellaneous_master = MiscellaneousMaster.find(:all,:conditions => "mis_no = '#{params[:t]}' and org_code = '#{@org.org_code}'")
	render :partial => "search_mis_rec"
  end
  
  
  # GET /miscellaneous_masters/1
  # GET /miscellaneous_masters/1.xml
  def show
  		
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org=@person.org_code
	@miscellaneous_master = MiscellaneousMaster.find(params[:id])
		
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @miscellaneous_master }
    end
  end

  # GET /miscellaneous_masters/new
  # GET /miscellaneous_masters/new.xml
  def new

	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
    @miscellaneous_master = MiscellaneousMaster.new
	20.times{ @miscellaneous_master.miscellaneous_child.build }
	@miscellaneous_master.mis_no=@miscellaneous_master.find_mis_no()
	@v_no=MiscellaneousMaster.last(:select=>"Distinct voucher_no", :conditions=>"org_code='#{@org_code}'")
	if(@v_no)
		n=(@v_no.voucher_no.slice(2..8).to_i+1).to_s
	else
		n=1.to_s
	end
	str=""
	for r in 0...(9-(n.length+2))
		str<<"0"
	end
	@newreq="VN"<<str<<n
	@miscellaneous_master.voucher_no=@newreq
	
	
	respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @miscellaneous_master }
    end
  end

  def miscellaneous_master_report
		
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
  end
  
  # GET /miscellaneous_masters/1/edit
  def edit
  @user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
	
    @miscellaneous_master = MiscellaneousMaster.find(params[:id])
	 100.times{ @miscellaneous_master.miscellaneous_child.build }
  end


def print

	 @miscellaneous_master = MiscellaneousMaster.find(params[:id])
    	
		respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @miscellaneous_master }
    end
 end




  # POST /miscellaneous_masters
  # POST /miscellaneous_masters.xml
  def create
    @miscellaneous_master = MiscellaneousMaster.new(params[:miscellaneous_master])
	user_id=params[:user_id]
	@v_no=MiscellaneousMaster.last(:select=>"Distinct voucher_no", :conditions=>"org_code='#{@miscellaneous_master.org_code}'")
	if(@v_no)
		n=(@v_no.voucher_no.slice(2..8).to_i+1).to_s
	else
		n=1.to_s
	end
	str=""
	for r in 0...(9-(n.length+2))
		str<<"0"
	end
	@newreq="VN"<<str<<n
	@miscellaneous_master.voucher_no=@newreq
	
	
    respond_to do |format|
      if @miscellaneous_master.save
        format.html { redirect_to("/miscellaneous_masters/report/#{@miscellaneous_master.id}?&format=pdf", :notice => 'MiscellaneousMaster was successfully created.') }
        format.xml  { render :xml => @miscellaneous_master, :status => :created, :location => @miscellaneous_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @miscellaneous_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def report

	@miscellaneous_master = MiscellaneousMaster.find(params[:id])
    number=Number.new
    @to_watds=number.number_to_words( @miscellaneous_master.total_amount.to_i)
    
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 10,
      :right_margin => 0,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "#{@miscellaneous_master.date.strftime("%d-%m-%y")}.pdf"

    render :layout => false
	
  end
  
  
  # PUT /miscellaneous_masters/1
  # PUT /miscellaneous_masters/1.xml
  def update
    @miscellaneous_master = MiscellaneousMaster.find(params[:id])

    respond_to do |format|
      if @miscellaneous_master.update_attributes(params[:miscellaneous_master])
        format.html { redirect_to("/miscellaneous_masters/report/#{@miscellaneous_master.id}?&format=pdf", :notice => 'MiscellaneousMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @miscellaneous_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /miscellaneous_masters/1
  # DELETE /miscellaneous_masters/1.xml
  def destroy
    @miscellaneous_master = MiscellaneousMaster.find(params[:id])
    @miscellaneous_master.destroy

    respond_to do |format|
      format.html { redirect_to(miscellaneous_masters_url) }
      format.xml  { head :ok }
    end
  end
def ajax_buildings
	mr=params[:q]
	type1=params[:type]
	org_code=params[:org_code]
 	str=""
	
		if(type1=="department")
		@dop=EmployeeMaster.find(:all, :conditions => "department = '#{mr}' and org_code = '#{org_code}'")
			for i in 0...@dop.length
				str<<@dop[i].emp_id+","
			end
		render :text =>str
		
		elsif(type1=="name")
		@ser=ServiceMaster.find_by_name_and_org_code(mr,org_code)
		render :text => @ser.name+"<Division>"+@ser.code
		
		elsif(type1=="code")
		@emp=EmployeeMaster.find_by_emp_id_and_org_code(mr,org_code)
		render :text => @emp.first_name
		end
end

def find_report
		form_date=params[:from_date]
		to_date=params[:to_date]
		service=params[:service]
		org_code=params[:org_code]
		
		if(service!="")	
				if(form_date!="" && to_date!="")
					query=["date BETWEEN ? AND ? AND org_code Like '#{org_code}' AND service = ? ",form_date,to_date,service]	
				end
				if(query)	
					@mis=MiscellaneousMaster.new
					@mis1=MiscellaneousMaster.find(:all, :conditions => query)
					render :partial => "miscellanceous_master_reporting"
				else 
					render :text => "please enter any value"
				end
		else
			@mis=MiscellaneousMaster.new
			@mis1=MiscellaneousMaster.find(:all, :conditions => "(date BETWEEN '#{form_date}' and '#{to_date}') and org_code Like '#{org_code}'")
			render :partial => "miscellanceous_master_reporting"			
		end
	
	
	end
	
	def generate_reports
	
	@testbooking=MiscellaneousMaster.new
	@data=@testbooking.return_key
	pdf = MiscellaneousMasterReport.render_csv(:mrno => @data)
	send_data pdf, :type => "text/csv",
    :filename => "test_booking_reporting.csv"
  end
end
