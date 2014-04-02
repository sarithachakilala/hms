class ReportsController < ApplicationController
  def consultant_visits
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	consultant=ConsultantMaster.all(:conditions => "charge_type = 'Both'")
	@consultant=Array.new
	i=0
	for con in consultant
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		@consultant[i]=con.consultant_id+"-"+employee.name
		i=i+1
	end
  end

  def consultant_visit_results
	@from_date=params[:from_date]
	@to_date=params[:to_date]
	consultant=ConsultantMaster.find_by_consultant_id(params[:consultant])
	employee=EmployeeMaster.find_by_empid(params[:consultant])
	@patient_type=params[:patient_type]
	@total=0
	if(params[:patient_type]=="OP" || params[:patient_type]=="Both")
		@appt_payments=AppointmentPayment.find(:all,:conditions => "(appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{params[:consultant]}%'")
		@total=AppointmentPayment.sum(:paid_amount,:conditions => "(appt_date BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and consultant_id LIKE '#{params[:consultant]}%'")
	end
	if(params[:patient_type]=="IP" || params[:patient_type]=="Both")
		@consultant=ConsultantVisitChild.find(:all,:conditions => "(created_at	 BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and cons_name LIKE '#{params[:consultant_id]}%'")	
		@total=@total+ConsultantVisitChild.sum(:charge,:conditions => "(created_at BETWEEN '#{params[:from_date]}' and '#{params[:to_date]}') and cons_name LIKE '#{params[:consultant_id]}%'")	
	end
	@t=Time.now
	prawnto :prawn => {
      :page_size => 'A4',
      :left_margin => 10,
      :right_margin => 0,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "opp.pdf"

    render :layout => false
  end
  
  def find_revenues

    	@org_code=params[:org_code]
	@revenue_type=params[:revenue_type]
	@from_date=params[:from_date]
	@to_date=params[:to_date]


	render :partial => "revenue_result"
  end 
def revenue_details
       @date1=params[:date1]
	@date2=params[:date2]
	@org_code=params[:org_code]
	@revenue_type=params[:revenue_type]
	
	if(@revenue_type=="OP" )
		@appt_payments=AppointmentPayment.find(:all, :conditions => " (appt_date >= '#{@date1}' AND appt_date <= '#{@date2}') AND org_code LIKE '#{@org_code}%'")
	    @test_bookings=TestBooking.find(:all, :conditions => "(booking_date >= '#{@date1}' AND booking_date <= '#{@date2}') AND org_code LIKE '#{@org_code}%'")
	elsif(@revenue_type=="IP")
		@ipadvances=AdvancePayment.find(:all, :conditions => " (advance_date >= '#{@date1}' AND advance_date <= '#{@date2}') AND org_code LIKE '#{@org_code}%'")
		@final_bills=FinalBill.find(:all, :conditions => " (final_bill_date >='#{@date1}' AND final_bill_date <= '#{@date2}') AND org_code LIKE '#{@org_code}%'")
	elsif(@revenue_type=="Dues")
		@dues=IpDue.find(:all, :conditions => " due_date >= '#{@date1}' AND due_date <= '#{@date2}'")
	end
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admission }
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
	
	elsif(@option=="IP")
		@data=["(final_bill_date BETWEEN ? AND ? ) AND org_code = ?",@date1,@date2,@org_code]
		pdf1 = FinalBillReport.render_csv(:mrno => @data)
		send_data pdf1, :type => "text/csv",
				:filename => "Advances.csv"	
	elsif(@option=="dues")
		pdf = DueRecieptReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
                :filename => "duesreciept.csv"
	elsif(@revenue_type=="OP" || @revenue_type=="consultation_due")
		@data=Consultationform.find(:all, :conditions => " cons_date BETWEEN '#{@date1}' AND '#{@date2}' AND due!=0")
		pdf = OpConsultationReport.render_csv(:mrno => @data)
		send_data pdf, :type => "text/csv",
                :filename => "consultation_due_report.csv"	
	end
  end
  
  def getdata 
  	@patient_type=params[:patient_type]
    	@org_code=params[:org_code]           
	if(@patient_type=="OP")
		render :partial => "daily_revenue"
	elsif(@patient_type=="IP")
		render :partial => "daily_revenue"
	elsif(@patient_type=="Both")
		render :partial => "daily_revenue"
	end 
  end


  def find_revenues
  
    @org_code=params[:org_code]
	@revenue_type=params[:revenue_type]
	if(params[:revenue_type]=="Custom")
		@from_date=params[:from_date]
		@to_date=params[:to_date]
		@diff=@to_date.to_date-@from_date.to_date
		if(@diff==0)
		 @diff=1
		end
	elsif(params[:revenue_type]=="Today")
		@from_date=params[:from_date]
		@to_date=params[:to_date]
		@diff=@to_date.to_date-@from_date.to_date
		if(@diff==0)
		 @diff=1
		end
		
	elsif(params[:revenue_type]=="Current Month")
	    @from_date=params[:from_date]
		@to_date=params[:to_date]
		@diff=@to_date.to_date-@from_date.to_date
		if(@diff==0)
		 @diff=1
		end
	elsif(params[:revenue_type]=="Last Month")
	    @from_date=params[:from_date]
		@to_date=params[:to_date]
		@diff=@to_date.to_date-@from_date.to_date
		if(@diff==0)
		 @diff=1
		end
	elsif(params[:revenue_type]=="Current Year")
	    @from_date=params[:from_date]
		@to_date=params[:to_date]
		@diff=@to_date.to_date-@from_date.to_date
		if(@diff==0)
		 @diff=1
		end
	elsif(params[:revenue_type]=="Last Year")
	    
		@from_date=params[:from_date]
		@to_date=params[:to_date]
		@diff=@to_date.to_date-@from_date.to_date
		if(@diff==0)
		 @diff=1
		end	
	
	end
	render :partial => "revenues_result"
  end

  def get_consultants
	consultants=ConsultantMaster.find(:all,:conditions => "charge_type = '#{params[:charge_type]}'")
	str=""
	for con in consultants
		employee=EmployeeMaster.find_by_empid(con.consultant_id)
		str<<con.consultant_id+"-"+employee.name+"<division>"
	end
	render :text => str
  end


  def test_booking_report_def
	form_date=params[:from_date]
	to_date=params[:to_date]
		
	org_code=params[:org_code]
	reffered_by=params[:reffered_by]
	@department=params[:department]
	@test=params[:test]
	@testbooking=TestBooking.find(:all, :conditions => "
				(booking_date BETWEEN '#{form_date}' AND '#{to_date}') AND
				refferal_doctor LIKE '#{reffered_by}%' AND 
				org_code LIKE '#{org_code}%'")
	render :partial => "test_booking_reporting"
    end


    def refferal_report
     
	date11=params[:from_date]
	date12=params[:to_date]
	refferal_name=params[:referal_name]
	@opbilling=Registration.find(:all, :conditions => "reg_date BETWEEN '#{date11}'AND '#{date12}' AND referral_name LIKE '#{refferal_name}%' AND referral='Referral'") 
	@tot=0
	for op in @opbilling
		@total=AppointmentPayment.sum(:paid_amount, :conditions => "mr_no= '#{op.mr_no}'")+TestBooking.sum(:paid_amount,:conditions => "mr_no= '#{op.mr_no}'")+FinalBill.sum(:paid_amount,:conditions => "mr_no= '#{op.mr_no}'")+IssuesToOp.sum(:paid_amt,:conditions => "mr_no= '#{op.mr_no}'")
		@tot=@tot+@total
	end

	@osp=TestBooking.find(:all, :conditions =>"booking_date BETWEEN '#{date11}'AND '#{date12}' AND refferal_doctor LIKE '#{refferal_name}%'")
	@ospamt=0
	for osp in @osp
		@ospamt1=TestBooking.sum(:paid_amount, :conditions =>"booking_date BETWEEN '#{date11}'AND '#{date12}' AND refferal_doctor LIKE '#{refferal_name}%'")
	 	@ospamt=@ospamt+@ospamt1
	end
	
    	@t=Time.now
     	prawnto :prawn => {
      		:page_size => 'A4',
	      	:left_margin => 10,
      		:right_margin => 0,
      		:top_margin => 10,
      		:bottom_margin => 30},
      		:filename => "sa.pdf"

    	render :layout => false
   end

   def lab_consultants
	form_date=params[:from_date]
	to_date=params[:to_date]
		
	org_code=params[:org_code]
	reffered_by=params[:reffered_by]
	@department=params[:department]
	@test=params[:test]
	@testbooking=TestBooking.find(:all, :conditions => "
				(booking_date BETWEEN '#{form_date}' AND '#{to_date}') AND
				refferal_doctor LIKE '#{reffered_by}%' AND 
				org_code LIKE '#{org_code}%'")
	prawnto :prawn => {
      		:page_size => 'A4',
	      	:left_margin => 10,
      		:right_margin => 0,
      		:top_margin => 10,
      		:bottom_margin => 30},
      		:filename => "sa.pdf"

    	render :layout => false
   end



end
