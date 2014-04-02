class TestmasterChildrenController < ApplicationController
  # GET /testmaster_children
  # GET /testmaster_children.xml
  def index
    @testmaster_children = TestmasterChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @testmaster_children }
    end
  end

  # GET /testmaster_children/1
  # GET /testmaster_children/1.xml
  def show
    @testmaster_child = TestmasterChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @testmaster_child }
    end
  end

  # GET /testmaster_children/new
  # GET /testmaster_children/new.xml
  def new
    @testmaster_child = TestmasterChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @testmaster_child }
    end
  end

  # GET /testmaster_children/1/edit
  def edit
    @testmaster_child = TestmasterChild.find(params[:id])
  end

  # POST /testmaster_children
  # POST /testmaster_children.xml
  def create
    @testmaster_child = TestmasterChild.new(params[:testmaster_child])

    respond_to do |format|
      if @testmaster_child.save
        format.html { redirect_to(@testmaster_child, :notice => 'TestmasterChild was successfully created.') }
        format.xml  { render :xml => @testmaster_child, :status => :created, :location => @testmaster_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @testmaster_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /testmaster_children/1
  # PUT /testmaster_children/1.xml
  def update
    @testmaster_child = TestmasterChild.find(params[:id])

    respond_to do |format|
      if @testmaster_child.update_attributes(params[:testmaster_child])
        format.html { redirect_to(@testmaster_child, :notice => 'TestmasterChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @testmaster_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /testmaster_children/1
  # DELETE /testmaster_children/1.xml
  def destroy
    @testmaster_child = TestmasterChild.find(params[:id])
    @testmaster_child.destroy

    respond_to do |format|
      format.html { redirect_to(testmaster_children_url) }
      format.xml  { head :ok }
    end
  end
end
