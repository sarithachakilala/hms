class WardCostsController < ApplicationController
  # GET /ward_costs
  # GET /ward_costs.xml
  def index
    @ward_costs = WardCost.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ward_costs }
    end
  end

  # GET /ward_costs/1
  # GET /ward_costs/1.xml
  def show
    @ward_cost = WardCost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ward_cost }
    end
  end

  # GET /ward_costs/new
  # GET /ward_costs/new.xml
  def new
    @ward_cost = WardCost.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ward_cost }
    end
  end

  # GET /ward_costs/1/edit
  def edit
    @ward_cost = WardCost.find(params[:id])
  end

  # POST /ward_costs
  # POST /ward_costs.xml
  def create
    @ward_cost = WardCost.new(params[:ward_cost])

    respond_to do |format|
      if @ward_cost.save
        format.html { redirect_to(@ward_cost, :notice => 'WardCost was successfully created.') }
        format.xml  { render :xml => @ward_cost, :status => :created, :location => @ward_cost }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ward_cost.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ward_costs/1
  # PUT /ward_costs/1.xml
  def update
    @ward_cost = WardCost.find(params[:id])

    respond_to do |format|
      if @ward_cost.update_attributes(params[:ward_cost])
        format.html { redirect_to(@ward_cost, :notice => 'WardCost was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ward_cost.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ward_costs/1
  # DELETE /ward_costs/1.xml
  def destroy
    @ward_cost = WardCost.find(params[:id])
    @ward_cost.destroy

    respond_to do |format|
      format.html { redirect_to(ward_costs_url) }
      format.xml  { head :ok }
    end
  end
end
