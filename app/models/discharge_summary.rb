class DischargeSummary < ActiveRecord::Base
	has_many :medicine_list, :dependent => :destroy
	accepts_nested_attributes_for :medicine_list, :allow_destroy => :true, :reject_if => proc { |attrs| attrs.all? { attrs[:name].blank? } }
	validates_presence_of :admn_no, :mr_no, :discharge_consultant, :status, :review_date
end
