class StoreRadiologyTest < ActiveRecord::Base
	
  before_create :set_filename
  
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
	filename = uploaded_file0.original_filename
	File.join(Rails.root, 'public', filename)
  end
  
  def another_file_storage_location 
	filename1 = uploaded_file1.original_filename
	File.join(Rails.root, 'public', filename1)
  end 

  def another_file2_storage_location 
	filename2 = uploaded_file2.original_filename
	File.join(Rails.root, 'public', filename2)
  end 

  def another_file3_storage_location 
	filename3 = uploaded_file3.original_filename
	File.join(Rails.root, 'public', filename3)
  end

  def another_file4_storage_location 
	filename4 = uploaded_file4.original_filename
	File.join(Rails.root, 'public', filename4)
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
