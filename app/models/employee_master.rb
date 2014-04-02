class EmployeeMaster < ActiveRecord::Base
validates_presence_of :join_date, :org_code, :name, :org_location, :phno, :dob, :designation, :empid, :city, :state, :country
validates_numericality_of :zipcode

end
