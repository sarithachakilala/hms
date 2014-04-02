# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

$org_code
	$org_location
	def format_date(type, date)
		case type
		  when :short_no_year 
			date.strftime("%b %d")
		  when :short
			date.strftime("%d-%b-%Y")
		  when :long 
			date.strftime("%B %d, %Y")
		  when :long_day_of_week
			date.strftime("%a %B %d, %Y")
		  when :sort
			date.strftime("%Y-%m-%d")
		  when :calendra
			date.strftime("%d/%m/%Y")
		  when :default
			date.strftime("%Y/%m/%d")
		end
	end
	
	def print_date(type, date)
		return date;
	end

	def number_to_words(number)
	
		digits={"1" => "one","2" => "two","3" => "three", "4" =>"four","5"=>"five","6"=>"six","7"=>"seven","8"=>"eight","9"=>"nine","10"=>"ten",
		"11"=>"eleven","12"=>"twelve","13"=>"thirteen","14"=>"fourteen","15"=>"fifteen","16"=>"sixteen","17"=>"seventeen","18"=>"eighteen","19"=>"nineteen","20"=>"twenty",
		"30"=>"thirty","40"=>"forty","50"=>"fifty","60"=>"sixty","70"=>"seventy","80"=>"eighty","90"=>"ninety"}
		units={"3" => "hundred and","4" => "thousands", "6" => "lakhs"}
		n=number
		str=""
		while(n>0)
			name=n.to_s
				if(name.length<3 && n<=20)
				str<<digits[name]+" "
				n=0
				n=n%10
			elsif(n>20 && name.length<3)
				value=(n-n%10).to_s
				str<<digits[value]+" "
				n=n%10
			elsif(name.length==3)
				value=(n/100).to_s
				str<<digits[value]+" "
				str<<units[name.length.to_s]+" "
				n=n%100
			elsif(name.length>=4 && name.length<6)
				value=(n/1000).to_s
				if(value.length==2)
					value_int=value.to_i
					value1=(value_int-value_int%10)
					str<<digits[value1.to_s]+" "
					if(value_int%10!=0)
						str<<digits[(value_int%10).to_s]+" "
					end
				else
					str<<digits[value]+" "
				end
				if(value=="1")
					str<<"thousand"+" "
				else
					str<<units[4.to_s]+" "
				end
				n=n%1000
			elsif(name.length>=6 || name.length<8)
				value=(n/100000).to_s
				if(value.length==2)
					value_int=value.to_i
					value1=(value_int-value_int%10)
					str<<digits[value1.to_s]+" "
					if(value_int%10!=0)
						str<<digits[(value_int%10).to_s]+" "
					end
				else
					str<<digits[value]+" "
				end
				if(value=="1")
					str<<"lakh"+" "
				else
					str<<units[6.to_s]+" "
				end
				n=n%100000
			end
		end
		return str
	end
end
