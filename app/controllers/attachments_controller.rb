class AttachmentsController < ApplicationController
  # GET /attachments
  # GET /attachments.xml
  
  def index
    @attachments = Attachment.all(:select => "DISTINCT mr_no")
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attachments }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.xml
  def show
    @attachments = Attachment.find(:all, :conditions => "mr_no = '#{params[:mr_no]}'")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attachment }
    end
  end

  # GET /attachments/new
  # GET /attachments/new.xml
  def new
    @attachment = Attachment.new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@people = Person.find(@session.person_id)
	@org_code=@people.org_code
	@org_location=@people.org_location
	if(params[:mr_no])
		@admissions = Admission.last(:conditions => "mr_no = '#{params[:mr_no]}' and admn_status='Admitted'")
		@registration=Registration.find_by_mr_no(params[:mr_no])
		@patient_name=@registration.patient_name
		@attachment.mr_no=@registration.mr_no
		@attachment.patient_type="OP"
		if(@admissions)
			@ward=@admissions.admn_no
			@room=@admissions.room
			@bed=@admissions.bed
			@floor=@admissions.floor
			@attachment.patient_type="IP"
			@attachment.admn_no=@admissions.admn_no
		end
	end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
  end

  # POST /attachments
  # POST /attachments.xml
  def create
    @attachment = Attachment.new(params[:attachment])
	user_id=params[:user_id]
    respond_to do |format|
      if @attachment.save
        format.html { redirect_to("/attachments?mr_no=#{@attachment.mr_no}", :notice => 'Attachment was successfully created.') }
        format.xml  { render :xml => @attachment, :status => :created, :location => @attachment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.xml
  def update
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        format.html { redirect_to(@attachment, :notice => 'Attachment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.xml
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to(attachments_url) }
      format.xml  { head :ok }
    end
  end
  
  def ajax_function
  if(params[:type]=='OP')
  @reg=Registration.find_by_id(params[:admn_no])
  render :text =>  ""+"<division>"+@reg.mr_no+"<division>"+@reg.first_name+"."+@reg.last_name+"<division>"+""+"<division>"+""+"<division>"+""+"<division>"+""+"<division>"+@reg.image_file_name.to_s
  else
	@admission=Admission.find_by_id(params[:admn_no])
	@registration=Registration.find_by_mr_no_and_org_code(@admission.mr_no,@admission.org_code)
	render :text => @admission.admn_no+"<division>"+@registration.mr_no+"<division>"+@registration.first_name+"."+@registration.last_name+"<division>"+@admission.floor+"<division>"+@admission.ward+"<division>"+@admission.room+"<division>"+@admission.bed+"<division>"+@registration.image_file_name.to_s
	end
  end
  
end
