class InsuranceMaster < ActiveRecord::Base
validates_presence_of :company_name, :code, :phone, :address, :city, :state, :country, :person_name, :mobile
acts_as_reportable
end
