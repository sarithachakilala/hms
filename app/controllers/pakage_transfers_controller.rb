class PakageTransfersController < ApplicationController
  # GET /pakage_transfers
  # GET /pakage_transfers.xml
  def index
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
    @pakage_transfer = PakageTransfer.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@org.org_code}'"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pakage_transfer }
    end
  end
  def search
	@user_id=params[:user_id]
	 @pakage_transfer = PakageTransfer.find(:all,:conditions => "mr_no = '#{params[:t]}'")
	render :partial => "seach_package"
  end

  # GET /pakage_transfers/1
  # GET /pakage_transfers/1.xml
  def show
    @pakage_transfer = PakageTransfer.find(params[:id])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@people = Person.find(@session.person_id)
	@org_code=@people.org_code
	@org_location=@people.org_location
	@registration=Registration.find_by_mr_no_and_org_code(@pakage_transfer.mr_no,@pakage_transfer.org_code)
		if @registration			
					@patient_name=@registration.patient_name
					@father_name=@registration.father_name
					@gender=@registration.gender
					@age=@registration.age
					@mobile=@registration.ph_no
		end		
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pakage_transfer }
    end
  end

  # GET /pakage_transfers/new
  # GET /pakage_transfers/new.xml
  def new
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@people = Person.find(@session.person_id)
	@org_code=@people.org_code
	@org_location=@people.org_location
	@pakage_transfer = PakageTransfer.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pakage_transfer }
    end
  end

  # GET /pakage_transfers/1/edit
  def edit
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@people = Person.find(@session.person_id)
	@org_code=@people.org_code
	@org_location=@people.org_location
    @pakage_transfer = PakageTransfer.find(params[:id])
	@registration=Registration.find_by_mr_no_and_org_code(@pakage_transfer.mr_no,@pakage_transfer.org_code)
					@patient_name=@registration.patient_name
					@father_name=@registration.father_name
					@gender=@registration.gender
					@age=@registration.age
					@mobile=@registration.ph_no
 
  end

  # POST /pakage_transfers
  # POST /pakage_transfers.xml
  def create
    @pakage_transfer = PakageTransfer.new(params[:pakage_transfer])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@people = Person.find(@session.person_id)
    respond_to do |format|
      if @pakage_transfer.save
		@admission=Admission.find_by_org_code_and_admn_no(@pakage_transfer.org_code,@pakage_transfer.admn_no)
		@admission.amount=@pakage_transfer.amount.to_f+@pakage_transfer.t_amount.to_f
		@admission.update_attributes(params[:admission])
        format.html { redirect_to("/pakage_transfers/new", :notice => 'PakageTransfer was successfully created.') }
        format.xml  { render :xml => @pakage_transfer, :status => :created, :location => @pakage_transfer }
      else
@pakage=Admission.find_by_admn_no(@pakage_transfer.admn_no)
@reg=Registration.find_by_mr_no(@pakage_transfer.mr_no)
if(@pakage)
@patient_name=@pakage.patient_name
@father_name=@reg.father_name
@age=@pakage.age
@gender=@pakage.gender
@contact=@reg.ph_no


end

        format.html { render :action => "new" }
        format.xml  { render :xml => @pakage_transfer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pakage_transfers/1
  # PUT /pakage_transfers/1.xml
  def update
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
    @pakage_transfer = PakageTransfer.find(params[:id])
    respond_to do |format|
      if @pakage_transfer.update_attributes(params[:pakage_transfer])
        format.html { redirect_to("/pakage_transfers/new", :notice => 'PakageTransfer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pakage_transfer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pakage_transfers/1
  # DELETE /pakage_transfers/1.xml
  def destroy
    @pakage_transfer = PakageTransfer.find(params[:id])
    @pakage_transfer.destroy

    respond_to do |format|
      format.html { redirect_to(pakage_transfers_url) }
      format.xml  { head :ok }
    end
  end

  def ajax_buildings
	admission=Admission.find_by_id(params[:record_id])
	registration=Registration.find_by_mr_no_and_org_code(admission.mr_no,admission.org_code)
	render :text => admission.admn_no+"<division>"+admission.mr_no+"<division>"+registration.patient_name+"<division>"+registration.father_name+"<division>"+registration.age.to_s+"<division>"+registration.gender+"<division>"+registration.ph_no+"<division>"+admission.package_category+"<division>"+admission.sub_category+"<division>"+admission.days+"<division>"+admission.amount
  end

  def select_pack_category_code
	@package_master=PackageMasterMajestic.find(:all,:conditions =>"category = '#{params[:category]}' and org_code = '#{params[:org_code]}'")			
	str=""
	for package_master in @package_master
		str<<package_master.sub_category+"<division>"
	end	
	render :text =>str
  end
   def observe_field_ex
  	@pakage_transfer = PakageTransfer.find(:all,:conditions=>"today_date LIKE '#{params[:today_date]}%' AND admn_no LIKE '%#{params[:admn_no]}' AND mr_no LIKE '#{params[:mr_no]}%' AND e_cat LIKE '#{params[:e_cat]}%' AND trans_cat LIKE '#{params[:trans_cat]}%'")
		if( @pakage_transfer[0])
		   render:partial=>"seach_package"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  	
  end 
  
  
end
