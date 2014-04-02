
class Manufacturer < ActiveRecord::Base
	validates_presence_of :manufacturer_name, :manufacturer_code
end
