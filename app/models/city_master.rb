class CityMaster < ActiveRecord::Base
validates_presence_of :name, :with =>/^[A-Za-z.]*\z/
validates_presence_of :code
end
