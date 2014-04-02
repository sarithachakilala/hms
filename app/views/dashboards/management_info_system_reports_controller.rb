class ManagementInfoSystemReportsController < ApplicationController
  # GET /management_info_system_reports
  # GET /management_info_system_reports.xml
  def index
  @user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
	@management_info_system_reports = ManagementInfoSystemReport.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@org.org_code}'"
	
      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @management_info_system_reports }
    end
  end

  # GET /management_info_system_reports/1
  # GET /management_info_system_reports/1.xml
  def show
    @management_info_system_report = ManagementInfoSystemReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @management_info_system_report }
    end
  end

  # GET /management_info_system_reports/new
  # GET /management_info_system_reports/new.xml
  def new
    @management_info_system_report = ManagementInfoSystemReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @management_info_system_report }
    end
  end

  # GET /management_info_system_reports/1/edit
  def edit
    @management_info_system_report = ManagementInfoSystemReport.find(params[:id])
  end

  # POST /management_info_system_reports
  # POST /management_info_system_reports.xml
  def create
    @management_info_system_report = ManagementInfoSystemReport.new(params[:management_info_system_report])

    respond_to do |format|
      if @management_info_system_report.save
        format.html { redirect_to(@management_info_system_report, :notice => 'ManagementInfoSystemReport was successfully created.') }
        format.xml  { render :xml => @management_info_system_report, :status => :created, :location => @management_info_system_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @management_info_system_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /management_info_system_reports/1
  # PUT /management_info_system_reports/1.xml
  def update
    @management_info_system_report = ManagementInfoSystemReport.find(params[:id])

    respond_to do |format|
      if @management_info_system_report.update_attributes(params[:management_info_system_report])
        format.html { redirect_to(@management_info_system_report, :notice => 'ManagementInfoSystemReport was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @management_info_system_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /management_info_system_reports/1
  # DELETE /management_info_system_reports/1.xml
  def destroy
    @management_info_system_report = ManagementInfoSystemReport.find(params[:id])
    @management_info_system_report.destroy

    respond_to do |format|
      format.html { redirect_to(management_info_system_reports_url) }
      format.xml  { head :ok }
    end
  end
  
  def generate_reports
	@date1=params[:date1]
	@date2=params[:date2]
	@option=params[:option]
	@org_code=params[:org_code]
    if(@option=="registarion")
		
		pdf = RegistrationReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
            :filename => "registarion.csv"
	elsif(@option=="consultation")
		@data=Consultationform.find(:all, :conditions => " cons_date BETWEEN '#{@date1}' AND '#{@date2}'")
		
		pdf = OpConsultationReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
                :filename => "consultationreport.csv"	
	elsif(@option=="IP")
		@data=["(final_bill_date BETWEEN ? AND ? ) AND org_code = ?",@date1,@date2,@org_code]
		pdf1 = FinalBillReport.render_csv(:mrno => @data)
		send_data pdf1, :type => "text/csv",
				:filename => "Advances.csv"	
	elsif(@option=="dues")
		pdf = DueRecieptReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
                :filename => "duesreciept.csv"
	elsif(@revenue_type=="consultation" || @revenue_type=="consultation_due")
		@data=Consultationform.find(:all, :conditions => " cons_date BETWEEN '#{@date1}' AND '#{@date2}' AND due!=0")
		pdf = OpConsultationReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
                :filename => "consultation_due_report.csv"	
	end
  end
  def date1
     
	date2=params[:q]
	date3=params[:date3]
	d2=params[:type]
	org_code=params[:org_code]
	bill_no=params[:bill_no]
	if(params[:option]=="appt")
		query=[ "appt_date  BETWEEN ? AND ? AND consultant_id = ? and org_code= ?", date2,date3,d2,org_code]
		@appt_management=ApptManagement.find(:all, :conditions => query)
		@patient_visit_history=PatientVisitHistory.find(:all)
		if(@appt_management)
			render :partial => "appoint_search"
		else
			render :text =>  "please enter any value"
		end

    elsif(params[:option]=="list")	
	 	if(date1!="" && bill_no!="")
		 query=["bill_date =? AND bill_no = ?", date2,bill_no]
		elsif(date1!="")
	      query=[ "bill_date =? ", date2]
		end
		@opbilling=OpBilling.find(:all, :conditions => query)
		if(@opbilling)
		  render :partial => "bill_list"
             else 
		  render :text => "please enter any value"
		end
	
	elsif(params[:option]=="doctor_visit")	
	    consultant= params[:consultant]
		if(date2!="" && date3!="" && params[:consultant])
		query=["cons_date BETWEEN ? AND ? AND consultant_id LIKE '#{consultant}%' and org_code Like '#{org_code}%'", date2,date3 ]
		
		end
		@consultationform=ApptPayment.find(:all, :conditions => query)
		
		if(@consultationform)
		render :partial => "doctor_visit_history"
           else 
		render :text => "please enter any value"
		end
      elsif(params[:option]=="doctor_type")	
	    consultant= params[:consultant]
		@d1=params[:q]
		@d2=params[:date2]
		org_code=params[:org_code]
		@doctor=ConsultantMaster.find(:all, :conditions =>"consultant_type Like '#{consultant}%' and org_code Like'#{org_code}%'")
		render :partial => "doctor_revenue"
	elsif(params[:option]=="ip_advances")	
	    @option=params[:option1]
		@date_array=Array.new
		if(@option=="Day")
			@date=d1
			@date2=params[:date2]
			d2=Date.strptime(@date2, "%Y/%m/%d")
			date_diff=d2.to_date-@date.to_date
			for i in 0..date_diff
				@date_array[i]=@date+i
			end
		elsif(@option=="Year")
			year=params[:year]
			@date_array[0]=Date.strptime(year.to_s+"/01/01", "%Y/%m/%d")
			@date_array[1]=Date.strptime(year.to_s+"/12/31", "%Y/%m/%d")
			
		elsif(@option=="Month")
			time = Time.new
			day=params[:day]
			if(params[:day]=="Jan")
				@date_array[0]=Date.strptime(time.year.to_s+"/01/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/01/31", "%Y/%m/%d")
			elsif(params[:day]=="Feb")
				@date_array[0]=Date.strptime(time.year.to_s+"/02/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/02/28", "%Y/%m/%d")
			elsif(params[:day]=="Mar")
				@date_array[0]=Date.strptime(time.year.to_s+"/03/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/03/31", "%Y/%m/%d")
			elsif(params[:day]=="Apr")
				@date_array[0]=Date.strptime(time.year.to_s+"/04/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/04/30", "%Y/%m/%d")
			elsif(params[:day]=="May")
				@date_array[0]=Date.strptime(time.year.to_s+"/05/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/05/31", "%Y/%m/%d")
			elsif(params[:day]=="Jun")
				@date_array[0]=Date.strptime(time.year.to_s+"/06/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/06/30", "%Y/%m/%d")
			elsif(params[:day]=="Jul")
				@date_array[0]=Date.strptime(time.year.to_s+"/07/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/07/31", "%Y/%m/%d")
			elsif(params[:day]=="Aug")
				@date_array[0]=Date.strptime(time.year.to_s+"/08/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/08/31", "%Y/%m/%d")
			elsif(params[:day]=="Sep")
				@date_array[0]=Date.strptime(time.year.to_s+"/09/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/09/30", "%Y/%m/%d")
			elsif(params[:day]=="Oct")
				@date_array[0]=Date.strptime(time.year.to_s+"/10/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/10/31", "%Y/%m/%d")
			elsif(params[:day]=="Nov")
				@date_array[0]=Date.strptime(time.year.to_s+"/11/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/11/30", "%Y/%m/%d")
			elsif(params[:day]=="Dec")
				@date_array[0]=Date.strptime(time.year.to_s+"/12/01", "%Y/%m/%d")
				@date_array[1]=Date.strptime(time.year.to_s+"/12/31", "%Y/%m/%d")
			end
		end
		render :partial => "ip_advances_payment"
	elsif(params[:option]=="due_payments")	
	
	   	@patient_type=params[:patient_type]
		date11=params[:date1]
		date12=params[:date2]
		
			if(@patient_type=="OP")
				@consultation=ApptPayment.find(:all, :conditions => "cons_date BETWEEN '#{date11}'AND '#{date12}' AND due != 0 ")	
				@opbilling=TestBooking.find(:all, :conditions => "receipt_date BETWEEN '#{date11}'AND '#{date12}' AND due != 0 AND patient_type='OP' ")	
			else
			    @opbilling=TestBooking.find(:all, :conditions => "receipt_date BETWEEN '#{date11}'AND '#{date12}' AND due != 0 AND patient_type='IP' ")	
				@final_bill=FinalBill.find(:all, :conditions => "final_bill_date  BETWEEN '#{params[:date11]}'AND '#{params[:date12]}' AND due != 0 ")	
			end	
		
		    render :partial => "due_payment"
			

	elsif(params[:option]=="final_payment")	
	     org_code=params[:org_code]
		 @date3=params[:q]
		  @date4=params[:date4]
	    query=["final_bill_date BETWEEN  ? AND ?  and org_code Like '#{org_code}%'", @date3,@date4]
		
		@finalbill=FinalBill.find(:all, :conditions => query)
		if(@finalbill)
		render :partial => "final_payment"
        else 
		render :text => "please enter any value"
		end	
  	end
  end
   def date2
     
	date1=params[:date1]
	type=params[:type]
	
	room=params[:room1]
	ward=params[:ward]
	bed=params[:bed]
	if(date1)
		@d1=Date.strptime(date1, "%Y/%m/%d")
		
	end
	if(type=="wait")
	     @a="Admitted"
		if(@d1!="empty" && ward!="" && room!="" && bed!="")
			query=["admn_date =?  AND ward = ? AND room = ? AND bed = ? AND status != ?",@d1,ward,room,bed,@a]
		elsif(@d1!="empty" && ward!="" && room!="" )
			query=["admn_date =?   AND ward = ? AND room = ? AND status != ?",@d1,ward,room,@a]
		elsif(@d1!="empty" && ward!=""  )
			query=["admn_date =?  AND ward = ? AND status != ? ",@d1,ward,@a]
		elsif(@d1!="empty")
			query=["admn_date =? AND status != ? ",@d1,@a]		
	    
		elsif(ward!="" )
			query=[" ward = ? AND status != ? ",ward,@a]	
		elsif(room!="" )
			query=[" room = ? AND status != ?",room,@a]
        elsif(bed!="" )
			query=["bed = ? AND status != ?",bed,@a]			
		end	
	    @ipadmission=Ipadmission.find(:all, :conditions => query)
	
		if( @ipadmission)
			render :partial => "adm_waiting_search"
		else
			render :text =>  "please enter any value"
		end	
      end
  end
  
  
  
  
  def generate_reports
	@date1=params[:date1]
	@date2=params[:date2]
	@option=params[:option]
	@org_code=params[:org_code]
    	if(@option=="registarion")
		
		pdf = RegistrationReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
            :filename => "registarion.csv"
	elsif(@option=="consultation")
		@data=ApptPayment.find(:all, :conditions => " cons_date BETWEEN '#{@date1}' AND '#{@date2}'")
		
		pdf = OpConsultationReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
                :filename => "consultationreport.csv"	
	elsif(@option=="IP")
		@data=["(final_bill_date BETWEEN ? AND ? ) AND org_code = ?",@date1,@date2,@org_code]
		pdf1 = FinalBillReport.render_csv(:mrno => @data)
		send_data pdf1, :type => "text/csv",
				:filename => "Advances.csv"	
	elsif(@option=="dues")
		pdf = DueRecieptReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
                :filename => "duesreciept.csv"
	elsif(@revenue_type=="consultation" || @revenue_type=="consultation_due")
		@data=Consultationform.find(:all, :conditions => " cons_date BETWEEN '#{@date1}' AND '#{@date2}' AND due!=0")
		pdf = OpConsultationReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
                :filename => "consultation_due_report.csv"	
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
	@op=Array.new
	@ip_payments=Array.new
	@due=Array.new
	
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
			@con[k]=ApptPayment.sum(:fee, :conditions => " (cons_date = '#{i.to_s}' and org_code LIKE '#{org_code}%')").to_f
			@op[k]=OpBilling.sum(:receipt_amount, :conditions => "(bill_date = '#{i.to_s}' and org_code LIKE '#{org_code}%')").to_f
			@ip_payments[k]=AdvancePayment.sum(:gross_amount, :conditions => "(advance_date = '#{i.to_s}' and org_code LIKE '#{org_code}%')")+FinalBill.sum(:paid_amount, :conditions => "(final_bill_date = '#{i.to_s}' AND org_code LIKE '#{org_code}%')").to_f
			@due[k]=OpDue.sum(:paid_amount, :conditions => "(payment_date = '#{i.to_s}' and org_code LIKE '#{org_code}%')").to_f
			date=i.to_s
			spl_date=date.split("-")
			@years[k]=spl_date[2].to_s
			k=k+1
		end
	elsif(@type=="Monthly")
	      	@names=['Registrations','Consultations','Opbilling','IP','Due']
		if(params[:from_year]!="")
			year=params[:from_year]
		else
			year=Time.new.year	
		end		
		k=0
		for i in 0...12
			if(i<10)
				@con[k]=ApptPayment.sum(:fee, :conditions => " (cons_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')").to_f
				@op[k]=OpBilling.sum(:receipt_amount, :conditions => "(bill_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')").to_f
				@ip_payments[k]=AdvancePayment.sum(:gross_amount, :conditions => "(advance_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')")+FinalBill.sum(:paid_amount, :conditions => "(final_bill_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' AND org_code LIKE '#{org_code}%')").to_f
				@due[k]=OpDue.sum(:paid_amount, :conditions => "(payment_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')").to_f
			else
				@con[k]=ApptPayment.sum(:fee, :conditions => " (cons_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')").to_f
				@op[k]=OpBilling.sum(:receipt_amount, :conditions => "(bill_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')").to_f
				@ip_payments[k]=AdvancePayment.sum(:gross_amount, :conditions => "(advance_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')")+FinalBill.sum(:paid_amount, :conditions => "(final_bill_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' AND org_code LIKE '#{org_code}%')").to_f
				@due[k]=OpDue.sum(:paid_amount, :conditions => "(payment_date LIKE '#{year.to_s}-#{month_first_day[i]}-%' and org_code LIKE '#{org_code}%')").to_f
			
			end
			k=k+1
		end
	 else
		k=0
		for i in @from.to_i..@to.to_i
			@con[k]=ApptPayment.sum(:fee, :conditions => " (cons_date LIKE '#{i.to_s}-%-%' and org_code LIKE '#{org_code}%')").to_f
			@op[k]=OpBilling.sum(:receipt_amount, :conditions => "(bill_date LIKE '#{i.to_s}-%-%' and org_code LIKE '#{org_code}%')").to_f
			@ip_payments[k]=AdvancePayment.sum(:gross_amount, :conditions => "(advance_date LIKE '#{i.to_s}-%-%' and org_code LIKE '#{org_code}%')")+FinalBill.sum(:paid_amount, :conditions => "(final_bill_date LIKE '#{i.to_s}-%-%' AND org_code LIKE '#{org_code}%')").to_f
			@due[k]=OpDue.sum(:paid_amount, :conditions => "(payment_date LIKE '#{i.to_s}-%-%' and org_code LIKE '#{org_code}%')").to_f
			@years[k]=i
			k=k+1
		end
	
	end
  end

  
 def consultation_margin_representation1
 
    headers["content-type"]="text/html";
	@label=Array.new
    @date_array=Array.new
	@consultation=Array.new
	@type=params[:type].to_s
	consultant=params[:consultant]
	org_code=params[:org_code]
	time = Time.new
	month_first_day=["01-01","02-01","03-01","04-01","05-01","06-01","07-01","08-01","09-01","10-01","11-01","12-01"]
	month_last_day=["01-31","02-28","03-31","04-30","05-31","06-30","07-31","08-31","09-30","10-31","11-30","12-31"]
	month={"Jan" => "01","Feb" => "02","Mar" => "03","Apr" => "04","May" => "05","Jun" => "06","Jul" => "07","Aug" => "08","Sep" => "09","Oct" =>"10","Nov" =>"11","Dec" =>"12"}
	if(@type=="Weekly")
		@from_date=params[:from_date]
		@to_date=params[:to_date]
		@label[0]=@from_date.to_s+" - "+@to_date.to_s
		
		if(consultant!="")
			@label[0]=consultant
			consultant1=ConsultantMaster.last(:conditions => "name = '#{consultant}' and org_code LIKE '#{org_code}%'")
			@consultation[0]=ConsultantPayment.sum(:paid_amt, :conditions => " (date BETWEEN '#{@from_date}' AND '#{@to_date}') AND emp_name = '#{consultant}' and org_code LIKE '#{org_code}%'").to_f
		else
			@consultant=ConsultantMaster.find(:all, :conditions => "org_code LIKE '#{org_code}%'")
			for i in 0...@consultant.length
				@label[i]=@consultant[i].name
				@consultation[i]=ConsultantPayment.sum(:paid_amt, :conditions => " (date BETWEEN '#{@from_date}' AND '#{@to_date}') AND emp_name = '#{@consultant[i].name}' and org_code LIKE '#{org_code}%'").to_f
			end
		end
	elsif(@type=="Monthly")
		@label[0]=params[:month]
		@mon=params[:month]
		@year=params[:year]
		if(@year!="")
			con_year=@year.to_s
		else
			con_year=time.year.to_s
		end
		if(consultant!="")
			@label[0]=consultant
			consultant1=ConsultantMaster.last(:conditions => "name = '#{consultant}' and org_code LIKE '#{org_code}%'")
			@consultation[0]=ConsultantPayment.sum(:paid_amt, :conditions => " date LIKE '#{con_year}-#{month[params[:month]].to_s}-%' AND emp_name = '#{consultant}' and org_code LIKE '#{org_code}%'").to_f
		else
			@consultant=ConsultantMaster.find(:all, :conditions => "org_code LIKE '#{org_code}%'")
			for i in 0...@consultant.length
				@label[i]=@consultant[i].name
				@consultation[i]=ConsultantPayment.sum(:paid_amt, :conditions => " date LIKE '#{con_year}-#{month[params[:month]].to_s}-%' AND emp_name = '#{@consultant[i].name}' and org_code LIKE '#{org_code}%'").to_f
			end
		end

	elsif(@type=="Yearly")
		@year=params[:year]
		if(consultant!="")
			@label[0]=consultant
			consultant1=ConsultantMaster.last(:conditions => "name = '#{consultant}' and org_code LIKE '#{org_code}%'")
			@consultation[0]=ConsultantPayment.sum(:paid_amt, :conditions => " date LIKE '#{@year}-%-%'  AND emp_name = '#{consultant}' and org_code LIKE '#{org_code}%'").to_f
		else
			@consultant=ConsultantMaster.find(:all, :conditions => "org_code LIKE '#{org_code}%'")
			for i in 0...@consultant.length
				@label[i]=@consultant[i].name
				@consultation[i]=ConsultantPayment.sum(:paid_amt, :conditions => " date LIKE '#{@year}-%-%'  AND emp_name = '#{@consultant[i].name}' and org_code LIKE '#{org_code}%'").to_f
			end
		end
	end
	if(consultant!="")
		@cons = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :w => 500, :labels => @label)
	else
		@cons = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :w => 1200, :labels => @label)
	end
	check=0
    	for i in 0...@consultation.length
		if(@consultation[i]!=0)
			check=1
			break
		end
	end
	if(check==1)
		@cons.data = { "Consultation wise revenues" => @consultation}
	end
	@cons.labels = @label
  end

  
  
def department_margin_representation_revenue
     
    label=Array.new
    @label1=Array.new
    @date_array=Array.new
	@consultation=Array.new
	@consultation_visit=Array.new
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
				@consultation[0]=ApptPayment.sum(:fee, :conditions => " (cons_date = '#{i}' ) AND department Like'#{department}%' and org_code LIKE '#{org_code}%'")
				@consultation_visit[0]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit = '#{i}' AND department Like'#{department}%' and org_code LIKE '#{org_code}%'")
				@dates[k]=i
			end
		else
			@departments=DepartmentMaster.find(:all, :conditions => "org_code LIKE '#{params[:org_code]}%'")
			for i in 0...@departments.length
				@label1[i]=@departments[i].name
				@consultation[i]=ApptPayment.sum(:fee, :conditions => " (cons_date BETWEEN '#{from_date}' AND '#{to_date}' ) AND department Like'#{@departments[i].name}' and org_code LIKE '#{org_code}%'")
				@consultation_visit[i]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit BETWEEN '#{from_date}' AND '#{to_date}' AND department Like'#{@departments[i].name}' and org_code LIKE '#{org_code}%'")
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
				@consultation[k]=(ApptPayment.sum(:fee, :conditions => "(cons_date LIKE '#{sel_year}-#{month_first_day[z].to_s}-%') AND department LIKE '#{department}%' and org_code LIKE '#{org_code}%'")).to_f
				@consultation_visit[k]=(ConsultantVisit.sum(:charge, :conditions => "(date_of_visit LIKE '#{sel_year}-#{month_first_day[z].to_s}-%') AND department LIKE '#{department}%' and org_code LIKE '#{org_code}%'")).to_f
				puts @consultation_visit[k]
				k=k+1
			end
		
		else
			@departments=DepartmentMaster.find(:all, :conditions => "org_code LIKE '#{params[:org_code]}%'")
			for i in 0...@departments.length
				label[i]=@departments[i].name
				k=0
				for z in 0...12
							if(z<10)
							@consultation[i]=ApptPayment.sum(:fee, :conditions => " cons_date LIKE '#{sel_year}-#{month_first_day[z].to_s}-%' AND department = '#{@departments[i].name}' and org_code LIKE '#{org_code}%'")
							@consultation_visit[i]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{sel_year}-#{month_first_day[z].to_s}-%' AND department = '#{@departments[i].name}' and org_code LIKE '#{org_code}%'")
							else
							@consultation[i]=ApptPayment.sum(:fee, :conditions => " cons_date LIKE '#{sel_year}-#{month_first_day[z].to_s}-%' AND department = '#{@departments[i].name}' and org_code LIKE '#{org_code}%'")
							@consultation_visit[i]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{sel_year}-#{month_first_day[z].to_s}-%' AND department = '#{@departments[i].name}' and org_code LIKE '#{org_code}%'")
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
			@consultation[0]=ApptPayment.sum(:fee, :conditions => " cons_date LIKE '#{year.to_s}-%-%' AND department = '#{department}' and org_code LIKE '#{org_code}%'")
			@consultation_visit[0]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{year.to_s}-%-%' AND department = '#{department}' and org_code LIKE '#{org_code}%'")
		else
			@departments=DepartmentMaster.find(:all, :conditions => "org_code LIKE '#{params[:org_code]}%'")
			for i in 0...@departments.length
				label[i]=@departments[i].name
				@consultation[i]=ApptPayment.sum(:fee, :conditions => " cons_date LIKE '#{year.to_s}-%-%' AND department = '#{@departments[i].name}' and org_code LIKE '#{org_code}%'")
				@consultation_visit[i]=ConsultantVisit.sum(:charge, :conditions => " date_of_visit LIKE '#{year.to_s}-%-%' AND department = '#{@departments[i].name}' and org_code LIKE '#{org_code}%'")
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
  
  
   def two
	registration = Line.new(2, '#9933CC')
	registration.key('Registrations', 10)

	consultation = LineHollow.new(2,5,'#CC3399')
	consultation.key("Consultations",10)
	
	opbilling = LineHollow.new(2,5,'#00d100')
	opbilling.key("Opbilling",10)
	
	ip = LineHollow.new(2,5,'#000000')
	ip.key("IP",10)
	
	dues = LineHollow.new(2,5,'#0b70fc')
	dues.key("Dues",10)
	time = Time.new
	big_value=0
	v=TransferData.new
	from_year,to_year,org_code=v.return_year
	
    	month_first_day=["01-01","02-01","03-01","04-01","05-01","06-01","07-01","08-01","09-01","10-01","11-01","12-01"]
   	month_last_day=["01-31","02-28","03-31","04-30","05-31","06-30","07-31","08-31","09-30","10-31","11-30","12-31"]
	for i in 0...12 
		patient=Registration.sum(:reg_fee, :conditions => " (reg_date BETWEEN '#{time.year.to_s}-#{month_first_day[i]}' AND '#{time.year.to_s}-#{month_last_day[i]}') and org_code LIKE '#{org_code}%'").to_i
		registration.add_data_tip(patient,"(Extra: #{i})")
		con=ApptPayment.sum(:fee, :conditions => " (cons_date BETWEEN '#{time.year.to_s}-#{month_first_day[i]}' AND '#{time.year.to_s}-#{month_last_day[i]}') and org_code LIKE '#{org_code}%'").to_i
		consultation.add_data_tip(con,"(Extra: #{i})")
		op=OpBilling.sum(:receipt_amount, :conditions => "(bill_date BETWEEN '#{time.year.to_s}-#{month_first_day[i]}' AND '#{time.year.to_s}-#{month_last_day[i]}') and org_code LIKE '#{org_code}%'").to_i
		opbilling.add_data_tip(op,"(Extra: #{i})")
		ip_payments=AdvancePayment.sum(:gross_amount, :conditions => "(advance_date BETWEEN '#{time.year.to_s}-#{month_first_day[i]}' AND '#{time.year.to_s}-#{month_last_day[i]}') and org_code LIKE '#{org_code}%'")+FinalBill.sum(:paid_amount, :conditions => " (final_bill_date BETWEEN '#{time.year.to_s}-#{month_first_day[i]}' AND '#{time.year.to_s}-#{month_last_day[i]}') and org_code LIKE '#{org_code}%'").to_i
		ip.add_data_tip(ip_payments,"(Extra: #{i})")
		due=OpDue.sum(:paid_amount, :conditions => " (payment_date BETWEEN '#{time.year.to_s}-#{month_first_day[i]}' AND '#{time.year.to_s}-#{month_last_day[i]}') and org_code LIKE '#{org_code}%'").to_i
		dues.add_data_tip(due,"(Extra: #{i})")	
		if(big_value<patient)
			big_value=patient
		end
		if(big_value<con)
			big_value=con
		end
		if(big_value<op)
			big_value=op
		end
		if(big_value<ip_payments)
			big_value=ip_payments
		end
		if(big_value<due)
			big_value=due
		end
	end
	g = Graph.new
  	g.title("Finance", '{font-size: 26px;}')
  	g.data_sets << registration
  	g.data_sets << consultation
  	g.data_sets << opbilling
  	g.data_sets << ip
  	g.data_sets << dues
    	g.line(2,'0x80a033','Spoon Sale', 10)
  	g.set_x_labels(%w(Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec))
  	round_value=((big_value+(big_value/3))-((big_value+(big_value/3))%10))
  	g.set_y_max(round_value)
  	g.set_y_label_steps(10)
  	render :text => g.render
  end
  
 
  def year_graph
	registration = Line.new(2, '#9933CC')
	registration.key('Registrations', 10)
	consultation = LineHollow.new(2,5,'#CC3399')
	consultation.key("Consultations",10)
	opbilling = LineHollow.new(2,5,'#00d100')
	opbilling.key("Opbilling",10)
	
	ip = LineHollow.new(2,5,'#000000')
	ip.key("IP",10)
	
	dues = LineHollow.new(2,5,'#0b70fc')
	dues.key("Dues",10)
	time = Time.new
	big_value=0
	v=TransferData.new
	from_year,to_year,org_code=v.return_year
    	from=from_year.to_i
	to=to_year.to_i
	year_data=Array.new
	for i in from..to 
		patient=Registration.sum(:reg_fee, :conditions => "(reg_date BETWEEN '#{i.to_s}-01-01' AND '#{i.to_s}-12-31') and org_code LIKE '#{org_code}%'").to_i
		registration.add_data_tip(patient,"(Extra: #{i})")
		con=ApptPayment.sum(:fee, :conditions => " (cons_date BETWEEN '#{i.to_s}-01-01' AND '#{i.to_s}-12-31') and org_code LIKE '#{org_code}%'").to_i
		consultation.add_data_tip(con,"(Extra: #{i})")
		op=OpBilling.sum(:receipt_amount, :conditions => "(bill_date BETWEEN '#{i.to_s}-01-01' AND '#{i.to_s}-12-31') and org_code LIKE '#{org_code}%'").to_i
		opbilling.add_data_tip(op,"(Extra: #{i})")
		ip_payments=AdvancePayment.sum(:gross_amount, :conditions => " (advance_date BETWEEN '#{i.to_s}-01-01' AND '#{i.to_s}-12-31') and org_code LIKE '#{org_code}%'")+FinalBill.sum(:paid_amount, :conditions => " (final_bill_date BETWEEN '#{i.to_s}-01-01' AND '#{i.to_s}-12-31') and org_code LIKE '#{org_code}%'").to_i
		ip.add_data_tip(ip_payments,"(Extra: #{i})")
		due=OpDue.sum(:paid_amount, :conditions => " (payment_date BETWEEN '#{i.to_s}-01-01' AND '#{i.to_s}-12-31') and org_code LIKE '#{org_code}%'").to_i
		dues.add_data_tip(due,"(Extra: #{i})")	
		year_data[i-from]= i
		if(big_value<patient)
			big_value=patient
		end
		if(big_value<con)
			big_value=con
		end
		if(big_value<op)
			big_value=op
		end
		if(big_value<ip_payments)
			big_value=ip_payments
		end
		if(big_value<due)
			big_value=due
		end
	end
	
	g = Graph.new
  	g.title("Finance", '{font-size: 26px;}')
  	g.data_sets << registration
  	g.data_sets << consultation
  	g.data_sets << opbilling
  	g.data_sets << ip
  	g.data_sets << dues
    	g.line(2,'0x80a033','Spoon Sale', 10)
  	g.set_x_labels(year_data)
  	round_value=((big_value+(big_value/3))-((big_value+(big_value/3))%10))
  	g.set_y_max(round_value)
  	g.set_y_label_steps(10)
  	render :text => g.render
  end



  def pie_links
 	label=Array.new
	data = []
   
	type=params[:type].to_s
	time = Time.new
	data << Registration.sum(:reg_fee, :conditions => " reg_date Like '%-#{time.month.to_s}-%'")
	data << ApptPayment.sum(:fee, :conditions => " cons_date Like '%-#{time.month.to_s}-%'").to_f
	data << OpBilling.sum(:receipt_amount, :conditions => " bill_date Like '%-#{time.month.to_s}-%'").to_f
	data << AdvancePayment.sum(:gross_amount, :conditions => " advance_date Like '%-#{time.month.to_s}-%'")+FinalBill.sum(:paid_amount, :conditions => " final_bill_date Like '%-#{time.month.to_s}-%'")
	data << OpDue.sum(:paid_amount, :conditions => " payment_date Like '%-#{time.month.to_s}-%'").to_f+ IpDue.sum(:remaining_amount, :conditions => " due_date Like '%-#{time.month.to_s}-%'").to_f
	
	g = Graph.new
	g.pie(60, '#505050', '{font-size: 12px; color: #404040;}')
	g.pie_values(data, %w(Registrations Consultations OPbilling IP Dues))
	g.pie_slice_colors(%w(#d01fc3 #356aa0 #c79810 #8e468e #00ffff))
	g.set_tool_tip("#val#")
  	g.set_bg_color('#ecf3f7')
  	g.title("Financial Report", '{font-size:13px; color: black}' )
  	render :text => g.render
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
			consultationforms[i] = ApptPayment.sum(:paid_amount,:conditions => "cons_date Like '#{time.year.to_s}-#{mon}-%' and consultant_id = '#{@doctor[i].consultant_id}' and org_code LIKE '#{org_code}%'").to_f
			consultants[i]=@doctor[i].name
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
				consultationforms[i] = ApptPayment.sum(:paid_amount,:conditions => "cons_date Like '#{time.year.to_s}-#{mon}-%' and consultant_id = '#{@doctor[i].consultant_id}' and org_code LIKE '#{people.org_code}%'").to_f
				consultants[i]=@doctor[i].name+"<br/>"+people.org_code
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
				dep_consultationforms[i] = ApptPayment.sum(:paid_amount,:conditions => "cons_date Like '#{dep_time.year.to_s}-#{dep_time_mon}-%' and department = '#{@department[i].name}' and org_code LIKE '#{org_code}%'").to_f
				dep_consultants[i]=@department[i].name
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
					dep_consultationforms[i] = ApptPayment.sum(:paid_amount,:conditions => "cons_date Like '#{dep_time.year.to_s}-#{dep_time_mon}-%' and department = '#{@department[i].name}' and org_code LIKE '#{people.org_code}%'").to_f
					dep_consultants[i]=@department[i].name+"<br/>"+people.org_code
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
			@patient_visit[0]= ApptPayment.find(:all,:conditions => "cons_date Like '#{patient_visit_time.year.to_s}-#{patient_visit_time_mon}-%' and org_code LIKE '#{org_code}%'").length
			@visit_org[0]='Patient Visits '
		else
			@people=Person.find(:all,:select => "DISTINCT org_code")
			total=0
			for people in @people
				@patient_visit[total]= ApptPayment.find(:all,:conditions => "cons_date Like '#{patient_visit_time.year.to_s}-#{patient_visit_time_mon}-%' and org_code LIKE '#{org_code}%'").length
				@visit_org[total]='Patient Visits'+"<br/>"+ people.org_code
				total=total+1
			end
		end	
  end  
 
   
  def doctor_chart_representation
   headers["content-type"]="text/html";
	 consultationforms=Array.new
	  fee=Array.new
	  consultants=Array.new
	  consultant_names=Array.new
	  time = Time.new
	@doctor=Doctormaster.find(:all, :conditions => "consulting_type = 'OP' OR consulting_type= 'Both'")
	for i in 0...@doctor.length
		consultationforms[i] = Consultationform.sum(:fee,:conditions => "cons_date Like '%-#{time.month.to_s}-%' and consultant = '#{@doctor[i].name}'").to_f
		consultants[i]=@doctor[i].name
	end
	for j in 0...5
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
		fee[j]=consultationforms[j]
		consultant_names[j]=consultants[j]
	end
	@doctors_info = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :w => 500, :labels => consultant_names)
	@doctors_info.data = { "Fee" => fee }
	@doctors_info.labels = consultant_names
  end
  
  
  def department_chart_representation1
  
   headers["content-type"]="text/html";
    consultationforms=Array.new
	  fee=Array.new
	  consultants=Array.new
	  consultant_names=Array.new
	  time = Time.new
	@department=Departmentmaster.find(:all)
	for i in 0...@department.length
		consultationforms[i] = ApptPayment.sum(:fee,:conditions => "cons_date Like '%-#{time.month.to_s}-%' and department = '#{@department[i].name}'").to_f
		consultants[i]=@department[i].name
	end
	for j in 0...5
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
		fee[j]=consultationforms[j]
		consultant_names[j]=consultants[j]
	end
	@doctors_info = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :w => 500, :labels => consultant_names)
	@doctors_info.data = { "Fee" => fee }
	@doctors_info.labels = consultant_names
  end
  
  
  def patient_visit_chart_representation
   
	 headers["content-type"]="text/html";
   patient_visit=Array.new
   complete_patient_visit=Array.new
   to_be_patient_visit=Array.new
	month=Array.new
	time = Time.new
	@department=Departmentmaster.find(:all)
	label=["January","February","March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
	if(time.month.to_s.length==1)
		j="0"+time.month.to_s
	else
		j=time.month.to_s
	end
	
	patient_visits = ApptManagement.find(:all,:conditions => "appt_date Like '#{time.year.to_s}-#{j}-%'")
	puts patient_visits.length
	patient = ApptManagement.find(:all,:conditions => "appt_date BETWEEN '#{time.year.to_s}-#{j}-01' AND  '#{time.year.to_s}-#{j}-#{time.day.to_s}'")
	patient_visit[0]=patient_visits.length
	complete_patient_visit[0]=patient.length
	to_be_patient_visit[0]=patient_visits.length-patient.length
	month[0]=label[time.month-1]
	@patient_info = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :w => 500, :labels => month)
	@patient_info.data = { "Total Patient Visits" => patient_visit, "Completed " => complete_patient_visit, "To be Completed " =>to_be_patient_visit}
	@patient_info.labels = month
  end

  def bed_util1
       headers["content-type"]="text/html";
      @date1=params[:q]
	label=Array.new
	available_data=Array.new
	occupied_data=Array.new
	@ward=Wardmaster.find(:all)
	for i in 0...@ward.length
		label[i]=@ward[i].name
		@ward1=Bedmaster.all(:conditions => "wardmaster_id = #{@ward[i].id} and status =1")
		@ward2=Bedmaster.all(:conditions => "wardmaster_id = #{@ward[i].id} and status =0")
		available_data[i]=@ward1.length
		occupied_data[i]=@ward2.length
	end
	@mcol3d = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :w => 500, :labels => label)
	@mcol3d.data = { "Available" => available_data, "Occupied " => occupied_data}
	@mcol3d.labels = label
  end

 
  
  
  def patient_visit_day_chart_representation
   
	headers["content-type"]="text/html";
   	patient_visit=Array.new
   	complete_patient_visit=Array.new
   	to_be_patient_visit=Array.new
	month=Array.new
	time = Time.new
	if(time.month.to_s.length==1)
		j="0"+time.month.to_s
	else
		j=time.month.to_s
	end
       patient_visits = AppointmentManagement.find(:all,:conditions => "appt_date = '#{time.year.to_s}-#{j}-#{time.day.to_s}'")
	   puts patient_visits[0]
	   puts "indra"
	if( patient_visits[0])
		patient = AppointmentManagement.find(:all,:conditions => "appt_date = '#{time.year.to_s}-#{j}-#{time.day.to_s}' AND  appt_status='Closed'")
		patient_visit[0]=patient_visits.length
		complete_patient_visit[0]=patient.length
		to_be_patient_visit[0]=patient_visits.length-patient.length
		month[0]=time.strftime("%d-%b-%Y").to_s
		@patient_info = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :caption => "Patient Visits", :w => 600, :h => 300, :x_name=>'Day', :y_name=>'No.of Patients', :background => 'ecf3f7', :div_line_precision=>'0', :precision =>'0', :f_number_scale=>'0')
		@patient_info.data = { "Total Patient Visits" => patient_visit, "Completed " => complete_patient_visit, "To be Completed " =>to_be_patient_visit}
		@patient_info.labels = month
	else
		@patient_info = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :caption => "Patient Visits", :w => 600, :h => 300, :x_name=>'Day', :y_name=>'No.of Patients', :background => 'ecf3f7', :div_line_precision=>'0', :precision =>'0', :f_number_scale=>'0')
		@patient_info.labels = month
	end
  end
  
  def next_visit_chart_representation
 
	 headers["content-type"]="text/html";
   patient_visit=Array.new
   complete_patient_visit=Array.new
   to_be_patient_visit=Array.new
	month=Array.new
	time = Time.new
	if(time.month.to_s.length==1)
		j="0"+time.month.to_s
	else
		j=time.month.to_s
	end
	complete_patient_visit[0]=0
	daily_drug_requisations=TreatmentPlan.find(:all, :conditions => " next_visit LIKE '#{time.year.to_s}-#{j}-%'")
	
	patient_visit[0]=daily_drug_requisations.length
	for i in 0...daily_drug_requisations.length
		patient_visits = ApptManagement.last(:conditions => "appt_date >= '#{daily_drug_requisations[i].next_visit}' AND mr_no = '#{daily_drug_requisations[i].mr_no}'")
		if(patient_visits)
			complete_patient_visit[0]=complete_patient_visit[0]+1
		end
	end
	
	to_be_patient_visit[0]=patient_visit[0]-complete_patient_visit[0]
	month[0]=time.strftime("%d-%b-%Y").to_s
	@patient_info = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :w => 500, :labels => month)
	
	if(complete_patient_visit.length>0)
	
	@patient_info.data = { "Total Patient Visits" => patient_visit, "Completed " => complete_patient_visit, "To be Completed " =>to_be_patient_visit}
	@patient_info.labels = month
  end
  end
  
  def opbilling_chart_representation
	  headers["content-type"]="text/html";
      @factory_data = [] 
      #Get data from factory masters table
	  label=Array.new
      @date_array=Array.new
	  @consultation=Array.new
	  @registration=Array.new
	  @opbilling=Array.new
	 @dues=Array.new
	 @postdiscounts=Array.new
	 @refunds=Array.new
	 type=params[:type].to_s
	time = Time.new
	month_first_day=["01-01","02-01","03-01","04-01","05-01","06-01","07-01","08-01","09-01","10-01","11-01","12-01"]
	month_last_day=["01-31","02-28","03-31","04-30","05-31","06-30","07-31","08-31","09-30","10-31","11-30","12-31"]
	@registration[0]=PatientregistrationData.sum(:reg_fee, :conditions => " reg_date Like '%-#{time.month.to_s}-%'")
	@consultation[0]=Consultationform.sum(:fee, :conditions => " cons_date Like '%-#{time.month.to_s}-%'").to_f
	@opbilling[0]=Opbilling1.sum(:receipt_amount, :conditions => " bill_date Like '%-#{time.month.to_s}-%'").to_f
	
	@dues[0]=Duespagemaster.sum(:paid_amount, :conditions => " payment_date Like '%-#{time.month.to_s}-%' AND billing_mode='opbilling'").to_f
	@postdiscounts[0]=Postdiscount.sum(:post_discount, :conditions => " created_at Like '%-#{time.month.to_s}-%' AND billing_mode='opbilling'").to_f
	@refunds[0]=Refundmaster.sum(:refund, :conditions => " refund_date Like '%-#{time.month.to_s}-%' AND billing_mode='opbilling'").to_f
	label=[time.month.to_s]
	@mcol3d = Ezgraphix::Graphic.new(:div_name => 'pie3d', :c_type => 'pie3d', :caption => "OP Revenues", :w => 500, :h => 300, :background => 'ecf3f7')
	@mcol3d.data = { "Registrations" => @registration, "Consultations" => @consultation, "OPbilling" => @opbilling,"Dues" => @dues, "Post Discounts" => @postdiscounts, "Refunds" => @refunds }
	@mcol3d.labels = label




label1=Array.new
    @refunds1=Array.new
 @final_bill1=Array.new
 @ip1=Array.new
 @dues1=Array.new
 time1 = Time.new
 @ip1[0]=Ipadvance.sum(:gross_amount, :conditions => " advance_date Like '#{time1.year.to_s}-#{time1.month.to_s}-%'")
 @final_bill1[0]=FinalBill.sum(:paid_amount, :conditions => " bill_date Like '#{time1.year.to_s}-#{time1.month.to_s}-%'")
 @dues1[0]=Duespagemaster.sum(:paid_amount, :conditions => " payment_date Like '#{time1.year.to_s}-#{time1.month.to_s}-%' AND billing_mode= 'IP'").to_f
 @refunds1[0]=PreRefund.sum(:refund, :conditions => " created_at Like '#{time1.year.to_s}-#{time1.month.to_s}-%'")
 label1[0]=time.month.to_s
 @mcol3d1 = Ezgraphix::Graphic.new(:div_name => 'pie3d1', :c_type => 'pie3d', :caption => "IP Revenues", :w => 500, :h => 300, :background => 'ecf3f7')
 @mcol3d1.data = { "Advances" => @ip1, "Final Bill" => @final_bill1, "Dues" => @dues1, "Refunds" => @refunds1 }
 @mcol3d1.labels = label1
	
  end
  
  
  def payment_search
	d3=params[:date1]
	d4=params[:date2]
	@department=params[:department]
	
	org_code=params[:org_code]
	@date_array=Array.new
	
	if(@department=="no" && d3!="no" && d4!="no")
		
		date_diff=d4.to_date-d3.to_date
		for i in 0..date_diff
			@date_array[i]=d3+i.to_s
		end
		
	elsif(@department!="no" && d3=="no" && d4=="no")
		@doctor=ConsultantMaster.find(:all, :conditions => " dept_code = '#{@department}' and org_code Like '#{org_code}%'")
		@date_array[0]=Date.today
	else
		
		@doctor=ConsultantMaster.find(:all, :conditions => " dept_code = '#{@department}' and org_code Like '#{org_code}%'")
		
		date_diff=d4.to_date-d3.to_date
		for i in 0..date_diff
			@date_array[i]=d3.to_date+i
		end
	end
	render :partial => "payment_history"
    
  end
  
  
  def date_range
		from_date=params[:from_date]
		to_date=params[:to_date]
		org_code=params[:org_code]
		$data=["next_visit BETWEEN ? AND ? AND org_code Like'#{org_code}%'",from_date,to_date]
		@treatment=TreatmentPlan.find(:all, :conditions => $data)
		if(@treatment)
			render :partial => "dailydrug_report"
		else
			render :text => "Not Match"
		end
	end
	
  def generate_report
		
		pdf = DailyDrugRequisationReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
                :filename => "dailydrug.csv"
   end	
   
  def revenue_graph_report
 time = Time.new
 @user_id=params[:user_id]
 @registration=Registration.find(:all,:conditions => "org_code = '#{params[:org_code]}' and reg_date like '%-#{time.month.to_s}-%'")
 @ward=WardMaster.find(:all,:conditions => "org_code = '#{params[:org_code]}'")
 @appointment=AppointmentManagement.find(:all,:conditions => "org_code = '#{params[:org_code]}' and appt_date LIKE '%-#{time.month.to_s}-%' and appt_type='OP'")
 @appointment_complete=AppointmentManagement.find(:all,:conditions => "org_code = '#{params[:org_code]}' and appt_date LIKE '%-#{time.month.to_s}-%' and appt_type='OP' and appt_status='Closed'")
 @doctor=ConsultantMaster.find(:all, :conditions => "(charge_type = 'OP' OR charge_type= 'Both') and org_code='#{params[:org_code]}'")
 @consultationforms=Array.new
 @consultants=Array.new
 for i in 0...@doctor.length
  @consultationforms[i] = ApptPayment.sum(:fee,:conditions => "cons_date Like '%-#{time.month.to_s}-%' and consultant_id = '#{@doctor[i].name}'").to_f
  @consultants[i]=@doctor[i].name
  j=i-1
  while(j>=0)
  
   if(@consultationforms[j]>@consultationforms[i])
    temp=consultationforms[j]
    @consultationforms[j]=@consultationforms[i]
    @consultationforms[i]=temp
    
    name=@consultants[j]
    @consultants[j]=@consultants[i]
    @consultants[i]=name
   else 
    break
   end
   j-=1
  end
 end
 @consultation_values=@consultationforms.reverse!
 @consultant_names=@consultants.reverse!
 
 @depart_forms1=Array.new
 @depart_forms_name1=Array.new
 
 @department=DepartmentMaster.find(:all, :conditions => "org_code='#{params[:org_code]}'")
 
 for i in 0...@department.length
  
  @depart_forms1[i] = ApptPayment.sum(:fee,:conditions => "cons_date Like '%-#{time.month.to_s}-%' and department = '#{@department[i].name}'").to_f
  @depart_forms_name1[i]=@department[i].name
  j=i-1
  while(j>=0)
   if(@depart_forms1[j]>@depart_forms1[i])
    temp=@depart_forms1[j]
    @depart_forms1[j]=@depart_forms1[i]
    @depart_forms1[i]=temp
    dept_name=@depart_forms_name1[j]
    @depart_forms_name1[j]=@depart_forms_name1[i]
    @depart_forms_name1[i]=dept_name
   else 
    break
   end
   j-=1
  end
 end
 @depart_forms=@depart_forms1.reverse!
 @depart_forms_name=@depart_forms_name1.reverse!
  end
  
 def bed_select1
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
	
	if(@bed.status=="Occupied")
		 @occupied_data[0]=BedMaster.find(:all, :conditions => "room_master_id = '#{@room.id}' AND status = 'Occupied'")
	elsif(@bed.status=="Available")
		@available_data1[0]=BedMaster.find(:all, :conditions => "room_master_id = '#{@room.id}' AND org_code= '#{@org_code}' AND status = 'Available'")
	elsif(@bed.status=="Un-Available")
		@un_available[0]=BedMaster.find(:all, :conditions => "room_master_id = '#{@room.id}' AND org_code= '#{@org_code}' AND status = 'Un-Available'")	
	end
	j=1
	i=1
	z=1
		@label[0]=@ward.name
		bedmasters=BedMaster.find(:all, :conditions => "room_master_id = '#{@room.id}' AND org_code = '#{@org_code}'")
			for bed in bedmasters
				@admission=Admission.find_by_bed_and_room_and_org_code(bed.name,@room.code,@org_code)
				if(@admission)
					@discharge=DischargeIntimation.find_by_admn_no_and_org_code(@admission.admn_no,@org_code)
					if(@discharge)
						@available_data[0]=i
						i+=1
					else
						@un_available[0]=z
						z+=1
					end
				end	
					@available_data1[0]=j
					j+=1
			end
		
		@mcol3d = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :caption => "Bed", :w => 400, :x_name=>'Ward Names', :y_name=>'Beds', :background => 'ecf3f7', :div_line_precision=>'0', :precision =>'0', :f_number_scale=>'0', :line => 'red')
		@mcol3d.data = { "Available" => @available_data1, "To Be Available" => @available_data, "Occupied " => @un_available}
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
  
   def financial_chart_representation1 

	@from_date=params[:from_date]

	@names=['Registrations','Consultations','Opbilling','IP','Due']
	@org_code=params[:org_code]
	@to_date=params[:to_date]
	@revenue_type=params[:revenue_type]
	month=params[:month]

	headers["content-type"]="text/html";
	i=0
	@total=0
	@total_amount=0
	@array=Array.new
	@array1=Array.new
	@array2=Array.new 
	@array3=Array.new
	@array4=Array.new
	@reg=0
	@appt=0
	@op_bill=0
	@advance=0
	@finalbill=0
 
	if(@revenue_type=="Weekly")
	
		for j in @from_date.to_date...@to_date.to_date
				@array[i]=Registration.sum(:reg_fee, :conditions => " reg_date = '#{j.to_s}' AND org_code LIKE '#{@org_code}%'")
				@array1[i]=ApptPayment.sum(:fee, :conditions => " receipt_date = '#{j.to_s}' AND org_code LIKE '#{@org_code}%'")
				@array2[i]=OpBilling.sum(:receipt_amount, :conditions => " bill_date = '#{j.to_s}' AND org_code LIKE '#{@org_code}%'") 
				@array3[i]=AdvancePayment.sum(:gross_amount, :conditions => " advance_date = '#{j.to_s}' AND org_code LIKE '#{@org_code}%'")
				@array4[i]=FinalBill.sum(:paid_amount, :conditions => " final_bill_date = '#{j.to_s}' AND org_code LIKE '#{@org_code}%'")
				
				i+=1
		end 
		
	elsif(@revenue_type=="Monthly")	
		
		time = Time.new
		year=params[:year]
	
		month_first_day=["01-01","02-01","03-01","04-01","05-01","06-01","07-01","08-01","09-01","10-01","11-01","12-01"]
		month_last_day=["01-31","02-28","03-31","04-30","05-31","06-30","07-31","08-31","09-30","10-31","11-30","12-31"]
		month={"Jan" => 01,"Feb" => 02,"Mar" => 03,"Apr" => 04,"May" => 05,"Jun" => 06,"Jul" => 07,"Aug" => 8,"Sep" => 9,"Oct" =>10,"Nov" =>11,"Dec" =>12}
		
		@month=month[params[:month]]
	  k=0
	for j in 1...13
		puts "hi"	    
		if(j<10)
		@array[k]=Registration.sum(:reg_fee, :conditions => " reg_date LIKE '#{year.to_s}-0#{j}-%'  AND org_code LIKE '#{@org_code}%'")
		@array1[k]=ApptPayment.sum(:fee, :conditions => " receipt_date LIKE '#{year.to_s}-0#{j}-%'  AND org_code LIKE '#{@org_code}%'")
		@array2[k]=OpBilling.sum(:receipt_amount, :conditions => " bill_date LIKE '#{year.to_s}-0#{j}-%'  AND org_code LIKE '#{@org_code}%'")
		@array3[k]=AdvancePayment.sum(:gross_amount, :conditions => " advance_date LIKE '#{year.to_s}-0#{j}-%'  AND org_code LIKE '#{@org_code}%'")
		@array4[k]=FinalBill.sum(:paid_amount, :conditions => " final_bill_date LIKE '#{year.to_s}-0#{j}-%'  AND org_code LIKE '#{@org_code}%'")
	    else
		@array[k]=Registration.sum(:reg_fee, :conditions => " reg_date LIKE '#{year.to_s}-#{j}-%'  AND org_code LIKE '#{@org_code}%'")
		@array1[k]=ApptPayment.sum(:fee, :conditions => " receipt_date LIKE '#{year.to_s}-#{j}-%'  AND org_code LIKE '#{@org_code}%'")
		@array2[k]=OpBilling.sum(:receipt_amount, :conditions => " bill_date LIKE '#{year.to_s}-#{j}-%'  AND org_code LIKE '#{@org_code}%'")
		@array3[k]=AdvancePayment.sum(:gross_amount, :conditions => " advance_date LIKE '#{year.to_s}-#{j}-%'  AND org_code LIKE '#{@org_code}%'")
		@array4[k]=FinalBill.sum(:paid_amount, :conditions => " final_bill_date LIKE '#{year.to_s}-#{j}-%'  AND org_code LIKE '#{@org_code}%'")
	   end
		k=k+1
    end		
	elsif(@revenue_type=="Yearly")
		@year=params[:year]
		@array[0]=Registration.sum(:reg_fee, :conditions => " reg_date LIKE '#{@year}-%-%'  AND org_code LIKE '#{@org_code}%'")
		@array1[0]=ApptPayment.sum(:fee, :conditions => " receipt_date LIKE '#{@year}-%-%'  AND org_code LIKE '#{@org_code}%'")
		@array2[0]=OpBilling.sum(:receipt_amount, :conditions => " bill_date LIKE '#{@year}-%-%'  AND org_code LIKE '#{@org_code}%'")
		@array3[0]=AdvancePayment.sum(:gross_amount, :conditions => " advance_date LIKE '#{@year}-%-%'  AND org_code LIKE '#{@org_code}%'")
		@array4[0]=FinalBill.sum(:paid_amount, :conditions => " final_bill_date LIKE '#{@year}-%-%'  AND org_code LIKE '#{@org_code}%'")
	end
 end
 
def corporate_deptrevenue_revenue
 	 
	@label=Array.new
	@date_array=Array.new
	@consultation=Array.new
	@type=params[:type].to_s
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
				@to_date=params[:to_date]
				
				for department in @department
					@label[i]=department.name
					l=0
					for j in @from_date.to_date..@to_date.to_date
						date=j.to_s
						spl_date=date.split("-")
						@dates[l]=spl_date[2].to_s
			    			@consultation[k]=ConsultantPayment.sum(:paid_amt, :conditions => " date = '#{j.to_s}' AND  department='#{department.name}' and org_code LIKE '#{org_code}%'")
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
				for department in @department
					@label[i]=department.name
					for j in 1...13
						if(j<10)
				    			@consultation[k]=ConsultantPayment.sum(:paid_amt, :conditions => " date LIKE '#{year.to_s}-0#{j}-%' AND  department='#{department.name}' and org_code LIKE '#{org_code}%'")
						else
							@consultation[k]=ConsultantPayment.sum(:paid_amt, :conditions => " date LIKE '#{year.to_s}-#{j}-%' AND  department='#{department.name}' and org_code LIKE '#{org_code}%'")
						end
						k=k+1
					end
					i=i+1
				end
			elsif(@type=="Yearly")
				@from_year=params[:year]
				@to_year=params[:to_year]
				@department=DepartmentMaster.find(:all, :conditions =>" org_code LIKE '#{org_code}%'")
				for department in @department
					@label[i]=department.name
					for j in @from_year.to_i..@to_year.to_i
			    			@consultation[k]=ConsultantPayment.sum(:paid_amt, :conditions => " date LIKE '#{j.to_s}-%-%' AND  department='#{department.name}' and org_code LIKE '#{org_code}%'")
						puts @consultation[k]
						puts j
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
				@consultation[k]=ConsultantPayment.sum(:paid_amt, :conditions => " date = '#{j.to_s}' AND  department='#{department}' and org_code LIKE '#{org_code}%'")
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
		    			@consultation[k]=ConsultantPayment.sum(:paid_amt, :conditions => " date LIKE '#{year.to_s}-0#{j}-%' AND  department='#{department}' and org_code LIKE '#{org_code}%'")
				else
					@consultation[k]=ConsultantPayment.sum(:paid_amt, :conditions => " date LIKE '#{year.to_s}-#{j}-%' AND  department='#{department}' and org_code LIKE '#{org_code}%'")
				end
				k=k+1
			end
		elsif(@type=="Yearly")
			@from_year=params[:year]
			@to_year=params[:to_year]
			@label[i]=department
			for j in @from_year.to_i..@to_year.to_i
				@consultation[k]=ConsultantPayment.sum(:paid_amt, :conditions => " date LIKE '#{j.to_s}-%-%' AND  department='#{department}' and org_code LIKE '#{org_code}%'")
				k=k+1
			end
		end	
	
	end
end

  def select_org_code
	person=Person.find_by_org_code(params[:org_code])
	render :text => person.org_location
  end

  def select_consultants
	@consultant=ConsultantMaster.find(:all, :conditions => "org_code LIKE '#{params[:org_code]}%'")
	str=""
	for consultant in @consultant
		str<<consultant.name+"<division>"
	end
	render :text => str
  end

  def select_departments
	@departments=DepartmentMaster.find(:all, :conditions => "org_code LIKE '#{params[:org_code]}%'")
	str=""
	for departments in @departments
		str<<departments.name+"<division>"
	end
	render :text => str
  end

end


