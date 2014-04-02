class PharmacyPaymentChildrenController < ApplicationController
  # GET /pharmacy_payment_children
  # GET /pharmacy_payment_children.xml
  def index
    @pharmacy_payment_children = PharmacyPaymentChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pharmacy_payment_children }
    end
  end

  # GET /pharmacy_payment_children/1
  # GET /pharmacy_payment_children/1.xml
  def show
    @pharmacy_payment_child = PharmacyPaymentChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pharmacy_payment_child }
    end
  end

  # GET /pharmacy_payment_children/new
  # GET /pharmacy_payment_children/new.xml
  def new
    @pharmacy_payment_child = PharmacyPaymentChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pharmacy_payment_child }
    end
  end

  # GET /pharmacy_payment_children/1/edit
  def edit
    @pharmacy_payment_child = PharmacyPaymentChild.find(params[:id])
  end

  # POST /pharmacy_payment_children
  # POST /pharmacy_payment_children.xml
  def create
    @pharmacy_payment_child = PharmacyPaymentChild.new(params[:pharmacy_payment_child])

    respond_to do |format|
      if @pharmacy_payment_child.save
        format.html { redirect_to(@pharmacy_payment_child, :notice => 'PharmacyPaymentChild was successfully created.') }
        format.xml  { render :xml => @pharmacy_payment_child, :status => :created, :location => @pharmacy_payment_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pharmacy_payment_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pharmacy_payment_children/1
  # PUT /pharmacy_payment_children/1.xml
  def update
    @pharmacy_payment_child = PharmacyPaymentChild.find(params[:id])

    respond_to do |format|
      if @pharmacy_payment_child.update_attributes(params[:pharmacy_payment_child])
        format.html { redirect_to(@pharmacy_payment_child, :notice => 'PharmacyPaymentChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pharmacy_payment_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pharmacy_payment_children/1
  # DELETE /pharmacy_payment_children/1.xml
  def destroy
    @pharmacy_payment_child = PharmacyPaymentChild.find(params[:id])
    @pharmacy_payment_child.destroy

    respond_to do |format|
      format.html { redirect_to(pharmacy_payment_children_url) }
      format.xml  { head :ok }
    end
  end
end
