class NumberMastersController < ApplicationController
  # GET /number_masters
  # GET /number_masters.xml
  def index
    @number_masters = NumberMaster.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @number_masters }
    end
  end

  # GET /number_masters/1
  # GET /number_masters/1.xml
  def show
    @number_master = NumberMaster.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @number_master }
    end
  end

  # GET /number_masters/new
  # GET /number_masters/new.xml
  def new
    @number_master = NumberMaster.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @number_master }
    end
  end

  # GET /number_masters/1/edit
  def edit
    @number_master = NumberMaster.find(params[:id])
  end

  # POST /number_masters
  # POST /number_masters.xml
  def create
    @number_master = NumberMaster.new(params[:number_master])

    respond_to do |format|
      if @number_master.save
        format.html { redirect_to(@number_master) }
        format.xml  { render :xml => @number_master, :status => :created, :location => @number_master }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @number_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /number_masters/1
  # PUT /number_masters/1.xml
  def update
    @number_master = NumberMaster.find(params[:id])

    respond_to do |format|
      if @number_master.update_attributes(params[:number_master])
        format.html { redirect_to(@number_master, :notice => 'NumberMaster was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @number_master.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /number_masters/1
  # DELETE /number_masters/1.xml
  def destroy
    @number_master = NumberMaster.find(params[:id])
    @number_master.destroy

    respond_to do |format|
      format.html { redirect_to(number_masters_url) }
      format.xml  { head :ok }
    end
  end
end
