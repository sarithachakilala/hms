class PackageMasterMajesticsController < ApplicationController
  # GET /package_master_majestics
  # GET /package_master_majestics.xml
   require 'csv'
  def index
    @session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
    @package_master_majestics = PackageMasterMajestic.paginate:page => params[:page] || 1, :per_page => 10, :order =>"id DESC"
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @package_master_majestics }
    end
  end

  # GET /package_master_majestics/1
  # GET /package_master_majestics/1.xml
  def show
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
    @package_master_majestic = PackageMasterMajestic.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @package_master_majestic }
    end
  end

  # GET /package_master_majestics/new
  # GET /package_master_majestics/new.xml
  def new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@people = Person.find(@session.person_id)
	@org_code=@org.org_code
	@org_location=@org.org_location

    @package_master_majestic = PackageMasterMajestic.new
	@ward=WardMaster.find(:all,:conditions => "org_code = '#{@org_code}'")
	@length=@ward.length
	i=0
    	@length.times{@package_master_majestic.package_master_majestic_children.build
		@package_master_majestic.package_master_majestic_children[i].ward_name=@ward[i].name
		i+=1
	}
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @package_master_majestic }
    end
  end

  # GET /package_master_majestics/1/edit
  def edit
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
    @package_master_majestic = PackageMasterMajestic.find(params[:id])
  end

  # POST /package_master_majestics
  # POST /package_master_majestics.xml
  def create
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
    @package_master_majestic = PackageMasterMajestic.new(params[:package_master_majestic])

    respond_to do |format|
      if @package_master_majestic.save
        format.html { redirect_to("/package_master_majestics/new", :notice => 'PackageMasterMajestic was successfully created.') }
        format.xml  { render :xml => @package_master_majestic, :status => :created, :location => @package_master_majestic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @package_master_majestic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /package_master_majestics/1
  # PUT /package_master_majestics/1.xml
  def update
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
    @package_master_majestic = PackageMasterMajestic.find(params[:id])
    respond_to do |format|
      if @package_master_majestic.update_attributes(params[:package_master_majestic])
        format.html { redirect_to("/package_master_majestics/new", :notice => 'PackageMasterMajestic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @package_master_majestic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /package_master_majestics/1
  # DELETE /package_master_majestics/1.xml
  def destroy
    @package_master_majestic = PackageMasterMajestic.find(params[:id])
    @package_master_majestic.destroy

    respond_to do |format|
      format.html { redirect_to(package_master_majestics_url) }
      format.xml  { head :ok }
    end
  end
	

	def package_enquiries
 
  	end
  
  
  def searching
  
  	category = params[:category]
	sub_category=params[:sub_category]

 	 if(category!="" && sub_category!="")
	
			query=["category LIKE ? AND sub_category LIKE ?",category,sub_category]
	elsif(category=="" && sub_category!="")
	
			query=["sub_category LIKE ?",sub_category]
	elsif(category!="")
			query=["category LIKE ?",category]
		
	end
			@cat=PackageMasterMajestic.find(:all, :conditions => query)
		
			if(@cat)
			render :partial => "package_search"
			else 
			render :text => "please enter any value"
		end

  
  end
  

 def search
  	sub_category = params[:sub_category]
	 @package_master_majestics=PackageMasterMajestic.find(:all,:conditions =>"sub_category LIKE '#{sub_category}%'")
	render :partial => "package_search"
  end
  
  def fetch
 
	  @cat=PackageMasterMajestic.find(:all, :conditions => "category = '#{params[:category]}'")
	  str=""
		for cat in 0...@cat.length
			str<<@cat[cat].sub_category<<"<division>"
		end
		render :text => str
  end
  
  def sub_package
	@package_masters=PackageMasterMajestic.find(:all,:conditions => "category = '#{params[:package]}' and org_code LIKE '#{params[:org_code]}%'")
	str=""
	for package_master in @package_masters
		str<<package_master.sub_category+"<division>"
	end
	render :text =>str
  end
  
  def package_report
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@people = Person.find(@session.person_id)
	@org_code=@org.org_code
	@org_location=@org.org_location
  end
  
  def package_bills
  	@session_id=session[:id]
	@session = Session.find(session[:id])
	@org = Person.find(@session.person_id)
	@people = Person.find(@session.person_id)
	@org_code=@org.org_code
	@org_location=@org.org_location
 end
  
  def find_report
		@report_type=params[:report_type]
		@rig1=Admission.find(:all, :conditions =>"admn_date BETWEEN '#{params[:from_date]}' AND '#{params[:to_date]}' AND org_code Like'#{params[:org_code]}%' AND package_category LIKE '#{params[:package]}%' and sub_category LIKE '#{params[:sub_package]}%' and admn_category='Package'")
		if(@rig1)	
			render :partial => "package_reporting"
		else 
			render :text => "please enter any value"
		end
	end
	
	def export_to_csv
	@rig1=Admission.find(:all, :conditions =>"admn_date BETWEEN '#{params[:from_date]}' AND '#{params[:to_date]}' AND org_code Like'#{params[:org_code]}%' AND package_category LIKE '#{params[:package]}%' and sub_category LIKE '#{params[:sub_package]}%' and admn_category='Package'")
	report = StringIO.new
		CSV::Writer.generate(report, ',') do |title|
		title << ['Table Name','Org Code','Org.Location','Date','Package Name','Sub Package','Patient Name','MR No','Admn.No','City']
		@rig1.each do |a|
			reg=Registration.find_by_org_code_and_mr_no(a.org_code,a.mr_no)
			title << ['Package Report',a.org_code,a.org_location,a.admn_date,a.package_category,a.sub_category,reg.patient_name,reg.mr_no,a.admn_no,reg.city]
		end
	end
	report.rewind
	send_data(report.read,:type=>'text/csv;charset=iso-8859-1;header=present',:filename=>"#{Date.today}.csv",:disposition =>'attachment', :encoding => 'utf8')
   end
   def display_package
	@registration = Registration.find(params[:id1])
	@admission= Admission.find_by_mr_no(@registration.mr_no)
   
   end

  
end
