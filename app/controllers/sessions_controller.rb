class SessionsController < ApplicationController
    before_filter :ensure_login, :only => :destroy
	before_filter :ensure_logout, :only => [:new, :create]
 
	def index
		@session = Session.new
		@notice=params[:address]
	end
 
	def new
		@session = Session.new
	end
 
	def create
		@session = Session.new(params[:session])
	    
		if @session.save
			session[:id] = @session.id
			people=Person.find_by_id(@session.person_id)
			
			login_history=LoginHistory.new
			login_history.name=@session.name
			login_history.status="Log in"
			login_history.login_time=Time.new
			login_history.save
			client_list=ClientList.find_by_hospital_name(people.client_name)
			if(client_list.expiry_date > Date.today)	
				if(people.expiry_date > Date.today)
					if((client_list.expiry_date-Date.today)<30)
						if(people.profile=="Main Admin")
							redirect_to("/home/main_admin")
						elsif(people.profile=="Admin")

 

							redirect_to("/home/admin",:notice => "Your software license is going to Expired within #{(client_list.expiry_date-Date.today).to_s} -days, Please contact Exleaz for license upgrade.")
						else
							redirect_to("/home",:notice => "Your software license is going to Expired within #{(client_list.expiry_date-Date.today).to_s} -days, Please contact Exleaz for license upgrade.")
						end
	
					else
						if(people.profile=="Main Admin")
							redirect_to("/home/main_admin")
						elsif(people.profile=="Admin")
							redirect_to("/home/admin")
						else
							redirect_to("/home")
						end
					end
				else
					session[:id] = @user = nil
					redirect_to("/sessions",:notice => 'Your Username and Password is expiried so Please contact the administrator at your Hospital for help.')
				end
			else
				session[:id] = @user = nil
				redirect_to("/sessions",:notice => 'Your Software is expiry so Please contact the administrator at your company for help.')
			end		
			
		else
			redirect_to("/sessions",:notice => 'Your login attempt has failed. The username or password may be incorrect, or your location or login time may be restricted. Please contact the administrator at your company for help.')
		end
	end
 
	def destroy
		@session = Session.find(session[:id])
		people=Person.find_by_id(@session.person_id)
		@login_history=LoginHistory.last(:conditions => "name = '#{people.name}'")
		@login_history.status="Log out"
		@login_history.logout_time=Time.new
		@login_history.update_attributes(params[:login_history])
		Session.destroy(@application_session)
		session[:id] = @user = nil
		redirect_to(root_url)
	end


end
