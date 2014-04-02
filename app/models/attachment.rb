class Attachment < ActiveRecord::Base

  before_create :set_filename
 
  has_many :images, :dependent => :delete_all
  has_many :observations, :dependent => :delete_all
  after_create :store_file 
  attr_accessor :uploaded_file0 
  attr_accessor :filename
  attr_accessor :uploaded_file1 
  attr_accessor :filename1
  
  attr_accessor :uploaded_file2 
  attr_accessor :filename2

  attr_accessor :uploaded_file3 
  attr_accessor :filename3

  attr_accessor :uploaded_file4 
  attr_accessor :filename4
  
  attr_protected :created_at, :created_by, :updated_at, :updated_by

   
 
  def store_file 
	if(uploaded_file0)
	  	File.open(file_storage_location, 'wb') do |f| 
			f.write uploaded_file0.read 
		end
	end

	if(uploaded_file1)
		File.open(another_file_storage_location, 'wb') do |f| 
			f.write uploaded_file1.read 
		end 
	end

	if(uploaded_file2)
		File.open(another_file2_storage_location, 'wb') do |f| 
			f.write uploaded_file2.read 
		end 
	end

	if(uploaded_file3)
		File.open(another_file3_storage_location, 'wb') do |f| 
			f.write uploaded_file3.read 
		end 
	end

	if(uploaded_file4)
		File.open(another_file4_storage_location, 'wb') do |f| 
			f.write uploaded_file4.read 
		end 
	end
  end 

  def delete_file 
	File.delete(file_storage_location) 
  end 

  def file_storage_location 
	directory_name = 'public/attachments/'+Date.today.strftime("%d.%m.%Y").to_s
	if(!File.exists? directory_name)
		Dir.mkdir( "public/attachments/"+Date.today.strftime("%d.%m.%Y").to_s, 755 )
	end
	filename = uploaded_file0.original_filename
	File.join(Rails.root, 'public/attachments/'+Date.today.strftime("%d.%m.%Y").to_s, filename)
  end
  
  def another_file_storage_location 
	directory_name = 'public/attachments/'+Date.today.strftime("%d.%m.%Y").to_s
	if(!File.exists? directory_name)
		Dir.mkdir( "public/attachments/"+Date.today.strftime("%d.%m.%Y").to_s, 755 )
	end
	filename1 = uploaded_file1.original_filename
	File.join(Rails.root, 'public/attachments/'+Date.today.strftime("%d.%m.%Y").to_s, filename1)
  end 

  def another_file2_storage_location 
	directory_name = 'public/attachments/'+Date.today.strftime("%d.%m.%Y").to_s
	if(!File.exists? directory_name)
		Dir.mkdir( "public/attachments/"+Date.today.strftime("%d.%m.%Y").to_s, 755 )
	end
	filename2 = uploaded_file2.original_filename
	File.join(Rails.root, 'public/attachments/'+Date.today.strftime("%d.%m.%Y").to_s, filename2)
  end 

  def another_file3_storage_location 
	directory_name = 'public/attachments/'+Date.today.strftime("%d.%m.%Y").to_s
	if(!File.exists? directory_name)
		Dir.mkdir( "public/attachments/"+Date.today.strftime("%d.%m.%Y").to_s, 755 )
	end
	filename3 = uploaded_file3.original_filename
	File.join(Rails.root, 'public/attachments/'+Date.today.strftime("%d.%m.%Y").to_s, filename3)
  end

  def another_file4_storage_location 
	directory_name = 'public/attachments/'+Date.today.strftime("%d.%m.%Y").to_s
	if(!File.exists? directory_name)
		Dir.mkdir( "public/attachments/"+Date.today.strftime("%d.%m.%Y").to_s, 755 )
	end
	filename4 = uploaded_file4.original_filename
	File.join(Rails.root, 'public/attachments/'+Date.today.strftime("%d.%m.%Y").to_s, filename4)
  end

  def set_filename 
	if(uploaded_file0)
		filename = uploaded_file0.original_filename
	end
	
	if(uploaded_file1)
		filename1 = uploaded_file1.original_filename 
	end

	if(uploaded_file2)
		filename2 = uploaded_file2.original_filename
	end

	if(uploaded_file3)
		filename3 = uploaded_file3.original_filename
	end

	if(uploaded_file4)
		filename4 = uploaded_file4.original_filename
	end
  end 
  
end
