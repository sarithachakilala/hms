class ConsultantVisitChildrenController < ApplicationController
  # GET /consultant_visit_children
  # GET /consultant_visit_children.xml
  def index
    @consultant_visit_children = ConsultantVisitChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @consultant_visit_children }
    end
  end

  # GET /consultant_visit_children/1
  # GET /consultant_visit_children/1.xml
  def show
    @consultant_visit_child = ConsultantVisitChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @consultant_visit_child }
    end
  end

  # GET /consultant_visit_children/new
  # GET /consultant_visit_children/new.xml
  def new
    @consultant_visit_child = ConsultantVisitChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @consultant_visit_child }
    end
  end

  # GET /consultant_visit_children/1/edit
  def edit
    @consultant_visit_child = ConsultantVisitChild.find(params[:id])
  end

  # POST /consultant_visit_children
  # POST /consultant_visit_children.xml
  def create
    @consultant_visit_child = ConsultantVisitChild.new(params[:consultant_visit_child])

    respond_to do |format|
      if @consultant_visit_child.save
        format.html { redirect_to(@consultant_visit_child, :notice => 'ConsultantVisitChild was successfully created.') }
        format.xml  { render :xml => @consultant_visit_child, :status => :created, :location => @consultant_visit_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @consultant_visit_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /consultant_visit_children/1
  # PUT /consultant_visit_children/1.xml
  def update
    @consultant_visit_child = ConsultantVisitChild.find(params[:id])

    respond_to do |format|
      if @consultant_visit_child.update_attributes(params[:consultant_visit_child])
        format.html { redirect_to(@consultant_visit_child, :notice => 'ConsultantVisitChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @consultant_visit_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /consultant_visit_children/1
  # DELETE /consultant_visit_children/1.xml
  def destroy
    @consultant_visit_child = ConsultantVisitChild.find(params[:id])
    @consultant_visit_child.destroy

    respond_to do |format|
      format.html { redirect_to(consultant_visit_children_url) }
      format.xml  { head :ok }
    end
  end
end
