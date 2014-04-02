class MiscellaneousChild < ActiveRecord::Base
acts_as_reportable
belongs_to :miscellaneous_master
end
