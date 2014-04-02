class BedTransfersController < ApplicationController
  # GET /bed_transfers
  # GET /bed_transfers.xml
  def index
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@bed_transfers = BedTransfer.paginate:page => params[:page] || 1, :per_page => 5, :order =>"id DESC"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bed_transfers }
    end
  end

  # GET /bed_transfers/1
  # GET /bed_transfers/1.xml
  def show
    @bed_transfer = BedTransfer.find(params[:id])
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bed_transfer }
    end
  end

  # GET /bed_transfers/new
  # GET /bed_transfers/new.xml
  def new
    @bed_transfer = BedTransfer.new
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bed_transfer }
    end
  end

  # GET /bed_transfers/1/edit
  def edit
     @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code = @person.org_code
	@org_location = @person.org_location
    	@bed_transfer = BedTransfer.find(params[:id])
	@registration=Registration.find_by_mr_no_and_org_code(@bed_transfer.mr_no,@bed_transfer.org_code)
    	@admission=Admission.find_by_admn_no_and_org_code(@bed_transfer.admn_no, @bed_transfer.org_code)
    	@patient_name=@registration.title+"."+@registration.patient_name
    	@father_name=@registration.father_name
	 @floor=@admission.floor
	 @ward=@admission.ward
	 @room=@admission.room
	 @bed=@admission.bed
  end

  
  def bed_select
	@wards=params[:q]
	@org_code=params[:org_code]
	@bed_names=Array.new
	@room_names=Array.new
	@floor_name=Array.new
	@floor=Array.new
	@cost=Array.new
	@admn_no=Array.new
	@mr_no=Array.new
	@patient_name=Array.new
	if(@wards!="")
			@ward=WardMaster.find_by_name_and_org_code(@wards,@org_code)
			@room=RoomMaster.find(:all, :conditions => "ward_master_id = '#{@ward.id}'", :select => "DISTINCT floor") 
			for room in @room
				@room_total=RoomMaster.find(:all, :conditions => "ward_master_id = '#{@ward.id}' and floor='#{room.floor}'") 
				
				
			end
	end
end


  # POST /bed_transfers
  # POST /bed_transfers.xml
  def create
    @bed_transfer = BedTransfer.new(params[:bed_transfer])
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@date=Date.today
	@bed=BedTransfer.last(:conditions => "org_code ='#{@bed_transfer.org_code}'")
			
	@admission=Admission.find_by_admn_no_and_org_code(@bed_transfer.admn_no,@bed_transfer.org_code)
	if(@admission)
		@admission.ward=@bed_transfer.to_ward
		@admission.room=@bed_transfer.to_room
		@admission.bed=@bed_transfer.to_bed
		if(@bed_transfer.transfer_type!="Temporary")
			@bedmaster=BedMaster.find_by_id(@bed_transfer.bed_id)
			@bedmaster.status = "Available"
		end
		
				
		@bedmaster1=BedMaster.find_by_id(@bed_transfer.new_bed_id)
		if(@bedmaster1)
			@bedmaster1.status = "Un-Available"
		end
	end
    respond_to do |format|
      if @bed_transfer.save
	
	  @bedmaster1.update_attributes(params[:bedmaster1])
	  if(@bed_transfer.transfer_type!="Temporary")
		  @bedmaster.update_attributes(params[:bedmaster])
	  end
	  @admission.update_attributes(params[:admission])

        format.html { redirect_to("/bed_transfers/new", :notice => 'bed_transfer was successfully created.') }
        format.xml  { render :xml => @bed_transfer, :status => :created, :location => @bed_transfer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bed_transfer.errors, :status => :unprocessable_entity }
      end
    end
	
	
	
  end

  # PUT /bed_transfers/1
  # PUT /bed_transfers/1.xml
  def update
    @bed_transfer = BedTransfer.find(params[:id])
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @bed_transfer.update_attributes(params[:bed_transfer])
        format.html { redirect_to("/bed_transfers/new", :notice => 'bed_transfer was successfully created.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bed_transfer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bed_transfers/1
  # DELETE /bed_transfers/1.xml
  def destroy
    @bed_transfer = bed_transfer.find(params[:id])
    @bed_transfer.destroy

    respond_to do |format|
      format.html { redirect_to(bed_transfers_url) }
      format.xml  { head :ok }
    end
  end
  def ajax_buildings
  	admno=params[:admn_no]
	orgcode=params[:org_code]
	@admission=Admission.find_by_id(admno)
	@doctor=EmployeeMaster.find_by_empid(@admission.consultant_id)
	@reg=Registration.find_by_mr_no_and_org_code(@admission.mr_no,orgcode)
	@bedtransfer = BedTransfer.last(:conditions => "admn_no = '#{@admission.admn_no}' and org_code = '#{orgcode}'")
	if(@bedtransfer)
		if(@bedtransfer.transfer_type=="Temporary")
			ward=WardMaster.find_by_name_and_org_code(@bedtransfer.from_ward,@bedtransfer.org_code)
			ward_pres=WardMaster.find_by_name_and_org_code(@bedtransfer.to_ward,@bedtransfer.org_code)
			@date=@bedtransfer.transfer_date
			@today=Date.today
			@day=(@today-@date.to_date).to_i
			@amount=@day*@bedtransfer.charge_per_day.to_i+@bedtransfer.amount+(ward.cost*@day)
			@days=@day
		else
			old_transfer_date=@bedtransfer.transfer_date
			ward_pres=WardMaster.find_by_name_and_org_code(@bedtransfer.to_ward,@bedtransfer.org_code)
			@date=@bedtransfer.transfer_date
			@today=Date.today
			@day=(@today-@date.to_date).to_i
			@amount=@day*@bedtransfer.charge_per_day.to_i
			@days=@day
		end
	render :json => "<script>#{@admission.admn_no}</script><script>#{@reg.mr_no}</script><script>#{@admission.admn_date}</script><script>#{@reg.title+"."+@reg.patient_name}</script><script>#{@doctor.name}</script><script>#{@admission.ward}</script><script>#{@admission.room}</script><script>#{@admission.bed}</script><script>#{@admission.floor}</script><script>#{@days.to_s}</script><script>#{@amount.to_s}</script><script>#{@admission.bed_id}</script>", :content_type => "text/html"
	elsif(@admission)
			@date=@admission.admn_date
			@today=Date.today
			@days=(@today-@date.to_date).to_i
			@cost=WardMaster.find_by_name_and_org_code(@admission.ward,orgcode)
			@charge=@cost.cost.to_i
			@amount=@days*@charge

			render :json => "<script>#{@admission.admn_no}</script><script>#{@reg.mr_no}</script><script>#{@admission.admn_date}</script><script>#{@reg.title+"."+@reg.patient_name}</script><script>#{@doctor.name}</script><script>#{@admission.ward}</script><script>#{@admission.room}</script><script>#{@admission.bed}</script><script>#{@admission.floor}</script><script>#{@days.to_s}</script><script>#{@amount.to_s}</script><script>#{@admission.bed_id}</script>", :content_type => "text/html"
	else
				render :text =>"error"
	end
	
end

	def observe_field_ex
  		@bed_transfers = BedTransfer.find(:all,:conditions=>"admn_no LIKE '%#{params[:admn_no_search]}' AND mr_no LIKE '%#{params[:mr_no_search]}' AND transfer_date LIKE '#{params[:transfer_date_search]}%' AND admn_date LIKE '#{params[:admn_date_search]}%' AND amount LIKE '#{params[:amount]}%'")
		if( @bed_transfers[0])
   			render :partial=>"bed_searching"
		else
			render :text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  
    end

end
