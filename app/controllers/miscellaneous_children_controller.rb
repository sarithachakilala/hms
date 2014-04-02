class MiscellaneousChildrenController < ApplicationController
  # GET /miscellaneous_children
  # GET /miscellaneous_children.xml
  def index
    @miscellaneous_children = MiscellaneousChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @miscellaneous_children }
    end
  end

  # GET /miscellaneous_children/1
  # GET /miscellaneous_children/1.xml
  def show
    @miscellaneous_child = MiscellaneousChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @miscellaneous_child }
    end
  end

  # GET /miscellaneous_children/new
  # GET /miscellaneous_children/new.xml
  def new
    @miscellaneous_child = MiscellaneousChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @miscellaneous_child }
    end
  end

  # GET /miscellaneous_children/1/edit
  def edit
    @miscellaneous_child = MiscellaneousChild.find(params[:id])
  end

  # POST /miscellaneous_children
  # POST /miscellaneous_children.xml
  def create
    @miscellaneous_child = MiscellaneousChild.new(params[:miscellaneous_child])

    respond_to do |format|
      if @miscellaneous_child.save
        format.html { redirect_to(@miscellaneous_child, :notice => 'MiscellaneousChild was successfully created.') }
        format.xml  { render :xml => @miscellaneous_child, :status => :created, :location => @miscellaneous_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @miscellaneous_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /miscellaneous_children/1
  # PUT /miscellaneous_children/1.xml
  def update
    @miscellaneous_child = MiscellaneousChild.find(params[:id])

    respond_to do |format|
      if @miscellaneous_child.update_attributes(params[:miscellaneous_child])
        format.html { redirect_to(@miscellaneous_child, :notice => 'MiscellaneousChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @miscellaneous_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /miscellaneous_children/1
  # DELETE /miscellaneous_children/1.xml
  def destroy
    @miscellaneous_child = MiscellaneousChild.find(params[:id])
    @miscellaneous_child.destroy

    respond_to do |format|
      format.html { redirect_to(miscellaneous_children_url) }
      format.xml  { head :ok }
    end
  end
end
