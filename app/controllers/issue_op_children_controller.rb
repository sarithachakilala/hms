class IssueOpChildrenController < ApplicationController
  # GET /issue_op_children
  # GET /issue_op_children.xml
  def index
	@user_id = params[:user_id]
	@org=Person.find_by_id(@user_id)
	@issue_op_children = IssueOpChild.paginate :page => params[:page] || 1, :per_page => 10, :order => "id DESC", :conditions =>"org_code ='#{@org.org_code}'"
	  respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @issue_op_children }
    end
  end

  # GET /issue_op_children/1
  # GET /issue_op_children/1.xml
  def show
    @issue_op_child = IssueOpChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @issue_op_child }
    end
  end

  # GET /issue_op_children/new
  # GET /issue_op_children/new.xml
  def new
    @issue_op_child = IssueOpChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @issue_op_child }
    end
  end

  # GET /issue_op_children/1/edit
  def edit
    @issue_op_child = IssueOpChild.find(params[:id])
  end

  # POST /issue_op_children
  # POST /issue_op_children.xml
  def create
    @issue_op_child = IssueOpChild.new(params[:issue_op_child])

    respond_to do |format|
      if @issue_op_child.save
        format.html { redirect_to(@issue_op_child, :notice => 'IssueOpChild was successfully created.') }
        format.xml  { render :xml => @issue_op_child, :status => :created, :location => @issue_op_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @issue_op_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /issue_op_children/1
  # PUT /issue_op_children/1.xml
  def update
    @issue_op_child = IssueOpChild.find(params[:id])

    respond_to do |format|
      if @issue_op_child.update_attributes(params[:issue_op_child])
        format.html { redirect_to(@issue_op_child, :notice => 'IssueOpChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @issue_op_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_op_children/1
  # DELETE /issue_op_children/1.xml
  def destroy
    @issue_op_child = IssueOpChild.find(params[:id])
    @issue_op_child.destroy

    respond_to do |format|
      format.html { redirect_to(issue_op_children_url) }
      format.xml  { head :ok }
    end
  end
end
