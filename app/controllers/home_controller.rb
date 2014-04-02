class HomeController < ApplicationController
  
  
  def index
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@profile=Profilemaster.find_by_profile_name(@person.profile)
	@home=Home.last
	@modules_lists = ModulesList.all(:order => "position ASC")
	@notice_boards = NoticeBoard.find(:all, :order => "id ASC", :conditions => "notice_date = '#{Date.today}'").reverse
  end
  def super_admin
	@session_id=params[:session_id]
	@user_id=params[:user_id]
	@people=Person.find_by_id(@user_id)
	@home=Home.last
  end
  
  def user 
	@forms=Hash.new
	@session_id=params[:session_id]
	@user_id=params[:user_id]
	@people=Person.find_by_id(@user_id)
	@p=Profilemaster.find_by_profile_name(@people.profile)
	@home=Home.last
	for child in @p.childmaster
		@forms[child.forms]=child.new+child.view+child.edit+child.remove
	end
  end
  
  def admin 
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	@profile=Profilemaster.find_by_profile_name(@person.profile)
	@home=Home.last
  end
	
  def main_admin
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@people = Person.find(@session.person_id)
  end
  
  def main
  
  end

  def medieaz_info
	render :layout => false
  end

  def hospital_info
	render :layout => false
  end

  def home
	render :layout => false
  end

  def dump
	render :layout => false
  end
   def csv_import
	content =  params[:dump][:file].read
	record_line = content.split("\n")
	record_line1 = content.split("\n")
	record_line1.each_with_index do |record1, i|
		record1.chomp!
		if i==1
			record1_split = record1.split(",")
			@table_name=record1_split[0] 
			break
		end    
	end
	if @table_name=="Store Child1"	
		@goodsrecieptnotemaster1 = Goodsrecieptnotemaster.last
		if(@goodsrecieptnotemaster1)
			@id=@goodsrecieptnotemaster1.id+1
		else
			@id=1
		end
		record_line.each_with_index do |record, i|
			record.chomp!
			if i==0
				next 
			end    
			record_split = record.split(",")
			@store_child = StoreChild.new
			@store_child.goodsrecieptnotemaster_id=@id
			@store_child.item_code = record_split[1]
			@store_child.quantity=record_split[2]
			@store_child.batch_no=record_split[3]
			@store_child.expiry_date=record_split[4]
			@store_child.purchase_rate=record_split[5]
			@store_child.sale_rate=record_split[6]
			@store_child.discount=record_split[7]
			@store_child.save
		end
	elsif @table_name=="Consultant Master"
		
		record_line.each_with_index do |record, i|
			record.chomp!
			if i==0
				next 
			end
			record_split = record.split(",")
			@consultant_masters = ConsultantMaster.new
			@consultant_masters.consultant_type="Internal"
			@consultant_masters.org_code = record_split[1]
			@consultant_masters.org_location = record_split[2]
			@consultant_masters.dept_code = record_split[3]
			@consultant_masters.name = record_split[4]
			@consultant_masters.consultant_id = record_split[5]
			@consultant_masters.ph_no = record_split[6]
			@consultant_masters.charge_type = "Both"
			@consultant_masters.charge = "Both Flat"
			@consultant_masters.general_charge = record_split[7]
			@consultant_masters.night_duty_charge = record_split[7]
			@consultant_masters.emergency_charge = record_split[7]
			@consultant_masters.save
		end
	elsif @table_name=="Admission"
		
		record_line.each_with_index do |record, i|
			record.chomp!
			if i==0
				next 
			end    
			record_split = record.split(",")
			@ipadmission = Ipadmission.new
			@ipadmission.admn_no = record_split[1]
			@ipadmission.admn_date = record_split[2]
			puts record_split[2]
			@ipadmission.save
		end
	elsif @table_name=="Package Master"
		
		record_line.each_with_index do |record, i|
			record.chomp!
			if i==0
				next 
			end
			record_split = record.split(",")
			@package_master = PackageMasterMajestic.new
			@package_master.id = record_split[1]
			@package_master.category = record_split[2]
			@package_master.sub_category = record_split[3]
			@package_master.inclusion = record_split[4]
			@package_master.exclusion = record_split[5]
			@package_master.org_code = record_split[6]
			@package_master.org_location = record_split[7]
			
			@package_master.save
		end
	elsif @table_name=="Package Master Child"
		
		record_line.each_with_index do |record, i|
			record.chomp!
			if i==0
				next 
			end
			record_split = record.split(",")
			@ward_masters=WardMaster.all
			i=3
			for ward in @ward_masters
				@package_master = PackageMasterMajesticChild.new
				@package_master.package_master_majestic_id = record_split[2]
				@package_master.ward_name = ward.name
				@package_master.charge = record_split[i]
				@package_master.save
				i+=1
			end			
		end
	elsif @table_name=="Agency Master"
		
		record_line.each_with_index do |record, i|
			record.chomp!
			if i==0
				next 
			end
			record_split = record.split(",")
			@vendormasters = Vendormaster.new
			@vendormasters.org_code = record_split[1]
			@vendormasters.org_location = record_split[2]
			@vendormasters.vendor_code = record_split[3]
			@vendormasters.vendor_name = record_split[4]
			@vendormasters.vendor_tin_no = '1003'
			@vendormasters.address1="Hyderabad"
			@vendormasters.city="Hyderabad"
			@vendormasters.state="AP"
			@vendormasters.country="India"
			@vendormasters.save
		end
	elsif @table_name=="Item Master"
		
		record_line.each_with_index do |record, i|
			record.chomp!
			if i==0
				next 
			end
			record_split = record.split(",")
			@itemmasters=Itemmaster.new
			@itemmasters.org_code = record_split[1]
			@itemmasters.org_location = record_split[2]
			@itemmasters.item_name = record_split[3]
			@itemmasters.item_code = record_split[4]
			@itemmasters.packing = record_split[5]
			@itemmasters.vat = record_split[6]
			@itemmasters.units = record_split[7]
			@itemmasters.save
		end
	elsif @table_name=="Store Child"
		
		record_line.each_with_index do |record, i|
			record.chomp!
			if i==0
				next 
			end
			record_split = record.split(",")
			@store_children=StoreChild.new
			@store_children.goodsrecieptnotemaster_id = record_split[1]
			@store_children.item_name = record_split[5]
			@store_children.item_code = record_split[6]
			@store_children.packing = record_split[7]
			@store_children.batch_no = record_split[8]
			@store_children.quantity = record_split[9]
			@store_children.requisation_qty = record_split[9]
			@store_children.free = record_split[10]
			@store_children.purchase_rate = record_split[11]
			@store_children.mrp = record_split[12]
			@store_children.purchase_discount = 0
			@store_children.sale_rate = record_split[12]
			@store_children.discount = 0
			@store_children.amount = record_split[13]
			@store_children.vat = record_split[15]
			@store_children.expiry_date = record_split[16]
			@store_children.save
		end
	elsif @table_name=="Charge Master"
		
		record_line.each_with_index do |record, i|
			record.chomp!
			if i==0
				next 
			end
			record_split = record.split(",")
			@charge_master = ChargeMaster.new
			@charge_master.org_code = record_split[1]
			@charge_master.org_location = record_split[2]
			@charge_master.service_group = record_split[3]
			@charge_master.service_name = record_split[4]
			@charge_master.test_name = record_split[5]
			@charge_master.charge = record_split[6]
			@charge_master.lab_charge = record_split[7]
			@charge_master.hospital_charge = record_split[8]
			@charge_master.save
		end
	end
	redirect_to("/home/dump/1", :notice => "#{@table_name}  Successfully updated.")
  end
  def create
    # This routine either creates a new encounter if it's called without a parameter, or 
    # Saves changes to an edited encounter when called with an Encounter.id
    
    @home = Home.new(params[:home])
    @home.save
    redirect_to(:controller => "home", :action => 'image_upload' )
 
  end

  def image_upload
	@home=Home.new
	render :layout => false
  end
end
