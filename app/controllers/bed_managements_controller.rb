class BedManagementsController < ApplicationController
  # GET /bed_managements
  # GET /bed_managements.xml
  def index
	@admissions = Admission.all
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @bed_managements = BedManagement.all
	
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @bed_managements }
    end
  end

  # GET /bed_managements/1
  # GET /bed_managements/1.xml
  def show
    @bed_management = BedManagement.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @bed_management }
    end
  end

  # GET /bed_managements/new
  # GET /bed_managements/new.xml
  def new
    @bed_management = BedManagement.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bed_management }
    end
  end

  # GET /bed_managements/1/edit
  def edit
  @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    @bed_management = BedManagement.find(params[:id])
  end

  # POST /bed_managements
  # POST /bed_managements.xml
  def create
    @bed_management = BedManagement.new(params[:bed_management])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @bed_management.save
        format.html { redirect_to(@bed_management, :notice => 'BedManagement was successfully created.') }
        format.xml  { render :xml => @bed_management, :status => :created, :location => @bed_management }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @bed_management.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /bed_managements/1
  # PUT /bed_managements/1.xml
  def update
    @bed_management = BedManagement.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      if @bed_management.update_attributes(params[:bed_management])
        format.html { redirect_to(@bed_management, :notice => 'BedManagement was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @bed_management.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /bed_managements/1
  # DELETE /bed_managements/1.xml
  def destroy
    @bed_management = BedManagement.find(params[:id])
    @bed_management.destroy
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html { redirect_to(bed_managements_url) }
      format.xml  { head :ok }
    end
  end
  
   def ajax_function
	org_code=params[:org_code]
	
	if(params[:type]=="ward")
		@ward_master=WardMaster.find_by_name_and_org_code(params[:name],org_code)
		@room_master=RoomMaster.find(:all, :conditions => " ward_master_id = '#{@ward_master.id}'")
		str=""
		for room in @room_master
			str<<room.code<<"<division>"
		end
	else
		@room_master=RoomMaster.find_by_code_and_org_code(params[:name],org_code)
		@bed_master=BedMaster.find(:all, :conditions => " room_master_id = '#{@room_master.id}'")
		str=""
		for bed_master in @bed_master
			str<<bed_master.code<<"<division>"
		end
	end
	render :text => str
  end
  def bed_select
  
  
	ward=params[:ward]
	room=params[:room]
	@org_code=params[:org_code]
	headers["content-type"]="text/html";
    @date1=params[:q]
	@label=Array.new
	@available_data=Array.new
	@available_data1=Array.new
	@occupied_data=Array.new
	@un_available=Array.new
	@beds=Array.new
	@rooms_id=Array.new
	if(@org_code!="" && ward!="" && room=="")
		@ward=WardMaster.find_by_org_code_and_name(@org_code,ward)
		@room=RoomMaster.find(:all, :conditions => " ward_master_id='#{@ward.id}' and org_code='#{@org_code}'")
		j=1
		z=1
		k=0
		@label[0]=@ward.name
		for room in @room
			bedmasters=BedMaster.find(:all, :conditions => "room_master_id = '#{room.id}' AND org_code = '#{@org_code}'")
			for bed in bedmasters
				@beds[k]=bed.name
				@rooms_id[k]=bed.room_master_id
				@admission=Admission.find_by_bed_and_room_and_org_code(bed.name,room.code,@org_code)
				if(@admission)
					@un_available[0]=z
					puts "fffffffffffffffffffffff"
					puts @un_available[0]
					z+=1
				else
					@available_data1[0]=j
					j+=1
				end
				k=k+1
			end
		end
	elsif(@org_code!="" && room!="")
		@ward=WardMaster.find_by_org_code_and_name(@org_code,ward)
		@room=RoomMaster.find_by_org_code_and_ward_master_id_and_name(@org_code,@ward.id,room)
		j=1
		z=1
		@label[0]=@ward.name
		k=0
		bedmasters=BedMaster.find(:all, :conditions => "room_master_id = '#{@room.id}' AND org_code = '#{@org_code}'")
		for bed in bedmasters
			@beds[k]=bed.name
			@rooms_id[k]=bed.room_master_id
			@admission=Admission.find_by_bed_and_room_and_org_code(bed.name,@room.code,@org_code)
			if(@admission)
				@un_available[0]=z
				z+=1
			else
				@available_data1[0]=j
				j+=1
			end
			k=k+1
		end
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
	  
  def graph
	@bed_management = BedManagement.new
	@beds=Array.new
	@ward=Wardmaster.find(:all)
	@beds[0]="All Wards"
	for i in 0...@ward.length
		@beds[i+1]=@ward[i].name
	end
  end
  def bed_util1
    headers["content-type"]="text/html";
    @date1=params[:q]
	label=Array.new
	@available_data=Array.new
	@occupied_data=Array.new
	if(params[:ward] && params[:ward]!="All Wards")
		@ward=Wardmaster.find_by_name(params[:ward])
		label[0]=@ward.name
		@ward1=Bedmaster.all(:conditions => "wardmaster_id = #{@ward.id} and status =1")
		@ward2=Bedmaster.all(:conditions => "wardmaster_id = #{@ward.id} and status =0")
		@available_data[0]=@ward1.length
		@occupied_data[0]=@ward2.length
	else
		@ward=Wardmaster.find(:all)
		for i in 0...@ward.length
			label[i]=@ward[i].name
			@ward1=Bedmaster.all(:conditions => "wardmaster_id = #{@ward[i].id} and status =1")
			@ward2=Bedmaster.all(:conditions => "wardmaster_id = #{@ward[i].id} and status =0")
			@available_data[i]=@ward1.length
			@occupied_data[i]=@ward2.length
		end
	end
	@mcol3d = Ezgraphix::Graphic.new(:div_name => 'mcol_3d', :c_type => 'mscol3d', :caption => "Bed", :w => 800, :x_name=>'Ward Names', :y_name=>'Beds', :background => 'ecf3f7', :div_line_precision=>'0', :precision =>'0', :f_number_scale=>'0', :line => 'red')
	@mcol3d.data = { "Available" => @available_data, "Occupied " => @occupied_data}
	@mcol3d.labels = label
  end
  
  
  def date2
     
	date2=params[:date2]
	date3=params[:date3]
	type=params[:type]
	room=params[:room1]
	ward=params[:ward]
	bed=params[:bed]
	@user_id =params[:user_id]
	$org_code=params[:org_code]
	if(type=="wait")
	    @a="Waiting To Admit"
		@admission=Admission.find(:all, :conditions => "
			(admn_date BETWEEN'#{date2}%' AND '#{date3}') AND
			ward LIKE '#{ward}%' AND
			room LIKE '#{room}%' AND
			bed LIKE '#{bed}%' AND
			admn_status LIKE '#{@a}%' AND
			org_code ='#{$org_code}'")
		if( @admission[0])
			render :partial => "adm_waiting_search"
		else
			render :text =>  "No Records"
		end	
      end
  end

  def discharge 
	date1=params[:date1]
	date2=params[:date2]
	room=params[:room1]
	ward=params[:ward]
	bed=params[:bed]
	@org_code=params[:org_code]
	@discharge_intimation=Admission.find(:all, :conditions => "
			ward LIKE '#{ward}%' AND
			room LIKE '#{room}%' AND
			bed LIKE '#{bed}%' AND
			org_code ='#{@org_code}'")
		if( @discharge_intimation[0])
			render :partial => "dischrage_intimation_search"
		else
			render :text =>  "No Records"
    	end	
      
  end
   def select_org_code
	transfer_data=TransferData.new
	render :js=>"document.getElementById('org_location').value='#{transfer_data.get_org_location(params[:org_code])}'"
  end
   def bed
    @bed_management = BedManagement.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	#Get the org_code and org_location in people table based on user id.
	@org_code=@person.org_code
	@org_location=@person.org_location
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bed_management }
    end
  end
  
  def dis
    @bed_management = BedManagement.new
	#Get the org_code and org_location in people table based on user id.
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @bed_management }
    end
  end
end
