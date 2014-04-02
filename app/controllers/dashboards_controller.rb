class DashboardsController < ApplicationController
  # GET /dashboards
  # GET /dashboards.xml
  
 def index
  @user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
	@dashboard = Dashboard.all
	
      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @dashboard }
    end
  end
  # GET /dashboards/1
  # GET /dashboards/1.xml
  def show
    @dashboard = Dashboard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dashboard }
    end
  end

  # GET /dashboards/new
  # GET /dashboards/new.xml
  def new
    @dashboard = Dashboard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dashboard }
    end
  end

  # GET /dashboards/1/edit
  def edit
    @dashboard = Dashboard.find(params[:id])
  end

  # POST /dashboards
  # POST /dashboards.xml
  def create
    @dashboard = Dashboard.new(params[:dashboard])

    respond_to do |format|
      if @dashboard.save
        format.html { redirect_to(@dashboard, :notice => 'Dashboard was successfully created.') }
        format.xml  { render :xml => @dashboard, :status => :created, :location => @dashboard }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dashboard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dashboards/1
  # PUT /dashboards/1.xml
  def update
    @dashboard = Dashboard.find(params[:id])

    respond_to do |format|
      if @dashboard.update_attributes(params[:dashboard])
        format.html { redirect_to(@dashboard, :notice => 'Dashboard was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dashboard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboards/1
  # DELETE /dashboards/1.xml
  def destroy
    @dashboard = Dashboard.find(params[:id])
    @dashboard.destroy

    respond_to do |format|
      format.html { redirect_to(dashboards_url) }
      format.xml  { head :ok }
    end
  end
   
  def chart_representation_revenue
	    label=Array.new
    	@date_array=Array.new
		type=params[:type].to_s
	    @type=type
		time = Time.new
	    org_code=params[:org_code]
		@con=Array.new
		@ip_payments=Array.new
		@due=Array.new
		@final_bill=Array.new
	    month_first_day=["01","02","03","04","05","06","07","08","09","10","11","12"]
	    month_last_day=["01-31","02-28","03-31","04-30","05-31","06-30","07-31","08-31","09-30","10-31","11-30","12-31"]
		@years=Array.new
	    @from=params[:from_year].to_s
	    @to=params[:to_year].to_s
	if(@type=="Weekly")
		k=0
		@from_date=params[:from_date]
		@to_date=params[:to_date]
		for i in @from_date.to_date..@to_date.to_date
			@con[k]=AppointmentPayment.sum(:consultant_fee, :conditions => " (book_date = '#{i.to_s}' and org_code LIKE '#{org_code}%')").to_f
			@ip_payments[k]=AdvancePayment.sum(:gross_amount, :conditions => "(advance_date = '#{i.to_s}' and org_code LIKE '#{org_code}%')")
			@final_bill[k]=FinalBill.sum(:paid_amount, :conditions => "(final_bill_date = '#{i.to_s}' AND org_code LIKE '#{org_code}%')").to_f
			@due[k]=IpDue.sum(:remaining_amount, :conditions => "(due_date = '#{i.to_s}' and org_code LIKE '#{org_code}%')").to_f
			date=i.to_s
			spl_date=date.split("-")
			@years[k]=spl_date[2].to_s
			k=k+1
		end
	  elsif(@type=="Monthly")
	      	@names=['Consultations']
		 if(params[:from_year]!="")
			year=params[:from_year]
		  else
			year=Time.new.year	
		  end		
		  k=0
		 for i in 0...12
		  if(i<10)
			@con[k]=AppointmentPayment.sum(:consultant_fee, :conditions => " (book_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')").to_f
		     @ip_payments[k]=AdvancePayment.sum(:gross_amount, :conditions => "(advance_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')")
			@final_bill[k]=FinalBill.sum(:paid_amount, :conditions => "(final_bill_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' AND org_code LIKE '#{org_code}%')").to_f
			@due[k]=IpDue.sum(:remaining_amount, :conditions => "(due_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')").to_f
		 else
			@con[k]=AppointmentPayment.sum(:consultant_fee, :conditions => " (book_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')").to_f
			@ip_payments[k]=AdvancePayment.sum(:gross_amount, :conditions => "(advance_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')")
			@final_bill[k]=FinalBill.sum(:paid_amount, :conditions => "(final_bill_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' AND org_code LIKE '#{org_code}%')").to_f
			@due[k]=IpDue.sum(:remaining_amount, :conditions => "(due_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')").to_f
			end
			k=k+1
		end
	 else
		k=0
		for i in @from.to_i..@to.to_i
			@con[k]=AppointmentPayment.sum(:consultant_fee, :conditions => " (book_date LIKE '#{i.to_s}-%-%' and org_code LIKE '#{org_code}%')").to_f
			@ip_payments[k]=AdvancePayment.sum(:gross_amount, :conditions => "(advance_date LIKE '#{i.to_s}-%-%' and org_code LIKE '#{org_code}%')")
			@final_bill[k]=FinalBill.sum(:paid_amount, :conditions => "(final_bill_date LIKE '#{i.to_s}-%-%' AND org_code LIKE '#{org_code}%')").to_f
			@due[k]=IpDue.sum(:remaining_amount, :conditions => "(due_date LIKE '#{i.to_s}-%-%' and org_code LIKE '#{org_code}%')").to_f
			@years[k]=i
			k=k+1
		end
	
	end
  end
def select_org_code
	person=Person.find_by_org_code(params[:org_code])
	render :text => person.org_location
  end
  
 def graphical_representation_of_department_revenue
 	 
	@label=Array.new
	@date_array=Array.new
	@consultant_visit=Array.new
	@type=params[:type].to_s
	puts params[:type].to_s
	department=params[:department].to_s
	org_code=params[:org_code]
	@dates=Array.new
	year=params[:year]
		i=0
		k=0	
		if(department=="")	
		
			if(@type=="Weekly")
				@department=DepartmentMaster.find(:all, :conditions =>" org_code LIKE '#{org_code}%'")
				@from_date=params[:from_date]
				puts params[:from_date]
				@to_date=params[:to_date]
				puts params[:to_date]
				for department1 in @department
					@label[i]=department1.department
					l=0
					for j in @from_date.to_date..@to_date.to_date
						date=j.to_s
						spl_date=date.split("-")
						@dates[l]=spl_date[2].to_s
			    			@consultant_visit[k]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit = '#{j.to_s}' AND  department='#{department1.department}' and org_code LIKE '#{org_code}%'")
						k=k+1
						l=l+1
					end
					i=i+1
				end

			elsif(@type=="Monthly")
				@department=DepartmentMaster.find(:all, :conditions =>" org_code LIKE '#{org_code}%'")
				if(params[:year]!="")
					year=params[:year]
				else
					year=Time.new.year	
				end			
				for department1 in @department
					@label[i]=department1.department
					for j in 1...13
						if(j<10)
				    			@consultant_visit[k]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{year.to_s}-0#{j}-%' AND  department='#{department1.department}' and org_code LIKE '#{org_code}%'")
						else
							@consultant_visit[k]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{year.to_s}-#{j}-%' AND  department='#{department1.department}' and org_code LIKE '#{org_code}%'")
						end
						k=k+1
					end
					i=i+1
				end
			elsif(@type=="Yearly")
				@from_year=params[:year]
				@to_year=params[:to_year]
				@department=DepartmentMaster.find(:all, :conditions =>" org_code LIKE '#{org_code}%'")
				for department1 in @department
					@label[i]=department1.department
					for j in @from_year.to_i..@to_year.to_i
			    			@consultant_visit[k]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{j.to_s}-%-%' AND  department='#{department1.department}' and org_code LIKE '#{org_code}%'")
						
						k=k+1
					end
					i=i+1
				end
			end	
	else
		if(@type=="Weekly")
			@department=DepartmentMaster.find(:all, :conditions =>" org_code LIKE '#{org_code}%'")
			@from_date=params[:from_date]
			@to_date=params[:to_date]
			
			@label[i]=department
			l=0
			for j in @from_date.to_date..@to_date.to_date
				@dates[l]=j.to_s
				@consultant_visit[k]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit = '#{j.to_s}' AND  department='#{department}' and org_code LIKE '#{org_code}%'")
				k=k+1
				l=l+1
			end
		elsif(@type=="Monthly")
			@department=DepartmentMaster.find(:all, :conditions =>" org_code LIKE '#{org_code}%'")
			if(params[:year]!="")
				year=params[:year]
			else
				year=Time.new.year	
			end	
		
			@label[i]=department
			for j in 1...13
				if(j<10)
		    		@consultant_visit[k]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{year.to_s}-0#{j}-%' AND  department='#{department}' and org_code LIKE '#{org_code}%'")
				else
					@consultant_visit[k]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{year.to_s}-#{j}-%' AND  department='#{department}' and org_code LIKE '#{org_code}%'")
				end
				k=k+1
			end
		elsif(@type=="Yearly")
			@from_year=params[:year]
			puts params[:year]
			@to_year=params[:to_year]
			@label[i]=department
			for j in @from_year.to_i..@to_year.to_i
				@consultant_visit[k]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{j.to_s}-%-%' AND  department='#{department}' and org_code LIKE '#{org_code}%'")
				k=k+1
			end
		end	
	
	end
end 
def dashboard_of_department_revenue
    
    label=Array.new
    @label1=Array.new
    @date_array=Array.new
	@consultation=Array.new
	@consultant_visit=Array.new
	type=params[:type]
	@type=type
	
	department=params[:department]
	org_code=params[:org_code]
	time = Time.new
	month_first_day=["01","02","03","04","05","06","07","08","09","10","11","12"]
	month_last_day=["01-31","02-28","03-31","04-30","05-31","06-30","07-31","08-31","09-30","10-31","11-30","12-31"]
	month={"Jan" => 01,"Feb" => 02,"Mar" => 03,"Apr" => 04,"May" => 05,"Jun" => 06,"Jul" => 07,"Aug" => 8,"Sep" => 9,"Oct" =>10,"Nov" =>11,"Dec" =>12}
	@dates=Array.new
	if(type=="Weekly")
		from_date=params[:from_date]
		to_date=params[:to_date]
		@from_date=from_date
		@to_date=to_date
		
		@len=(@to_date.to_date-@from_date.to_date).to_i
		if(department!="")
			@label1[0]=department
			for i in @from_date.to_date..@to_date.to_date
				@consultation[0]=AppointmentPayment.sum(:consultant_fee, :conditions => " (appt_date = '#{i}' ) AND department Like'#{department}%' and org_code LIKE '#{org_code}%'")
				@consultant_visit[0]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit = '#{i}' AND department Like'#{department}%' and org_code LIKE '#{org_code}%'")
				@dates[k]=i
			end
		else
			@departments=DepartmentMaster.find(:all, :conditions => "org_code LIKE '#{params[:org_code]}%'")
			for i in 0...@departments.length
				@label1[i]=@departments[i].name
				@consultation[i]=AppointmentPayment.sum(:consultant_fee, :conditions => " (appt_date BETWEEN '#{from_date}' AND '#{to_date}' ) AND department Like'#{@departments[i].department}' and org_code LIKE '#{org_code}%'")
				@consultant_visit[i]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit BETWEEN '#{from_date}' AND '#{to_date}' AND department Like'#{@departments[i].department}' and org_code LIKE '#{org_code}%'")
			end

		end
	elsif(type=="Monthly")
		label[0]=params[:month]
		year=params[:year]
		if(year!="")
			sel_year=year.to_s
		else
			sel_year=time.year.to_s
		end
		if(department!="")
			k=0
			for z in 0...12
				@consultation[k]=(AppointmentPayment.sum(:consultant_fee, :conditions => "(appt_date LIKE '#{sel_year}-#{month_first_day[z].to_s}-%') AND department LIKE '#{department}%' and org_code LIKE '#{org_code}%'")).to_f
				@consultant_visit[k]=(ConsultantVisit.sum(:charge, :conditions => "(date_of_visit LIKE '#{sel_year}-#{month_first_day[z].to_s}-%') AND department LIKE '#{department}%' and org_code LIKE '#{org_code}%'")).to_f
				
				k=k+1
			end
		
		else
			@departments=DepartmentMaster.find(:all, :conditions => "org_code LIKE '#{params[:org_code]}%'")
			for i in 0...@departments.length
				label[i]=@departments[i].name
				k=0
				for z in 0...12
							if(z<10)
							@consultation[i]=AppointmentPayment.sum(:consultant_fee, :conditions => " appt_date LIKE '#{sel_year}-#{month_first_day[z].to_s}-%' AND department = '#{@departments[i].department}' and org_code LIKE '#{org_code}%'")
							@consultant_visit[i]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{sel_year}-#{month_first_day[z].to_s}-%' AND department = '#{@departments[i].department}' and org_code LIKE '#{org_code}%'")
							else
							@consultation[i]=AppointmentPayment.sum(:consultant_fee, :conditions => " appt_date LIKE '#{sel_year}-#{month_first_day[z].to_s}-%' AND department = '#{@departments[i].department}' and org_code LIKE '#{org_code}%'")
							@consultant_visit[i]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{sel_year}-#{month_first_day[z].to_s}-%' AND department = '#{@departments[i].department}' and org_code LIKE '#{org_code}%'")
							end
							k=k+1
				end
			end
		end
	elsif(type=="Yearly")
		year=params[:year]
		 @year=year
		label[0]=year.to_s
		if(department!="")
			label[0]=department
			@consultation[0]=AppointmentPayment.sum(:consultant_fee, :conditions => " appt_date LIKE '#{year.to_s}-%-%' AND department = '#{department}' and org_code LIKE '#{org_code}%'")
			@consultant_visit[0]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{year.to_s}-%-%' AND department = '#{department}' and org_code LIKE '#{org_code}%'")
		else
			@departments=DepartmentMaster.find(:all, :conditions => "org_code LIKE '#{params[:org_code]}%'")
			for i in 0...@departments.length
				label[i]=@departments[i].name
				@consultation[i]=AppointmentPayment.sum(:consultant_fee, :conditions => " appt_date LIKE '#{year.to_s}-%-%' AND department = '#{@departments[i].department}' and org_code LIKE '#{org_code}%'")
				@consultant_visit[i]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{year.to_s}-%-%' AND department = '#{@departments[i].department}' and org_code LIKE '#{org_code}%'")
			end
		end
	end
	if(department!="")
		@mcol3d = Ezgraphix::Graphic.new(:div_name => '@mcol3d', :c_type => 'mcol3d', :w => 500, :labels => label)
	else
		@mcol3d = Ezgraphix::Graphic.new(:div_name => '@mcol3d', :c_type => 'mcol3d', :w => 1200, :labels => label)
	end
    	check=0
    	for i in 0...@consultation.length
		if(@consultation[i]!=0)
			check=1
			break
		end
	end
	if(check==1)
		@mcol3d.data = { "Department wise revenues" => @consultation}
    	end
	@mcol3d.labels = label
  end
  def dashboard_of_bed

	ward=params[:ward]
	@org_code=params[:org_code]
	headers["content-type"]="text/html";
    	@date1=params[:q]
	@label=Array.new
	@available_data=Array.new
	@available_data1=Array.new
	@occupied_data=Array.new
	@un_available=Array.new
	
	if(@org_code!="" && ward!="")
		@ward=WardMaster.find_by_org_code_and_name(@org_code,ward)
		@room=RoomMaster.find_by_ward_master_id_and_org_code(@ward.id,@org_code)
		@bed=BedMaster.find_by_room_master_id_and_org_code(@room.id,@org_code)
		if(@bed.status=="Available")
			@available_data1[0]=BedMaster.find(:all, :conditions => "room_master_id = '#{@room.id}' AND org_code= '#{@org_code}' AND status = 'Available'").length
		elsif(@bed.status=="Un-Available")
			@un_available[0]=BedMaster.find(:all, :conditions => "room_master_id = '#{@room.id}' AND org_code= '#{@org_code}' AND status = 'Un-Available'").length	
		end
		j=1
		i=1
		z=1
		@label[0]=@ward.name
		
		@mcol3d = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :caption => "Bed", :w => 400, :x_name=>'Ward Names', :y_name=>'Beds', :background => 'ecf3f7', :div_line_precision=>'0', :precision =>'0', :f_number_scale=>'0', :line => 'red')
		@mcol3d.data = { "Available" => @available_data1, "To Be Available" => @available_data, "Occupied" => @un_available}
		@mcol3d.labels = @label
		
	else
		@label[0]=ward
		@date1=params[:q]
		@bed=BedMaster.find(:all, :conditions=>"org_code='#{@org_code}'")
		k=0
		available=0
		unavailable=0
		for i in 0...@bed.length
			if(@bed[i].status=="Available")
				@available_data1[k]=available+1
			elsif(@bed[i].status=="Un-Available")
				@un_available[k]=unavailable+1
			elsif(@bed[i].status=="Occupied")
				@available_data[k]=BedMaster.find(:all)	
			end
			k=k+1
		  end	
		headers["content-type"]="text/html";
 	end	
  end  
  
  
  def financial_chart_representation
      
	label=Array.new
    	@graph = open_flash_chart_object(410,240, '/management_info_system_reports/pie_links/1')	
    	org_code=params[:org_code]
	#Bed Chart
	
		@ward_names=Array.new
		@available_data=Array.new
		@occupied_data=Array.new
		if(org_code!="")
			@ward=WardMaster.find(:all, :conditions => "org_code='#{org_code}'")
			for i in 0...@ward.length
				@ward_names[i]=@ward[i].name
				@ward1=BedMaster.all(:conditions => "ward_master_id = #{@ward[i].id} and status ='Available' and org_code LIKE '#{org_code}%'")
				@ward2=BedMaster.all(:conditions => "ward_master_id = #{@ward[i].id} and status ='Un-Available' and org_code LIKE '#{org_code}%'")
				@available_data[i]=@ward1.length
				@occupied_data[i]=@ward2.length
			end
		else
			@people=Person.find(:all,:select => "DISTINCT org_code")
			total=0
			for people in @people
				@ward=WardMaster.find(:all, :conditions => "org_code='#{people.org_code}'")
				for i in 0...@ward.length
					@ward_names[total]=@ward[i].name+"<br/>"+@ward[i].org_code
					@ward1=BedMaster.all(:conditions => "ward_master_id = #{@ward[i].id} and status ='Available' and org_code LIKE '#{people.org_code}%'")
					@ward2=BedMaster.all(:conditions => "ward_master_id = #{@ward[i].id} and status ='Un-Available' and org_code LIKE '#{people.org_code}%'")
					@available_data[total]=@ward1.length
					@occupied_data[total]=@ward2.length
					total=total+1
				end
			end
		end	
	#Doctor Chart
	
	fee=Array.new
	@consultation=Array.new
	consultants=Array.new
	consultant_names=Array.new
	time = Time.new
	@label=Array.new
	@doctor=ConsultantMaster.find(:all, :conditions => "charge_type = 'OP' OR charge_type= 'Both' and org_code LIKE '#{org_code}%'")
	if(time.month<10)
		mon="0"+time.month.to_s
	else
		mon=time.month.to_s
	end
	if(org_code!="")
		@doctor=ConsultantMaster.find(:all, :conditions => "charge_type = 'OP' OR charge_type= 'Both' and org_code LIKE '#{org_code}%'")	
		consultationforms=Array.new
		consultants=Array.new
		for i in 0...@doctor.length
			employee=EmployeeMaster.find_by_empid(@doctor[i].consultant_id)
			consultationforms[i] = AppointmentPayment.sum(:paid_amount,:conditions => "appt_date Like '#{time.year.to_s}-#{mon}-%' and consultant_name = '#{employee.name}' and org_code LIKE '#{org_code}%'").to_f
			consultants[i]=employee.name
		end
		if(5<=@doctor.length)
				total_doc=5
			else
				total_doc=@doctor.length
			end
		for j in 0...total_doc
			for k in j+1...consultationforms.length
				if(consultationforms[j]<consultationforms[k])
					temp=consultationforms[k]
					consultationforms[k]=consultationforms[j]
					consultationforms[j]=temp
					temp1=consultants[k]
					consultants[k]=consultants[j]
					consultants[j]=temp1
				end
			end
			@consultation[j]=consultationforms[j]
			@label[j]=consultants[j]
		end
	else
		@people=Person.find(:all,:select => "DISTINCT org_code")
		total=0
		for people in @people
			@doctor=ConsultantMaster.find(:all, :conditions => "charge_type = 'OP' OR charge_type= 'Both' and org_code LIKE '#{people.org_code}%'")
			consultationforms=Array.new
			consultants=Array.new
			for i in 0...@doctor.length
				consultationforms[i] = AppointmentPayment.sum(:paid_amount,:conditions => "appt_date Like '#{time.year.to_s}-#{mon}-%' and consultant_id = '#{@doctor[i].consultant_id}' and org_code LIKE '#{people.org_code}%'").to_f
				employee=EmployeeMaster.find_by_empid(@doctor[i].consultant_id)
				consultants[i]=employee.name
			end
			if(5<=@doctor.length)
				total_doc=5
			else
				total_doc=@doctor.length
			end
			for j in 0...total_doc
				for k in j+1...consultationforms.length
					if(consultationforms[j]<consultationforms[k])
						temp=consultationforms[k]
						consultationforms[k]=consultationforms[j]
						consultationforms[j]=temp
						temp1=consultants[k]
						consultants[k]=consultants[j]
						consultants[j]=temp1
					end
				end
				@consultation[total]=consultationforms[j]
				@label[total]=consultants[j]
				total=total+1
			end
		end
	end
	
		#Department Chart
		dep_consultationforms=Array.new
		@dep_fee=Array.new
		dep_consultants=Array.new
		@dep_consultant_names=Array.new
		dep_time = Time.new
		if(dep_time.month<10)
			dep_time_mon="0"+time.month.to_s
		else
			dep_time_mon=time.month.to_s
		end
		if(org_code!="")
			@department=DepartmentMaster.find(:all, :conditions => "org_code LIKE '#{org_code}%'")
			for i in 0...@department.length
				dep_consultationforms[i] = AppointmentPayment.sum(:paid_amount,:conditions => "appt_date Like '#{dep_time.year.to_s}-#{dep_time_mon}-%' and department = '#{@department[i].department}' and org_code LIKE '#{org_code}%'").to_f
				dep_consultants[i]=@department[i].department
			end
			if(5<=@department.length)
				total_doc=5
			else
				total_doc=@department.length
			end
			for j in 0...total_doc
				for k in j+1...dep_consultationforms.length
					if(dep_consultationforms[j]<dep_consultationforms[k])
						dep_temp=dep_consultationforms[k]
						dep_consultationforms[k]=dep_consultationforms[j]
						dep_consultationforms[j]=dep_temp
						dep_temp1=dep_consultants[k]
						dep_consultants[k]=dep_consultants[j]
						dep_consultants[j]=dep_temp1
					end
				end
				@dep_fee[j]=dep_consultationforms[j]
				@dep_consultant_names[j]=dep_consultants[j]
			end
		else
			@people=Person.find(:all,:select => "DISTINCT org_code")
			total=0
			for people in @people
				@department=DepartmentMaster.find(:all, :conditions => "org_code LIKE '#{people.org_code}%'")
				dep_consultationforms=Array.new
				dep_consultants=Array.new
				for i in 0...@department.length
					dep_consultationforms[i] = AppointmentPayment.sum(:paid_amount,:conditions => "appt_date Like '#{dep_time.year.to_s}-#{dep_time_mon}-%' and department = '#{@department[i].department}' and org_code LIKE '#{people.org_code}%'").to_f
					dep_consultants[i]=@department[i].department
				end
				if(5<=@department.length)
					total_doc=5
				else
					total_doc=@department.length
				end
				for j in 0...total_doc
					for k in j+1...dep_consultationforms.length
						if(dep_consultationforms[j]<dep_consultationforms[k])
							dep_temp=dep_consultationforms[k]
							dep_consultationforms[k]=dep_consultationforms[j]
							dep_consultationforms[j]=dep_temp
							dep_temp1=dep_consultants[k]
							dep_consultants[k]=dep_consultants[j]
							dep_consultants[j]=dep_temp1
						end
					end
					@dep_fee[total]=dep_consultationforms[j]
					@dep_consultant_names[total]=dep_consultants[j]
					total=total+1
				end
				
			end
		end
	
		#Patient Visit Chart
		patient_visit_time = Time.new
		if(patient_visit_time.month<10)
			patient_visit_time_mon="0"+patient_visit_time.month.to_s
		else
			patient_visit_time_mon=patient_visit_time.month.to_s
		end
		@patient_visit=Array.new
		@visit_org=Array.new
		if(org_code!="")
			@patient_visit[0]= AppointmentPayment.find(:all,:conditions => "appt_date Like '#{patient_visit_time.year.to_s}-#{patient_visit_time_mon}-%' and org_code LIKE '#{org_code}%'").length
			@visit_org[0]='Patient Visits '
		else
			@people=Person.find(:all,:select => "DISTINCT org_code")
			total=0
			for people in @people
				@patient_visit[total]= AppointmentPayment.find(:all,:conditions => "appt_date Like '#{patient_visit_time.year.to_s}-#{patient_visit_time_mon}-%' and org_code LIKE '#{org_code}%'").length
				@visit_org[total]='Patient Visits'
				total=total+1
			end
		end	
    end  
end
