class Profilemaster < ActiveRecord::Base

validates_presence_of :profile_name
    has_many :childmaster, :dependent => :destroy  
    has_many :citymaster
	accepts_nested_attributes_for :childmaster, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { attrs[:new].blank? } }

end
