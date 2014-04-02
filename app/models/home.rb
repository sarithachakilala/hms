class Home < ActiveRecord::Base
  has_many :images, :dependent => :delete_all
  has_many :observations, :dependent => :delete_all
  after_create :store_file 
  attr_accessor :uploaded_file 
  attr_accessor :filename
  
  attr_protected :created_at, :created_by, :updated_at, :updated_by

   
 
  def session_clear(session_id)
	@session=Session.find_by_id(session_id)
	if(@session)
		Session.destroy(@session)
	end
  end
	
  def store_file 
  	File.open(file_storage_location, 'wb') do |f| 
		f.write uploaded_file.read 
	end
  end 

  def delete_file 
	File.delete(file_storage_location) 
  end 

  def file_storage_location 
	filename = uploaded_file.original_filename
	File.join(Rails.root, 'public/images', filename)
  end
  
  def set_filename 
	filename = uploaded_file.original_filename
  end 

end
