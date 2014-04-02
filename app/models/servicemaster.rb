class Servicemaster < ActiveRecord::Base
validates_presence_of :org_code, :org_location, :service_name, :service_code, :service_group_code, :service_name
end
