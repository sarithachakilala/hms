class PurchaseOrderReturnChildrenController < ApplicationController
  # GET /purchase_order_return_children
  # GET /purchase_order_return_children.xml
  def index
    @purchase_order_return_children = PurchaseOrderReturnChild.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @purchase_order_return_children }
    end
  end

  # GET /purchase_order_return_children/1
  # GET /purchase_order_return_children/1.xml
  def show
    @purchase_order_return_child = PurchaseOrderReturnChild.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @purchase_order_return_child }
    end
  end

  # GET /purchase_order_return_children/new
  # GET /purchase_order_return_children/new.xml
  def new
    @purchase_order_return_child = PurchaseOrderReturnChild.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @purchase_order_return_child }
    end
  end

  # GET /purchase_order_return_children/1/edit
  def edit
    @purchase_order_return_child = PurchaseOrderReturnChild.find(params[:id])
  end

  # POST /purchase_order_return_children
  # POST /purchase_order_return_children.xml
  def create
    @purchase_order_return_child = PurchaseOrderReturnChild.new(params[:purchase_order_return_child])

    respond_to do |format|
      if @purchase_order_return_child.save
        format.html { redirect_to(@purchase_order_return_child, :notice => 'PurchaseOrderReturnChild was successfully created.') }
        format.xml  { render :xml => @purchase_order_return_child, :status => :created, :location => @purchase_order_return_child }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @purchase_order_return_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /purchase_order_return_children/1
  # PUT /purchase_order_return_children/1.xml
  def update
    @purchase_order_return_child = PurchaseOrderReturnChild.find(params[:id])

    respond_to do |format|
      if @purchase_order_return_child.update_attributes(params[:purchase_order_return_child])
        format.html { redirect_to(@purchase_order_return_child, :notice => 'PurchaseOrderReturnChild was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @purchase_order_return_child.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /purchase_order_return_children/1
  # DELETE /purchase_order_return_children/1.xml
  def destroy
    @purchase_order_return_child = PurchaseOrderReturnChild.find(params[:id])
    @purchase_order_return_child.destroy

    respond_to do |format|
      format.html { redirect_to(purchase_order_return_children_url) }
      format.xml  { head :ok }
    end
  end
end
