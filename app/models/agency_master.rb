class AgencyMaster < ActiveRecord::Base
validates_presence_of :address, :city, :contact_person, :agency_name
validates_format_of :contact_person, :with =>/^[A-Za-z.]*\z/

end
