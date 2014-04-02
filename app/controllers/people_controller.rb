class PeopleController < ApplicationController
   
 
  def index
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
	if(@person.profile=="Main Admin")
		@people = Person.find(:all)
	else
		@people = Person.find(:all,:conditions => "profile!='Main Admin'")
	end
  end
 
  def global_index
	@people = Person.find(:all)
  end
  def show
    @person = Person.find(params[:id])
  end
 
  def new
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@people = Person.find(@session.person_id)
    @person = Person.new

  end
 
  def create
    @person = Person.new(params[:person])
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@people = Person.find(@session.person_id)
    if @person.save
      @session = @person.sessions.create
      session[:id] = @session.id
      flash[:notice] = "Welcome #{@person.name}, you are now registered"
      redirect_to("/people/new")
    else
      render(:action => 'new')
    end
  end
 
  def edit
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@people = Person.find(@session.person_id)
    @person = Person.find(@user)
  end
 
  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      flash[:notice] = "Your account has been updated"
      redirect_to("/people/#{@person.id}")
    else
      render(:action => 'edit')
    end
  end
 
  def destroy
    Person.destroy(@user)
    session[:id] = @user = nil
    flash[:notice] = "You are now unregistered"
    redirect_to(root_url)
  end

  def global_reg
	@person = Person.new
    @people=Person.last
	@client_list=ClientList.last
	
  end
  
  def login_history
	@log_history= LoginHistory.paginate :page => params[:page] || 1, :per_page => 20, :order => "id DESC"
  end

  def verify_old_pwd
    pwd=params[:pwd]
    name=params[:name]
    return_val="0"
    @people=Person.find_by_name_and_password(params[:name], params[:pwd])
    if(@people)
      return_val=@people.name
      render :js=>"document.getElementById('error').innerHTML=''"
    else
      render :js=>" document.getElementById('old_pwd').value=''
                    document.getElementById('error').innerHTML='Wrong Password'"  
    end
  end
def edit_user
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@people = Person.find(@session.person_id)
    @person = Person.find(params[:id])
  end


end
