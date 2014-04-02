class CountryMaster < ActiveRecord::Base
validates_presence_of :code, :name
	validates_format_of :name, :with =>/^[A-Za-z.]*\z/
end
