class NoticeBoardsController < ApplicationController
  # GET /notice_boards
  # GET /notice_boards.xml
  def index
    @notice_boards = NoticeBoard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @notice_boards }
    end
  end

  # GET /notice_boards/1
  # GET /notice_boards/1.xml
  def show
    @notice_board = NoticeBoard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @notice_board }
    end
  end

  # GET /notice_boards/new
  # GET /notice_boards/new.xml
  def new
    @notice_board = NoticeBoard.new
	@notice_boards = NoticeBoard.all(:order => "id DESC")
	@session_id=session[:id]
	@session = Session.find(session[:id])
	@person = Person.find(@session.person_id)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @notice_board }
    end
  end

  # GET /notice_boards/1/edit
  def edit
    @notice_board = NoticeBoard.find(params[:id])
  end

  # POST /notice_boards
  # POST /notice_boards.xml
  def create
    @notice_board = NoticeBoard.new(params[:notice_board])

    respond_to do |format|
      if @notice_board.save
        format.html { redirect_to(@notice_board, :notice => 'NoticeBoard was successfully created.') }
        format.xml  { render :xml => @notice_board, :status => :created, :location => @notice_board }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @notice_board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /notice_boards/1
  # PUT /notice_boards/1.xml
  def update
    @notice_board = NoticeBoard.find(params[:id])

    respond_to do |format|
      if @notice_board.update_attributes(params[:notice_board])
        format.html { redirect_to(@notice_board, :notice => 'NoticeBoard was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @notice_board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /notice_boards/1
  # DELETE /notice_boards/1.xml
  def destroy
    @notice_board = NoticeBoard.find(params[:id])
    @notice_board.destroy

    respond_to do |format|
      format.html { redirect_to(notice_boards_url) }
      format.xml  { head :ok }
    end
  end
  
  def select_department
		@department1 = EmployeeMaster.find(:all, :conditions=>"category = '#{params[:query]}' ")
		str=""
		for department in @department1
			str<<department.empid+" - "+department.name+"<division>"
		end
		render :text => str
  end
end
