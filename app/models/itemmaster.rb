class Itemmaster < ActiveRecord::Base
	validates_presence_of :product_name,:is_medical_item,:units,:packing,:vat
end
