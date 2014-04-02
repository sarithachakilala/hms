class RegistrationsController < ApplicationController
  # GET /registrations
  # GET /registrations.xml
  def index
    @registrations = Registration.paginate :page => params[:page] || 1, :per_page => 5, :order => "id DESC"
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @registrations }
    end
  end
    def observe_field_ex
    	@name=params[:name_search]
    	@mr_no=params[:mr_no_search]
    	@reg_date=params[:reg_date_search]
    	@age=params[:age_search]
    	@city=params[:city_search]
  	@registrations = Registration.find(:all,:conditions=>"reg_date LIKE'%#{params[:reg_date_search]}' AND mr_no LIKE '%#{params[:mr_no_search]}' AND patient_name LIKE '#{params[:name_search]}%' AND age LIKE '#{params[:age_search]}%' AND city LIKE '#{params[:city_search]}%'")
		if( @registrations[0])
		   render:partial=>"field_searching"
		else
			render:text=>"<b><h2><center><font color=purple>NO RECORDS FOUND</font></center></h2></b>"
		end  
		
  end 
  

  # GET /registrations/1
  # GET /registrations/1.xml
  def show
    @registration = Registration.find(params[:id])
	 @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @registration }
    end
  end

  # GET /registrations/new
  # GET /registrations/new.xml
  def new
    @registration = Registration.new
	@registration.mr_no,@registration.reg_no=@registration.find_mr_no()
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@org_code=@person.org_code
	@org_location=@person.org_location
	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @registration }
    end
  end

  # GET /registrations/1/edit
  def edit
	 @session_id=session[:id]

	 @session = Session.find(session[:id])
	 @person = Person.find(@session.person_id)
   @registration = Registration.find(params[:id])
  end

  # POST /registrations
  # POST /registrations.xml
  def create
    @registration = Registration.new(params[:registration])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
  	if(@registration.upload!="upload")
		num=Number.find_by_name_and_org_code("image_no","Sample")
		@registration.image_path='/uploads/'+num.value.to_s + '.jpg'
	end
	@registration.patient_name=@registration.patient_name.capitalize
	@registration.father_name=@registration.father_name.capitalize
    respond_to do |format|
      if @registration.save
        format.html { redirect_to("/registrations/confirmation_form/#{@registration.id}") }
        format.xml  { render :xml => @registration, :status => :created, :location => @registration }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  def confirmation_form
    @registration=Registration.find_by_id(params[:id])
    @mr_no=@registration.mr_no
    @pname=@registration.title+"."+@registration.patient_name
  end
  # PUT /registrations/1
  # PUT /registrations/1.xml
  def update
  	@session_id=session[:id]
	  @session = Session.find(session[:id])
	  @person = Person.find(@session.person_id)
	  @registration = Registration.find(params[:id])
    respond_to do |format|
      if @registration.update_attributes(params[:registration])
        @registration1 = Registration.find(@registration.id)
        if(@registration1.upload!="upload")
          num=Number.find_by_name_and_org_code("image_no","Sample")
          @registration1.image_path='/uploads/'+num.value.to_s + '.jpg'
        end
        @registration1.update_attributes(params[:registration1])
        format.html { redirect_to("/registrations/new", :notice => 'Registration was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @registration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /registrations/1
  # DELETE /registrations/1.xml
  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy

    respond_to do |format|
      format.html { redirect_to(registrations_url) }
      format.xml  { head :ok }
    end
  end

  
 def select_city
	@city=CityMaster.find_by_name(params[:city_name])
	@state=StateMaster.find_by_id(@city.state_master_id)
	@country=CountryMaster.find_by_id(@state.country_master_id)
	render :js =>"
		document.getElementById('state').style.background='#FEF5CA';
		document.getElementById('state').readOnly=true;
		document.getElementById('country').style.background='#FEF5CA';
		document.getElementById('country').readOnly=true;
		document.getElementById('state').value='#{@state.name}';
   		document.getElementById('country').value='#{@country.name}';
	"
  end  
  
   def code_image 
	@image_data = Registration.find(params[:id])
	@image = @image_data.binary_data
	send_data (@image, :type => @image_data.content_type, 
              :filename => @image_data.filename, 
              :disposition =>'inline')
  end
  
   def report

	
	@registration = Registration.find(params[:id])
   
    prawnto :prawn => {
      :page_size => 'A4',
     :left_margin => 10,
      :right_margin => 10,
      :top_margin => 10,
      :bottom_margin => 30},
      :filename => "repsort.pdf"

    render :layout => false
	
  end
   def select_refferal
	puts params[:refferal_name]
			@refferal = RefferalMaster.find_by_refferal_name(params[:refferal_name])
			render :js =>"
		document.getElementById('referral_contact_no').style.background='#FEF5CA';
		document.getElementById('referral_contact_no').value='#{@refferal.ph_no}'
		"
	end
	
	def upload
		File.open(upload_path, 'wb') do |f|
			f.write request.raw_post
		end
		render :text => "ok"
	end
	

  def select_ins_company_name
    insurance=insuranceMaster.find_by_company_name(params[:ins_comp_name])
    render :js => "document.getElementById('').value=#{}
                   document.getElementById('').value=#{}"
  end

	private
	def upload_path # is used in upload and create
		number=Number.new
		update_image_value=number.retrive_value("image_no","Sample")
		@n=Number.find_by_name_and_org_code("image_no","Sample")
		@n.value=update_image_value
		@n.update_attributes(params[:n])
		file_name = update_image_value.to_s + '.jpg'
		File.join(Rails.root, 'public', 'uploads', file_name)
	end
end
