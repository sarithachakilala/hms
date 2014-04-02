class PharmacyRangesController < ApplicationController
  # GET /pharmacy_ranges
  # GET /pharmacy_ranges.xml
  def index
    @pharmacy_ranges = PharmacyRange.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pharmacy_ranges }
    end
  end

  # GET /pharmacy_ranges/1
  # GET /pharmacy_ranges/1.xml
  def show
    @pharmacy_range = PharmacyRange.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pharmacy_range }
    end
  end

  # GET /pharmacy_ranges/new
  # GET /pharmacy_ranges/new.xml
  def new
    @pharmacy_range = PharmacyRange.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pharmacy_range }
    end
  end

  # GET /pharmacy_ranges/1/edit
  def edit
    @pharmacy_range = PharmacyRange.find(params[:id])
  end

  # POST /pharmacy_ranges
  # POST /pharmacy_ranges.xml
  def create
    @pharmacy_range = PharmacyRange.new(params[:pharmacy_range])

    respond_to do |format|
      if @pharmacy_range.save
        format.html { redirect_to(@pharmacy_range, :notice => 'PharmacyRange was successfully created.') }
        format.xml  { render :xml => @pharmacy_range, :status => :created, :location => @pharmacy_range }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pharmacy_range.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pharmacy_ranges/1
  # PUT /pharmacy_ranges/1.xml
  def update
    @pharmacy_range = PharmacyRange.find(params[:id])

    respond_to do |format|
      if @pharmacy_range.update_attributes(params[:pharmacy_range])
        format.html { redirect_to(@pharmacy_range, :notice => 'PharmacyRange was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pharmacy_range.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pharmacy_ranges/1
  # DELETE /pharmacy_ranges/1.xml
  def destroy
    @pharmacy_range = PharmacyRange.find(params[:id])
    @pharmacy_range.destroy

    respond_to do |format|
      format.html { redirect_to(pharmacy_ranges_url) }
      format.xml  { head :ok }
    end
  end
end
